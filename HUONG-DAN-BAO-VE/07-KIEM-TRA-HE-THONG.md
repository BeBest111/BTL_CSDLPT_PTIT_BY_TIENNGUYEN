# ✓ KIỂM TRA HỆ THỐNG
## Verify mọi thứ hoạt động đúng

---

## 🎯 MỤC TIÊU

File này giúp bạn:
- Kiểm tra hệ thống sau khi cài
- Phát hiện lỗi sớm
- Đảm bảo sẵn sàng demo
- Troubleshoot nếu có vấn đề

---

## ✅ CHECKLIST KIỂM TRA

### Level 1: Docker & Containers (Cơ bản)
### Level 2: Database & Data (Quan trọng)
### Level 3: Business Logic (Advanced)
### Level 4: Distributed System (Expert)

---

## 📊 LEVEL 1: DOCKER & CONTAINERS

### Test 1.1: Docker installed?
```bash
docker --version
docker-compose --version
```

**✅ Expected:**
```
Docker version 28.5.1, build XXX
Docker Compose version v2.40.3
```

**❌ If failed:** Cài lại Docker (file 06)

---

### Test 1.2: Containers running?
```bash
docker ps
```

**✅ Expected:** 3 containers với status "Up"
```
CONTAINER ID   IMAGE                        NAMES         STATUS
abc123...      mssql/server:2019-latest     SITE_HANOI    Up 5 minutes
def456...      mssql/server:2019-latest     SITE_DANANG   Up 5 minutes
ghi789...      mssql/server:2019-latest     SITE_SAIGON   Up 5 minutes
```

**❌ If không có containers:**
```bash
docker-compose up -d
sleep 60
docker ps
```

---

### Test 1.3: Ports listening?
```bash
sudo netstat -tulpn | grep -E "1433|1434|1435"
```

**✅ Expected:**
```
tcp6   0   0 :::1433   :::*   LISTEN   1234/docker-proxy
tcp6   0   0 :::1434   :::*   LISTEN   5678/docker-proxy
tcp6   0   0 :::1435   :::*   LISTEN   9012/docker-proxy
```

**❌ If không thấy:** Port bị conflict
```bash
# Check what's using port
sudo lsof -i :1433
# Kill or change port
```

---

### Test 1.4: Network exists?
```bash
docker network ls | grep distributed
```

**✅ Expected:**
```
abc123def456   distributed_db_network   bridge   local
```

---

### Test 1.5: IPs assigned?
```bash
docker inspect SITE_HANOI | grep IPAddress
docker inspect SITE_DANANG | grep IPAddress
docker inspect SITE_SAIGON | grep IPAddress
```

**✅ Expected:**
```
"IPAddress": "172.20.0.11",
"IPAddress": "172.20.0.12",
"IPAddress": "172.20.0.13",
```

---

### Test 1.6: Volumes exist?
```bash
docker volume ls | grep sqlserver
```

**✅ Expected:**
```
local   sqlserver_hanoi
local   sqlserver_danang
local   sqlserver_saigon
```

---

### Test 1.7: Resource usage OK?
```bash
docker stats --no-stream
```

**✅ Expected:** Memory < 80%, CPU < 50%
```
NAME          CPU %   MEM USAGE / LIMIT   MEM %
SITE_HANOI    2.5%    1.2GiB / 8GiB       15%
SITE_DANANG   2.3%    1.1GiB / 8GiB       14%
SITE_SAIGON   2.4%    1.15GiB / 8GiB      14%
```

**❌ If > 80%:** Cần thêm RAM hoặc giảm containers

---

## 💾 LEVEL 2: DATABASE & DATA

### Test 2.1: SQL Server responsive?
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT @@VERSION"
```

**✅ Expected:** Version string
```
Microsoft SQL Server 2019 (RTM-CU24) (KB5031908) - 15.0.4355.3 (X64)
...
```

**❌ If "Login timeout":** Wait 60s, try again

---

### Test 2.2: Database exists?
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT name FROM sys.databases WHERE name='QuanLyNhanSu'"
```

**✅ Expected:**
```
name
QuanLyNhanSu

(1 rows affected)
```

**❌ If empty:** Create database
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "CREATE DATABASE QuanLyNhanSu"
```

---

### Test 2.3: Tables exist?
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT COUNT(*) AS TableCount FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'"
```

**✅ Expected:**
```
TableCount
10

(1 rows affected)
```
(8 main tables + 2 audit logs)

**❌ If < 10:** Run HR.sql
```bash
docker cp HR.sql SITE_HANOI:/tmp/
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -i /tmp/HR.sql
```

---

