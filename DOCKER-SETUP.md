# 🐳 TRIỂN KHAI NHANH VỚI DOCKER
## Alternative: Dùng Docker thay vì VirtualBox

---

## ⚡ ƯU ĐIỂM DOCKER

- ✅ **Nhanh hơn:** Setup trong 30 phút thay vì 10 giờ
- ✅ **Nhẹ hơn:** Chỉ cần 8GB RAM thay vì 16GB
- ✅ **Dễ hơn:** Tự động hóa bằng scripts
- ✅ **Linh hoạt:** Dễ dàng xóa và tạo lại

---

## 📋 YÊU CẦU

- Windows 10/11 Pro hoặc Linux
- Docker Desktop installed
- 8GB RAM minimum
- 50GB disk space

---

## 🚀 BƯỚC 1: CÀI ĐẶT DOCKER

### Windows

```powershell
# Download Docker Desktop từ:
https://www.docker.com/products/docker-desktop

# Cài đặt và khởi động lại
# Enable WSL 2 nếu được yêu cầu
```

### Linux (Ubuntu)

```bash
# Cài Docker
sudo apt-get update
sudo apt-get install docker.io docker-compose -y

# Add user to docker group
sudo usermod -aG docker $USER
newgrp docker

# Verify
docker --version
docker-compose --version
```

---

## 🚀 BƯỚC 2: TẠO DOCKER COMPOSE FILE

Tạo file `docker-compose.yml`:

```yaml
version: '3.8'

services:
  # Site 1 - Hà Nội (Publisher)
  sqlserver-hanoi:
    image: mcr.microsoft.com/mssql/server:2019-latest
    container_name: SITE_HANOI
    hostname: SITE-HANOI
    environment:
      - ACCEPT_EULA=Y
      - SA_PASSWORD=Admin@123456
      - MSSQL_PID=Developer
      - MSSQL_AGENT_ENABLED=true
    ports:
      - "1433:1433"
    volumes:
      - hanoi-data:/var/opt/mssql
      - ./scripts:/scripts
    networks:
      sql_network:
        ipv4_address: 172.20.0.101
    restart: unless-stopped

  # Site 2 - Đà Nẵng (Subscriber)
  sqlserver-danang:
    image: mcr.microsoft.com/mssql/server:2019-latest
    container_name: SITE_DANANG
    hostname: SITE-DANANG
    environment:
      - ACCEPT_EULA=Y
      - SA_PASSWORD=Admin@123456
      - MSSQL_PID=Developer
      - MSSQL_AGENT_ENABLED=true
    ports:
      - "1434:1433"
    volumes:
      - danang-data:/var/opt/mssql
      - ./scripts:/scripts
    networks:
      sql_network:
        ipv4_address: 172.20.0.102
    restart: unless-stopped

  # Site 3 - Sài Gòn (Subscriber)
  sqlserver-saigon:
    image: mcr.microsoft.com/mssql/server:2019-latest
    container_name: SITE_SAIGON
    hostname: SITE-SAIGON
    environment:
      - ACCEPT_EULA=Y
      - SA_PASSWORD=Admin@123456
      - MSSQL_PID=Developer
      - MSSQL_AGENT_ENABLED=true
    ports:
      - "1435:1433"
    volumes:
      - saigon-data:/var/opt/mssql
      - ./scripts:/scripts
    networks:
      sql_network:
        ipv4_address: 172.20.0.103
    restart: unless-stopped

networks:
  sql_network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/24

volumes:
  hanoi-data:
  danang-data:
  saigon-data:
```

---

## 🚀 BƯỚC 3: KHỞI ĐỘNG CONTAINERS

```bash
# Tạo thư mục scripts
mkdir scripts

# Copy các file SQL vào scripts/
cp HR.sql scripts/
cp HR-Data.sql scripts/
cp Physical-Implementation.sql scripts/

# Khởi động containers
docker-compose up -d

# Kiểm tra status
docker ps

# Expected output:
# CONTAINER ID   IMAGE          STATUS         PORTS                    NAMES
# xxx            mssql:2019     Up 2 minutes   0.0.0.0:1433->1433/tcp   SITE_HANOI
# xxx            mssql:2019     Up 2 minutes   0.0.0.0:1434->1433/tcp   SITE_DANANG
# xxx            mssql:2019     Up 2 minutes   0.0.0.0:1435->1433/tcp   SITE_SAIGON
```

