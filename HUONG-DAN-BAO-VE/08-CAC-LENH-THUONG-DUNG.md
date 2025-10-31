# 🔧 CÁC LỆNH THƯỜNG DÙNG
## Quick reference cho demo và troubleshooting

---

## 🎯 MỤC ĐÍCH

File này là **cheat sheet** - copy & paste nhanh cho:
- Demo commands
- Troubleshooting
- Quick checks
- Common queries

---

## 🚀 START/STOP SYSTEM

### Start toàn bộ hệ thống:
```bash
docker-compose up -d
```

### Stop toàn bộ:
```bash
docker-compose down
```

### Restart 1 container:
```bash
docker restart SITE_HANOI
```

### Restart tất cả:
```bash
docker restart SITE_HANOI SITE_DANANG SITE_SAIGON
```

---

## 📊 STATUS CHECKS

### Check containers:
```bash
docker ps
```

### Check với filter:
```bash
docker ps --filter "name=SITE_"
```

### Resource usage:
```bash
docker stats
```

### One-time stats:
```bash
docker stats --no-stream
```

### Logs:
```bash
# View logs
docker logs SITE_HANOI

# Follow logs
docker logs -f SITE_HANOI

# Last 50 lines
docker logs --tail 50 SITE_HANOI
```

---

## 💾 DATABASE QUERIES

### Template:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "<YOUR-QUERY-HERE>"
```

### 1. Check database exists:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT name FROM sys.databases"
```

### 2. Switch to database and query:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT * FROM NhanVien"
```

### 3. Count records:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT 
      (SELECT COUNT(*) FROM NhanVien) AS NhanVien,
      (SELECT COUNT(*) FROM ChiNhanh) AS ChiNhanh,
      (SELECT COUNT(*) FROM PhongBan) AS PhongBan"
```

### 4. List tables:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT TABLE_NAME FROM INFORMATION_SCHEMA.TABLES WHERE TABLE_TYPE='BASE TABLE'"
```

### 5. Show first 5 employees:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT TOP 5 ID_NhanVien, HoTen, Email FROM NhanVien"
```

### 6. Employee count by branch:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT cn.TenChiNhanh, COUNT(nv.ID_NhanVien) AS SoNhanVien FROM ChiNhanh cn LEFT JOIN NhanVien nv ON cn.ID_ChiNhanh = nv.ID_ChiNhanh GROUP BY cn.TenChiNhanh"
```

### 7. Top 5 highest salaries:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT TOP 5 nv.HoTen, cv.TenChucVu, l.TongLuong FROM NhanVien nv JOIN ChucVu cv ON nv.ID_ChucVu=cv.ID_ChucVu JOIN Luong l ON nv.ID_NhanVien=l.ID_NhanVien WHERE l.Thang=12 AND l.Nam=2024 ORDER BY l.TongLuong DESC"
```

---

## 🔍 VIEWS

### List all views:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT name FROM sys.views WHERE name LIKE 'View_%'"
```

### Query fragmentation view:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT * FROM View_NhanVien_CN01"
```

### Query reporting view:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT * FROM View_ThongKeNhanVienTheoPhongBan"
```

### Salary level view:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT TOP 5 * FROM View_NhanVien_MucLuongCao"
```

---

## ⚙️ STORED PROCEDURES

### List procedures:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT name FROM sys.procedures WHERE name LIKE 'sp_%'"
```

### Execute statistics procedure:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; EXEC sp_ThongKeNhanVien"
```

### Execute search:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; EXEC sp_TimKiemNhanVien @HoTen=N'Nguyễn'"
```

---

## 🔢 FUNCTIONS

### List functions:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT name FROM sys.objects WHERE type IN ('FN','IF','TF') AND name LIKE 'fn_%'"
```

### Calculate age:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT dbo.fn_TinhTuoi('1990-05-15') AS Tuoi"
```

### Calculate years of service:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT dbo.fn_TinhThamNien('2020-01-15') AS ThamNien"
```

