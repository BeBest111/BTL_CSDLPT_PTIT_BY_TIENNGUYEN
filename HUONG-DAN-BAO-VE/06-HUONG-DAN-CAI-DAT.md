# 🛠️ HƯỚNG DẪN CÀI ĐẶT
## Setup từ đầu đến chạy thành công

---

## 🎯 MỤC TIÊU

Sau khi làm theo file này, bạn sẽ có:
- ✅ Docker đã cài
- ✅ 3 SQL Server containers chạy
- ✅ Database QuanLyNhanSu có data
- ✅ Linked Servers configured
- ✅ Sẵn sàng demo!

**Thời gian:** ~30 phút

---

## 📋 YÊU CẦU HỆ THỐNG

### Minimum:
- **OS:** Ubuntu 20.04+ (hoặc bất kỳ Linux distro)
- **CPU:** 2 cores
- **RAM:** 8GB
- **Disk:** 20GB free
- **Network:** Internet connection

### Recommended:
- **OS:** Ubuntu 22.04 LTS
- **CPU:** 4 cores
- **RAM:** 16GB
- **Disk:** 50GB free SSD

### Kiểm tra hệ thống:
```bash
# Check OS
lsb_release -a

# Check CPU
nproc

# Check RAM
free -h

# Check disk
df -h

# Check internet
ping -c 3 google.com
```

---

## 🚀 OPTION 1: ONE-CLICK SETUP (KHUYÊN DÙNG)

### Bước 1: Download project
```bash
cd ~
git clone <your-repo-url>
cd BTL-CSDLPT-PTIT
```

### Bước 2: Cài Docker (nếu chưa có)
```bash
./install-docker.sh
```

**Output expected:**
```
✓ Updating package list...
✓ Installing prerequisites...
✓ Adding Docker GPG key...
✓ Installing Docker...
✓ Starting Docker...
✓ Adding user to docker group...
✓ Docker installed successfully!
```

**Logout và login lại:**
```bash
# Logout để group change có hiệu lực
exit
# Login lại
```

### Bước 3: Verify Docker
```bash
docker --version
docker-compose --version
docker ps
```

**Output expected:**
```
Docker version 28.5.1
Docker Compose version v2.40.3
CONTAINER ID   IMAGE   ... (empty is OK)
```

### Bước 4: Setup hệ thống hoàn chỉnh
```bash
./docker-complete-setup.sh
```

**Output expected:**
```
=== STEP 1: Starting containers ===
✓ SITE_HANOI started
✓ SITE_DANANG started
✓ SITE_SAIGON started

=== STEP 2: Waiting for SQL Server (60s) ===
..........................................Done!

=== STEP 3: Creating databases ===
✓ SITE_HANOI database created
✓ SITE_DANANG database created
✓ SITE_SAIGON database created

=== STEP 4: Inserting sample data ===
✓ 131 records inserted

=== STEP 5: Creating views, procedures, functions, triggers ===
✓ 14 views created
✓ 6 procedures created
✓ 6 functions created
✓ 4 triggers created

=== STEP 6: Configuring Linked Servers ===
✓ SITE_DANANG linked
✓ SITE_SAIGON linked

=== STEP 7: Running tests ===
✓ 38/40 tests passed

=== SUCCESS! System ready for demo ===
```

### Bước 5: Verify setup
```bash
# Check containers
docker ps

# Check database
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT COUNT(*) FROM QuanLyNhanSu.dbo.NhanVien"
```

**Output expected:**
```
CONTAINER ID   NAMES         STATUS    PORTS
...            SITE_HANOI    Up        0.0.0.0:1433->1433/tcp
...            SITE_DANANG   Up        0.0.0.0:1434->1433/tcp
...            SITE_SAIGON   Up        0.0.0.0:1435->1433/tcp

(1 rows affected)
40
```

**🎉 DONE! Chuyển sang phần 07 để test!**

---

## 🔧 OPTION 2: MANUAL SETUP (Step-by-step)

Nếu muốn hiểu rõ từng bước:

### Step 1: Install Docker

#### Ubuntu/Debian:
```bash
# Update package list
sudo apt-get update

# Install prerequisites
sudo apt-get install -y \
    apt-transport-https \
    ca-certificates \
    curl \
    gnupg \
    lsb-release

# Add Docker GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | \
  sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Add Docker repository
echo \
  "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu \
  $(lsb_release -cs) stable" | \
  sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Update again
sudo apt-get update

# Install Docker
sudo apt-get install -y docker-ce docker-ce-cli containerd.io docker-compose-plugin

# Start Docker
sudo systemctl start docker
sudo systemctl enable docker

# Add user to docker group
sudo usermod -aG docker $USER

# Logout and login
```

#### CentOS/RHEL:
```bash
sudo yum install -y yum-utils
sudo yum-config-manager --add-repo \
  https://download.docker.com/linux/centos/docker-ce.repo
sudo yum install -y docker-ce docker-ce-cli containerd.io
sudo systemctl start docker
sudo systemctl enable docker
sudo usermod -aG docker $USER
```

---

### Step 2: Create docker-compose.yml