**Screenshot 01: docker_compose_up.png**

---

## 🚀 BƯỚC 4: KIỂM TRA KẾT NỐI

### Test ping giữa containers

```bash
# Ping từ HANOI → DANANG
docker exec SITE_HANOI ping -c 4 172.20.0.102

# Ping từ HANOI → SAIGON
docker exec SITE_HANOI ping -c 4 172.20.0.103
```

**Screenshot 02: docker_ping_test.png**

### Test SQL Server

```bash
# Test connection SITE_HANOI
docker exec -it SITE_HANOI /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' \
  -Q "SELECT @@SERVERNAME, @@VERSION"

# Test connection SITE_DANANG
docker exec -it SITE_DANANG /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' \
  -Q "SELECT @@SERVERNAME, @@VERSION"

# Test connection SITE_SAIGON
docker exec -it SITE_SAIGON /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' \
  -Q "SELECT @@SERVERNAME, @@VERSION"
```

**Screenshot 03: docker_sqlserver_test.png**

---

## 🚀 BƯỚC 5: TẠO DATABASE VÀ DỮ LIỆU

### 5.1. Chạy scripts trên SITE_HANOI

```bash
# Copy scripts vào container
docker cp HR.sql SITE_HANOI:/tmp/
docker cp HR-Data.sql SITE_HANOI:/tmp/
docker cp Physical-Implementation.sql SITE_HANOI:/tmp/

# Chạy HR.sql
docker exec -it SITE_HANOI /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' \
  -i /tmp/HR.sql

# Chạy HR-Data.sql
docker exec -it SITE_HANOI /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' \
  -i /tmp/HR-Data.sql

# Chạy Physical-Implementation.sql
docker exec -it SITE_HANOI /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' \
  -i /tmp/Physical-Implementation.sql
```

**Screenshot 04: docker_run_scripts.png**

### 5.2. Verify database

```bash
docker exec -it SITE_HANOI /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' \
  -Q "USE QuanLyNhanSu; SELECT COUNT(*) as Total FROM NhanVien"
```

**Screenshot 05: docker_verify_database.png**

---

## 🚀 BƯỚC 6: CONNECT TỪ SSMS

### Kết nối từ máy host

**SITE_HANOI:**
```
Server: localhost,1433
Login: sa
Password: Admin@123456
```

**Screenshot 06: ssms_connect_hanoi.png**

**SITE_DANANG:**
```
Server: localhost,1434
Login: sa
Password: Admin@123456
```

**Screenshot 07: ssms_connect_danang.png**

**SITE_SAIGON:**
```
Server: localhost,1435
Login: sa
Password: Admin@123456
```

**Screenshot 08: ssms_connect_saigon.png**

---

## 🚀 BƯỚC 7: TẠO LINKED SERVER

### Script tạo Linked Server tự động

Tạo file `scripts/create-linked-servers.sql`:

```sql
-- Trên SITE_HANOI
-- Link to SITE_DANANG
EXEC sp_addlinkedserver 
    @server = 'SITE_DANANG',
    @srvproduct = '',
    @provider = 'SQLNCLI',
    @datasrc = '172.20.0.102';

EXEC sp_addlinkedsrvlogin 
    @rmtsrvname = 'SITE_DANANG',
    @useself = 'FALSE',
    @rmtuser = 'sa',
    @rmtpassword = 'Admin@123456';

-- Link to SITE_SAIGON
EXEC sp_addlinkedserver 
    @server = 'SITE_SAIGON',
    @srvproduct = '',
    @provider = 'SQLNCLI',
    @datasrc = '172.20.0.103';

EXEC sp_addlinkedsrvlogin 
    @rmtsrvname = 'SITE_SAIGON',
    @useself = 'FALSE',
    @rmtuser = 'sa',
    @rmtpassword = 'Admin@123456';

-- Test connections
SELECT @@SERVERNAME AS LocalServer;
SELECT * FROM SITE_DANANG.master.sys.databases;
SELECT * FROM SITE_SAIGON.master.sys.databases;
```

### Chạy script