### Test 2.4: Data exists?
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT 
      (SELECT COUNT(*) FROM NhanVien) AS NhanVien,
      (SELECT COUNT(*) FROM ChiNhanh) AS ChiNhanh,
      (SELECT COUNT(*) FROM PhongBan) AS PhongBan,
      (SELECT COUNT(*) FROM ChucVu) AS ChucVu"
```

**✅ Expected:**
```
NhanVien  ChiNhanh  PhongBan  ChucVu
40        10        10        20

(1 rows affected)
```

**❌ If zeros:** Run HR-Data.sql
```bash
docker cp HR-Data.sql SITE_HANOI:/tmp/
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -i /tmp/HR-Data.sql
```

---

### Test 2.5: Sample data integrity?
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; 
      SELECT TOP 3 HoTen, Email FROM NhanVien"
```

**✅ Expected:** Real data
```
HoTen               Email
Nguyễn Văn An       an.nv@company.com
Trần Thị Bình       binh.tt@company.com
Lê Văn Cường        cuong.lv@company.com
```

---

## 🔧 LEVEL 3: BUSINESS LOGIC

### Test 3.1: Views exist?
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT COUNT(*) FROM sys.views WHERE name LIKE 'View_%'"
```

**✅ Expected:**
```
14

(1 rows affected)
```

---

### Test 3.2: View works?
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT COUNT(*) FROM View_NhanVien_CN01"
```

**✅ Expected:** Some number (employees in CN01)
```
8

(1 rows affected)
```

---

### Test 3.3: Stored Procedures exist?
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT COUNT(*) FROM sys.procedures WHERE name LIKE 'sp_%'"
```

**✅ Expected:**
```
6

(1 rows affected)
```

---

### Test 3.4: Procedure works?
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; EXEC sp_ThongKeNhanVien"
```

**✅ Expected:** Statistics output
```
TongNhanVien  TongPhongBan  TongDuAn
40            10            15
```

---

### Test 3.5: Functions exist?
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT COUNT(*) FROM sys.objects WHERE type IN ('FN', 'IF', 'TF') AND name LIKE 'fn_%'"
```

**✅ Expected:**
```
6

(1 rows affected)
```

---

### Test 3.6: Function works?
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT dbo.fn_TinhTuoi('1990-05-15') AS Tuoi"
```

**✅ Expected:**
```
Tuoi
34

(1 rows affected)
```

---

### Test 3.7: Triggers exist?
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT COUNT(*) FROM sys.triggers WHERE name LIKE 'trg_%'"
```

**✅ Expected:**
```
4

(1 rows affected)
```

---

### Test 3.8: Indexes exist?
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT COUNT(*) FROM sys.indexes WHERE name IS NOT NULL AND name NOT LIKE 'PK_%'"
```

**✅ Expected:** >= 12
```
15

(1 rows affected)
```

---

## 🌐 LEVEL 4: DISTRIBUTED SYSTEM

### Test 4.1: All sites have databases?
```bash
# HANOI
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT 'HANOI' AS Site, COUNT(*) AS NhanVien FROM QuanLyNhanSu.dbo.NhanVien"

# DANANG
docker exec SITE_DANANG /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT 'DANANG' AS Site, COUNT(*) AS NhanVien FROM QuanLyNhanSu.dbo.NhanVien"

# SAIGON
docker exec SITE_SAIGON /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT 'SAIGON' AS Site, COUNT(*) AS NhanVien FROM QuanLyNhanSu.dbo.NhanVien"
```

**✅ Expected:**
```
Site    NhanVien
HANOI   40
DANANG  40
SAIGON  40
```

---

### Test 4.2: Linked Servers configured?
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT name FROM sys.servers WHERE server_id > 0"
```

**✅ Expected:**
```
name
SITE_DANANG
SITE_SAIGON

(2 rows affected)
```

---

### Test 4.3: Linked Server queries work?
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT COUNT(*) FROM SITE_DANANG.QuanLyNhanSu.dbo.ChiNhanh"
```

**✅ Expected:**
```
10

(1 rows affected)
```

**❌ If error:** Reconfigure Linked Server

---

### Test 4.4: Cross-site aggregation?
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT 'HANOI' AS Site, COUNT(*) AS Total FROM QuanLyNhanSu.dbo.NhanVien
      UNION ALL
      SELECT 'DANANG', COUNT(*) FROM SITE_DANANG.QuanLyNhanSu.dbo.NhanVien
      UNION ALL
      SELECT 'SAIGON', COUNT(*) FROM SITE_SAIGON.QuanLyNhanSu.dbo.NhanVien"
```

**✅ Expected:**
```
Site    Total
HANOI   40
DANANG  40
SAIGON  40