### Use function in SELECT:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT TOP 5 HoTen, NgaySinh, dbo.fn_TinhTuoi(NgaySinh) AS Tuoi FROM NhanVien"
```

---

## 🔥 TRIGGERS

### List triggers:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT name, OBJECT_NAME(parent_id) AS TableName FROM sys.triggers WHERE name LIKE 'trg_%'"
```

### Check audit logs:
```bash
# Check delete log
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT * FROM AuditLog_XoaNhanVien"

# Check salary update log
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT * FROM AuditLog_Luong"
```

---

## 🌐 LINKED SERVERS

### List linked servers:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT name FROM sys.servers WHERE server_id > 0"
```

### Query remote site:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT * FROM SITE_DANANG.QuanLyNhanSu.dbo.ChiNhanh"
```

### Aggregate from all sites:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT 'HANOI' AS Site, COUNT(*) AS SoNhanVien FROM QuanLyNhanSu.dbo.NhanVien
      UNION ALL
      SELECT 'DANANG', COUNT(*) FROM SITE_DANANG.QuanLyNhanSu.dbo.NhanVien
      UNION ALL
      SELECT 'SAIGON', COUNT(*) FROM SITE_SAIGON.QuanLyNhanSu.dbo.NhanVien"
```

### Cross-site join:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT h.HoTen, d.TenChiNhanh FROM QuanLyNhanSu.dbo.NhanVien h 
      JOIN SITE_DANANG.QuanLyNhanSu.dbo.ChiNhanh d ON h.ID_ChiNhanh = d.ID_ChiNhanh
      WHERE d.ID_ChiNhanh = 'CN02'"
```

---

## 🔍 INDEXES

### List indexes:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT 
      OBJECT_NAME(object_id) AS TableName,
      name AS IndexName,
      type_desc AS IndexType
      FROM sys.indexes 
      WHERE name IS NOT NULL 
      ORDER BY TableName, IndexName"
```

### Check index usage:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT 
      OBJECT_NAME(s.object_id) AS TableName,
      i.name AS IndexName,
      s.user_seeks,
      s.user_scans,
      s.user_lookups
      FROM sys.dm_db_index_usage_stats s
      JOIN sys.indexes i ON s.object_id = i.object_id AND s.index_id = i.index_id
      WHERE database_id = DB_ID('QuanLyNhanSu')"
```

---

## 📈 MONITORING

### Active connections:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT COUNT(*) AS ActiveConnections FROM sys.dm_exec_connections"
```

### Current sessions:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT session_id, login_name, host_name, program_name, status FROM sys.dm_exec_sessions WHERE is_user_process = 1"
```

### Recent queries:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT TOP 10 
      s.text AS Query,
      p.last_execution_time,
      p.execution_count
      FROM sys.dm_exec_query_stats p
      CROSS APPLY sys.dm_exec_sql_text(p.sql_handle) s
      ORDER BY p.last_execution_time DESC"
```

### Database size:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; EXEC sp_spaceused"
```

---

## 💾 BACKUP & RESTORE

### Backup database:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "BACKUP DATABASE QuanLyNhanSu TO DISK = '/var/opt/mssql/backup/QuanLyNhanSu.bak'"
```

### Backup all sites:
```bash
./docker-backup.sh
```

### Restore database:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "RESTORE DATABASE QuanLyNhanSu FROM DISK = '/var/opt/mssql/backup/QuanLyNhanSu.bak' WITH REPLACE"
```

---

## 🧹 CLEANUP

### Remove stopped containers:
```bash
docker container prune
```

### Remove unused volumes:
```bash
docker volume prune
```

### Remove unused images:
```bash
docker image prune
```

### Remove everything (CAREFUL!):
```bash
docker system prune -a
```

### Complete cleanup script:
```bash
./docker-cleanup.sh
```

---

## 🔧 TROUBLESHOOTING COMMANDS

### Check container logs:
```bash
docker logs SITE_HANOI
```

### Enter container shell:
```bash
docker exec -it SITE_HANOI /bin/bash
```