```bash
docker cp scripts/create-linked-servers.sql SITE_HANOI:/tmp/

docker exec -it SITE_HANOI /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' \
  -i /tmp/create-linked-servers.sql
```

**Screenshot 09: docker_linked_server_created.png**

---

## 🚀 BƯỚC 8: TẠO REPLICATION

**LƯU Ý:** Docker Linux containers **KHÔNG HỖ TRỢ** SQL Server Replication đầy đủ.

### Workaround: Sử dụng Log Shipping hoặc Manual Sync

#### Option A: Log Shipping Script

```sql
-- Tạo backup job trên SITE_HANOI
USE QuanLyNhanSu;
GO

-- Full backup
BACKUP DATABASE QuanLyNhanSu
TO DISK = '/var/opt/mssql/backup/QuanLyNhanSu.bak'
WITH FORMAT;

-- Transaction log backup
BACKUP LOG QuanLyNhanSu
TO DISK = '/var/opt/mssql/backup/QuanLyNhanSu.trn'
WITH FORMAT;
```

#### Option B: Manual Sync Script

```sql
-- Tạo database trên SITE_DANANG và SITE_SAIGON
-- Copy data bằng BCP hoặc INSERT...SELECT via Linked Server
```

**Screenshot 10: docker_manual_sync.png**

---

## 🚀 BƯỚC 9: TEST PHÂN TÁN

### Test INSERT qua Linked Server

```sql
-- Trên SITE_HANOI (từ SSMS)
USE QuanLyNhanSu;
GO

-- Insert local
EXEC sp_ThemNhanVien 
    @ID_NhanVien = 'DOCKER01',
    @ID_DuAn = 'NTDA01',
    @ID_ChucVu = 'NTCV07',
    @ID_ChiNhanh = 'CN04',
    @ID_PhongBan = 'NTPB01',
    @HoTen = N'Docker Test',
    @NgaySinh = '1995-05-15',
    @GioiTinh = N'Nam',
    @DanToc = N'Kinh',
    @CCCD = '888888888888',
    @SoDienThoai = '0888888888',
    @Email = 'docker@test.com',
    @DiaChi = N'Docker Container';

-- Verify
SELECT * FROM NhanVien WHERE ID_NhanVien = 'DOCKER01';

-- Query from SITE_DANANG via Linked Server
SELECT * FROM SITE_DANANG.QuanLyNhanSu.dbo.NhanVien 
WHERE ID_NhanVien = 'DOCKER01';
```

**Screenshot 11: docker_test_insert.png**

### Test Distributed Query

```sql
-- Union data from all sites
SELECT 'HANOI' AS Site, COUNT(*) AS Total
FROM QuanLyNhanSu.dbo.NhanVien

UNION ALL

SELECT 'DANANG' AS Site, COUNT(*) AS Total
FROM SITE_DANANG.QuanLyNhanSu.dbo.NhanVien

UNION ALL

SELECT 'SAIGON' AS Site, COUNT(*) AS Total
FROM SITE_SAIGON.QuanLyNhanSu.dbo.NhanVien;
```

**Screenshot 12: docker_distributed_query.png**

---

## 🚀 BƯỚC 10: MONITORING

### Container logs

```bash
# View logs
docker logs SITE_HANOI
docker logs SITE_DANANG
docker logs SITE_SAIGON

# Follow logs
docker logs -f SITE_HANOI
```

**Screenshot 13: docker_logs.png**

### Resource usage

```bash
# Check resource usage
docker stats

# Expected output:
# CONTAINER    CPU %   MEM USAGE / LIMIT   MEM %   NET I/O
# SITE_HANOI   2%      1.5GiB / 8GiB      18%     5MB / 2MB
# SITE_DANANG  1%      1.2GiB / 8GiB      15%     3MB / 1MB
# SITE_SAIGON  1%      1.2GiB / 8GiB      15%     3MB / 1MB
```

**Screenshot 14: docker_stats.png**

---

## 🛠️ UTILITY SCRIPTS

### Backup all databases