```yaml
version: '3.8'

services:
  site-hanoi:
    image: mcr.microsoft.com/mssql/server:2019-latest
    container_name: SITE_HANOI
    environment:
      - ACCEPT_EULA=Y
      - SA_PASSWORD=Admin@123456
      - MSSQL_PID=Developer
    ports:
      - "1433:1433"
    volumes:
      - sqlserver_hanoi:/var/opt/mssql
    networks:
      distributed_db_network:
        ipv4_address: 172.20.0.11

  site-danang:
    image: mcr.microsoft.com/mssql/server:2019-latest
    container_name: SITE_DANANG
    environment:
      - ACCEPT_EULA=Y
      - SA_PASSWORD=Admin@123456
      - MSSQL_PID=Developer
    ports:
      - "1434:1433"
    volumes:
      - sqlserver_danang:/var/opt/mssql
    networks:
      distributed_db_network:
        ipv4_address: 172.20.0.12

  site-saigon:
    image: mcr.microsoft.com/mssql/server:2019-latest
    container_name: SITE_SAIGON
    environment:
      - ACCEPT_EULA=Y
      - SA_PASSWORD=Admin@123456
      - MSSQL_PID=Developer
    ports:
      - "1435:1433"
    volumes:
      - sqlserver_saigon:/var/opt/mssql
    networks:
      distributed_db_network:
        ipv4_address: 172.20.0.13

volumes:
  sqlserver_hanoi:
  sqlserver_danang:
  sqlserver_saigon:

networks:
  distributed_db_network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/24
```

---

### Step 3: Start containers
```bash
docker-compose up -d
```

**Wait 60 seconds** for SQL Server to initialize:
```bash
sleep 60
```

---

### Step 4: Create databases
```bash
# HANOI
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "CREATE DATABASE QuanLyNhanSu"

# DANANG
docker exec SITE_DANANG /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "CREATE DATABASE QuanLyNhanSu"

# SAIGON
docker exec SITE_SAIGON /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "CREATE DATABASE QuanLyNhanSu"
```

---

### Step 5: Run SQL scripts
```bash
# Copy scripts vào containers
docker cp HR.sql SITE_HANOI:/tmp/
docker cp HR-Data.sql SITE_HANOI:/tmp/
docker cp Physical-Implementation.sql SITE_HANOI:/tmp/

# Run scripts
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -i /tmp/HR.sql

docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -i /tmp/HR-Data.sql

docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -i /tmp/Physical-Implementation.sql

# Repeat for DANANG and SAIGON
```

---

### Step 6: Configure Linked Servers
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "EXEC sp_addlinkedserver @server='SITE_DANANG', @srvproduct='', @provider='SQLNCLI', @datasrc='172.20.0.12,1433'"

docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "EXEC sp_addlinkedserver @server='SITE_SAIGON', @srvproduct='', @provider='SQLNCLI', @datasrc='172.20.0.13,1433'"

# Configure login
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "EXEC sp_addlinkedsrvlogin @rmtsrvname='SITE_DANANG', @useself='false', @locallogin=NULL, @rmtuser='sa', @rmtpassword='Admin@123456'"

docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "EXEC sp_addlinkedsrvlogin @rmtsrvname='SITE_SAIGON', @useself='false', @locallogin=NULL, @rmtuser='sa', @rmtpassword='Admin@123456'"
```

---

## ✅ VERIFICATION

### 1. Containers running:
```bash
docker ps
```
→ Should see 3 containers UP

### 2. Database exists:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT name FROM sys.databases WHERE name='QuanLyNhanSu'"
```
→ Should return "QuanLyNhanSu"

### 3. Has data:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT COUNT(*) FROM NhanVien"
```
→ Should return 40

### 4. Linked Servers work:
```bash
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT COUNT(*) FROM SITE_DANANG.QuanLyNhanSu.dbo.ChiNhanh"
```
→ Should return 10

---

## 🚨 TROUBLESHOOTING

### Issue 1: Docker not installed
```
bash: docker: command not found
```
**Fix:** Run `install-docker.sh` again

---

### Issue 2: Permission denied
```
docker: Got permission denied while trying to connect...
```
**Fix:**
```bash
sudo usermod -aG docker $USER
# Logout and login
```

---

### Issue 3: Port already in use
```
Error starting userland proxy: listen tcp 0.0.0.0:1433: bind: address already in use
```
**Fix:**
```bash
# Find process
sudo lsof -i :1433

# Kill it
sudo kill <PID>

# Or change port in docker-compose.yml
```

---

### Issue 4: Container keeps restarting
**Check logs:**
```bash
docker logs SITE_HANOI
```

**Common causes:**
- Wrong SA_PASSWORD (must be strong)
- Not enough memory
- Port conflict

---

### Issue 5: SQL Server not ready
```
Sqlcmd: Error: Microsoft ODBC Driver 18 for SQL Server : Login timeout expired.
```
**Fix:** Wait longer (60-120 seconds)
```bash
sleep 120
# Try again
```

---

## 📚 NEXT STEPS

Sau khi cài đặt thành công:

1. **Đọc file 07:** Kiểm tra hệ thống
2. **Đọc file 08:** Các lệnh thường dùng
3. **Đọc file 09:** Chuẩn bị bảo vệ
4. **Practice:** Chạy demo nhiều lần

---

## 🎯 QUICK COMMANDS REFERENCE

```bash
# Start system
docker-compose up -d

# Stop system
docker-compose down

# Restart container
docker restart SITE_HANOI

# View logs
docker logs -f SITE_HANOI

# Execute SQL
docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "<your-query>"

# Backup
./docker-backup.sh

# Monitor
./docker-monitor.sh

# Cleanup (CAREFUL!)
docker-compose down -v
docker system prune -a
```

---

**Cài đặt xong! Chuyển sang file 07 để kiểm tra! ✅**