(3 rows affected)
```

---

### Test 4.5: Network connectivity?
```bash
docker exec SITE_HANOI ping -c 3 172.20.0.12
docker exec SITE_HANOI ping -c 3 172.20.0.13
```

**✅ Expected:** 0% packet loss
```
3 packets transmitted, 3 received, 0% packet loss
```

---

## 🔥 AUTOMATED TEST SCRIPT

Chạy tất cả tests 1 lúc:

```bash
#!/bin/bash

echo "=== LEVEL 1: DOCKER & CONTAINERS ==="
echo -n "1.1 Docker installed: "
docker --version && echo "✓" || echo "✗"

echo -n "1.2 Containers running: "
[ $(docker ps | grep -c SITE_) -eq 3 ] && echo "✓" || echo "✗"

echo -n "1.3 Ports listening: "
[ $(sudo netstat -tulpn | grep -c -E "1433|1434|1435") -ge 3 ] && echo "✓" || echo "✗"

echo ""
echo "=== LEVEL 2: DATABASE & DATA ==="
echo -n "2.1 SQL Server responsive: "
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT 1" &>/dev/null && echo "✓" || echo "✗"

echo -n "2.2 Database exists: "
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT name FROM sys.databases WHERE name='QuanLyNhanSu'" | grep -q QuanLyNhanSu && echo "✓" || echo "✗"

echo -n "2.3 Tables exist (10): "
COUNT=$(docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C -h-1 -W \
  -Q "USE QuanLyNhanSu; SELECT COUNT(*) FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'" | tr -d ' ')
[ "$COUNT" -eq 10 ] && echo "✓" || echo "✗ (Found: $COUNT)"

echo -n "2.4 Data exists (40 employees): "
COUNT=$(docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C -h-1 -W \
  -Q "USE QuanLyNhanSu; SELECT COUNT(*) FROM NhanVien" | tr -d ' ')
[ "$COUNT" -eq 40 ] && echo "✓" || echo "✗ (Found: $COUNT)"

echo ""
echo "=== LEVEL 3: BUSINESS LOGIC ==="
echo -n "3.1 Views exist (14): "
COUNT=$(docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C -h-1 -W \
  -Q "USE QuanLyNhanSu; SELECT COUNT(*) FROM sys.views WHERE name LIKE 'View_%'" | tr -d ' ')
[ "$COUNT" -eq 14 ] && echo "✓" || echo "✗ (Found: $COUNT)"

echo -n "3.2 Procedures exist (6): "
COUNT=$(docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C -h-1 -W \
  -Q "USE QuanLyNhanSu; SELECT COUNT(*) FROM sys.procedures WHERE name LIKE 'sp_%'" | tr -d ' ')
[ "$COUNT" -eq 6 ] && echo "✓" || echo "✗ (Found: $COUNT)"

echo -n "3.3 Functions exist (6): "
COUNT=$(docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C -h-1 -W \
  -Q "USE QuanLyNhanSu; SELECT COUNT(*) FROM sys.objects WHERE type IN ('FN', 'IF', 'TF') AND name LIKE 'fn_%'" | tr -d ' ')
[ "$COUNT" -eq 6 ] && echo "✓" || echo "✗ (Found: $COUNT)"

echo -n "3.4 Triggers exist (4): "
COUNT=$(docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C -h-1 -W \
  -Q "USE QuanLyNhanSu; SELECT COUNT(*) FROM sys.triggers WHERE name LIKE 'trg_%'" | tr -d ' ')
[ "$COUNT" -eq 4 ] && echo "✓" || echo "✗ (Found: $COUNT)"

echo ""
echo "=== LEVEL 4: DISTRIBUTED SYSTEM ==="
echo -n "4.1 Linked Servers configured: "
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT name FROM sys.servers WHERE server_id > 0" | grep -q SITE_DANANG && echo "✓" || echo "✗"

echo -n "4.2 Linked Server query works: "
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT COUNT(*) FROM SITE_DANANG.QuanLyNhanSu.dbo.ChiNhanh" &>/dev/null && echo "✓" || echo "✗"

echo ""
echo "=== SUMMARY ==="
echo "If all tests ✓ → System ready for demo! 🎉"
echo "If any tests ✗ → Fix issues above"
```

Save as `test-system.sh`, run:
```bash
chmod +x test-system.sh
./test-system.sh
```

---

## 📊 SUCCESS CRITERIA

**Minimum để demo:**
- ✅ Level 1: 100% passed
- ✅ Level 2: 100% passed
- ✅ Level 3: >= 90% passed
- ✅ Level 4: >= 80% passed

**Ideal:**
- ✅ All 100% passed

---

## 📖 NEXT STEPS

Sau khi verify:
- `08-CAC-LENH-THUONG-DUNG.md` - Common commands
- `09-CHUAN-BI-BAO-VE.md` - Defense prep
- `10-KICH-BAN-DEMO.md` - Demo script

---

**System verified! Sẵn sàng demo! 🚀**