### Check SQL Server error log:
```bash
docker exec SITE_HANOI cat /var/opt/mssql/log/errorlog
```

### Test connectivity:
```bash
# Ping from HANOI to DANANG
docker exec SITE_HANOI ping -c 3 172.20.0.12

# Test SQL connection
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S 172.20.0.12 -U sa -P 'Admin@123456' -C \
  -Q "SELECT @@SERVERNAME"
```

### Restart stuck container:
```bash
docker restart SITE_HANOI
```

### Rebuild container:
```bash
docker-compose down
docker-compose up -d --force-recreate SITE_HANOI
```

---

## 📱 DEMO COMMANDS (Copy & Paste Ready)

### Demo 1: Show containers
```bash
sudo docker ps
```

### Demo 2: Count employees
```bash
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT 'NhanVien' AS TableName, COUNT(*) AS Total FROM NhanVien UNION ALL SELECT 'ChiNhanh', COUNT(*) FROM ChiNhanh UNION ALL SELECT 'PhongBan', COUNT(*) FROM PhongBan"
```

### Demo 3: Linked Server query
```bash
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT 'HANOI' AS Site, COUNT(*) FROM QuanLyNhanSu.dbo.NhanVien UNION ALL SELECT 'DANANG', COUNT(*) FROM SITE_DANANG.QuanLyNhanSu.dbo.NhanVien UNION ALL SELECT 'SAIGON', COUNT(*) FROM SITE_SAIGON.QuanLyNhanSu.dbo.NhanVien"
```

### Demo 4: View fragmentation
```bash
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT * FROM View_NhanVien_CN01"
```

### Demo 5: Execute procedure
```bash
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; EXEC sp_ThongKeNhanVien"
```

### Demo 6: Test function
```bash
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT dbo.fn_TinhTuoi('1990-05-15') AS Tuoi"
```

### Demo 7: Monitoring
```bash
./docker-monitor.sh
```

---

## 📝 CREATE DEMO COMMANDS FILE

Tạo file `demo-commands.txt` để copy nhanh:

```bash
cat > demo-commands.txt << 'EOF'
# DEMO COMMANDS - Copy & Paste

# 1. Show containers
sudo docker ps

# 2. Database check
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'Admin@123456' -C -Q "USE QuanLyNhanSu; SELECT 'NhanVien' AS TableName, COUNT(*) AS Total FROM NhanVien UNION ALL SELECT 'ChiNhanh', COUNT(*) FROM ChiNhanh UNION ALL SELECT 'PhongBan', COUNT(*) FROM PhongBan"

# 3. Linked Server
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'Admin@123456' -C -Q "SELECT 'HANOI' AS Site, COUNT(*) FROM QuanLyNhanSu.dbo.NhanVien UNION ALL SELECT 'DANANG', COUNT(*) FROM SITE_DANANG.QuanLyNhanSu.dbo.NhanVien UNION ALL SELECT 'SAIGON', COUNT(*) FROM SITE_SAIGON.QuanLyNhanSu.dbo.NhanVien"

# 4. View
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'Admin@123456' -C -Q "USE QuanLyNhanSu; SELECT TOP 5 * FROM View_NhanVien_CN01"

# 5. Procedure
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'Admin@123456' -C -Q "USE QuanLyNhanSu; EXEC sp_ThongKeNhanVien"

# 6. Function
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'Admin@123456' -C -Q "USE QuanLyNhanSu; SELECT dbo.fn_TinhTuoi('1990-05-15') AS Tuoi"

# 7. Monitor
./docker-monitor.sh
EOF

echo "✓ Created demo-commands.txt"
```

---

## 📖 RELATED FILES

- `06-HUONG-DAN-CAI-DAT.md` - Setup instructions
- `07-KIEM-TRA-HE-THONG.md` - Testing
- `09-CHUAN-BI-BAO-VE.md` - Defense prep
- `10-KICH-BAN-DEMO.md` - Demo script

---

**Quick reference hoàn chỉnh! Sử dụng khi cần! 📚**