```bash
#!/bin/bash
# backup-all.sh

echo "Backing up SITE_HANOI..."
docker exec SITE_HANOI /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' \
  -Q "BACKUP DATABASE QuanLyNhanSu TO DISK='/var/opt/mssql/backup/QuanLyNhanSu_HANOI.bak' WITH FORMAT"

echo "Backing up SITE_DANANG..."
docker exec SITE_DANANG /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' \
  -Q "BACKUP DATABASE QuanLyNhanSu TO DISK='/var/opt/mssql/backup/QuanLyNhanSu_DANANG.bak' WITH FORMAT"

echo "Backing up SITE_SAIGON..."
docker exec SITE_SAIGON /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' \
  -Q "BACKUP DATABASE QuanLyNhanSu TO DISK='/var/opt/mssql/backup/QuanLyNhanSu_SAIGON.bak' WITH FORMAT"

echo "Backup completed!"
```

### Cleanup script

```bash
#!/bin/bash
# cleanup.sh

echo "Stopping containers..."
docker-compose down

echo "Removing volumes..."
docker volume rm btl-csdlpt-ptit_hanoi-data
docker volume rm btl-csdlpt-ptit_danang-data
docker volume rm btl-csdlpt-ptit_saigon-data

echo "Cleanup completed!"
```

---

## 📊 SO SÁNH: DOCKER VS VIRTUALBOX

| Tiêu chí | Docker | VirtualBox |
|----------|--------|------------|
| **Setup Time** | 30 phút | 10 giờ |
| **RAM Required** | 8GB | 16GB |
| **Disk Space** | 10GB | 150GB |
| **CPU Usage** | Thấp | Cao |
| **Replication Support** | ⚠️ Limited | ✅ Full |
| **Ease of Use** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ |
| **Screenshot Count** | ~15 | ~230 |

---

## ⚠️ HẠN CHẾ CỦA DOCKER

1. **Không hỗ trợ SQL Server Replication đầy đủ**
   - Linux containers không có Windows-only features
   - Cần dùng workaround (Log Shipping, Manual Sync)

2. **Không có SQL Server Agent UI**
   - Chỉ có command line
   
3. **Screenshot ít hơn**
   - Giảng viên có thể yêu cầu nhiều screenshots hơn

---

## ✅ CHECKLIST DOCKER

- [ ] Cài Docker Desktop
- [ ] Tạo docker-compose.yml
- [ ] Khởi động containers (Screenshot 01)
- [ ] Test ping (Screenshot 02)
- [ ] Test SQL connection (Screenshot 03)
- [ ] Run scripts (Screenshot 04)
- [ ] Verify database (Screenshot 05)
- [ ] Connect SSMS (Screenshots 06-08)
- [ ] Create Linked Servers (Screenshot 09)
- [ ] Setup sync mechanism (Screenshot 10)
- [ ] Test INSERT (Screenshot 11)
- [ ] Test distributed query (Screenshot 12)
- [ ] Monitor logs (Screenshot 13)
- [ ] Check stats (Screenshot 14)

**Tổng screenshots: ~15 (thay vì 230)**

---

## 🎯 KẾT LUẬN

### Nên dùng Docker khi:
✅ Muốn setup nhanh cho demo
✅ Có ít thời gian
✅ Máy yếu (< 16GB RAM)
✅ Chỉ cần test Linked Server và distributed queries

### Nên dùng VirtualBox khi:
✅ Cần đầy đủ SQL Server Replication
✅ Giảng viên yêu cầu nhiều screenshots
✅ Muốn môi trường giống production
✅ Có đủ thời gian và tài nguyên

---

## 📞 TROUBLESHOOTING

### Container không start

```bash
# Check logs
docker logs SITE_HANOI

# Common issues:
# 1. Port already in use
sudo lsof -i :1433
# Kill process or change port

# 2. Not enough memory
docker system prune
```

### Không connect được SQL Server

```bash
# Check if SQL Server is ready
docker exec SITE_HANOI /opt/mssql-tools/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' \
  -Q "SELECT 1"

# Wait 30 seconds after container start
```

### Linked Server không hoạt động

```sql
-- Check configuration
EXEC sp_helpserver;

-- Reconfigure
EXEC sp_dropserver 'SITE_DANANG';
-- Then recreate
```

---

**Tạo bởi:** Nhóm 5 - CSDLPT - PTIT

**Ngày:** 31/10/2025

**Thời gian thực hiện:** 30-60 phút

**Khuyến nghị:** Dùng cho demo nhanh, nhưng VirtualBox vẫn tốt hơn cho bài tập lớn chính thức
