# 🐳 DOCKER LÀ GÌ?
## Hiểu Docker cho người mới bắt đầu

---

## 🎯 TẦM QUAN TRỌNG

Docker là công nghệ **cực kỳ phổ biến** trong ngành IT.

**Tại sao học Docker:**
- ✅ 90% công ty công nghệ dùng Docker
- ✅ DevOps engineer phải biết
- ✅ Deploy nhanh, dễ dàng
- ✅ Portable across environments

---

## 📦 DOCKER LÀ GÌ?

### Định nghĩa đơn giản:
> **Docker** = Công nghệ chạy ứng dụng trong "hộp kín" (containers)

### Analogy:
**Shipping containers (container vận chuyển):**
- Đóng gói hàng hóa vào container
- Ship đến bất kỳ đâu (tàu, xe, cần cẩu)
- Không cần biết bên trong có gì
- Standardized

**Docker containers:**
- Đóng gói app + dependencies
- Chạy trên bất kỳ máy nào có Docker
- Không cần biết app viết bằng gì
- Standardized environment

---

## 🏗️ KIẾN TRÚC DOCKER

```
┌─────────────────────────────────────┐
│      Application (SQL Server)      │  ← Your app
├─────────────────────────────────────┤
│        Docker Container             │  ← Isolation
├─────────────────────────────────────┤
│        Docker Engine                │  ← Runtime
├─────────────────────────────────────┤
│        Host OS (Ubuntu)             │  ← Your machine
└─────────────────────────────────────┘
```

vs Virtual Machine:
```
┌─────────────────────────────────────┐
│      Application                    │
├─────────────────────────────────────┤
│      Guest OS (Windows)             │  ← Nặng!
├─────────────────────────────────────┤
│      Hypervisor (VirtualBox)        │
├─────────────────────────────────────┤
│      Host OS                        │
└─────────────────────────────────────┘
```

**Docker nhẹ hơn vì:**
- Không cần Guest OS
- Share kernel với host
- Chỉ package app + libraries

---

## 🔑 CÁC KHÁI NIỆM QUAN TRỌNG

### 1. **Docker Image**
**Là gì:** Template, blueprint để tạo container

**Analogy:** Class trong OOP

**Ví dụ:**
```bash
# Pull image từ Docker Hub
docker pull mcr.microsoft.com/mssql/server:2019-latest

# List images
docker images
```

**Image layers:**
```
mcr.microsoft.com/mssql/server:2019
├─ Ubuntu base layer
├─ SQL Server binaries
├─ Configuration files
└─ Default settings
```

---

### 2. **Docker Container**
**Là gì:** Running instance của image

**Analogy:** Object/instance trong OOP

**Ví dụ:**
```bash
# Tạo container từ image
docker run --name SITE_HANOI \
  -e SA_PASSWORD='Admin@123456' \
  -p 1433:1433 \
  -d mcr.microsoft.com/mssql/server:2019-latest

# List containers
docker ps
```

**1 image → Nhiều containers:**
```
SQL Server Image
├─ Container 1: SITE_HANOI
├─ Container 2: SITE_DANANG
└─ Container 3: SITE_SAIGON
```

---

### 3. **Docker Volume**
**Là gì:** Persistent storage cho containers

**Vấn đề:** Container bị xóa → Data mất

**Solution:** Mount volume

**Ví dụ:**
```bash
docker run -v sqlserver_hanoi:/var/opt/mssql ...
```

**Visualize:**
```
Host Machine
├─ /var/lib/docker/volumes/
    └─ sqlserver_hanoi/        ← Persistent data
        └─ QuanLyNhanSu.mdf    ← Database files

Container
└─ /var/opt/mssql/             ← Mount point
    └─ [Data from volume]
```

---

### 4. **Docker Network**
**Là gì:** Virtual network để containers giao tiếp

**Ví dụ project:**
```yaml
networks:
  distributed_db_network:
    subnet: 172.20.0.0/24

Containers:
├─ SITE_HANOI:  172.20.0.11
├─ SITE_DANANG: 172.20.0.12
└─ SITE_SAIGON: 172.20.0.13
```

**Communication:**
```bash
# Từ HANOI ping DANANG
docker exec SITE_HANOI ping 172.20.0.12
```

---

### 5. **Docker Compose**
**Là gì:** Tool quản lý multi-container apps

**File:** `docker-compose.yml`

**Ví dụ:**
```yaml
services:
  site-hanoi:
    image: mssql/server:2019
    environment:
      - SA_PASSWORD=Admin@123456
    ports:
      - "1433:1433"
    networks:
      distributed_db_network:
        ipv4_address: 172.20.0.11
  
  site-danang:
    image: mssql/server:2019
    ports:
      - "1434:1433"
    # ...
  
  site-saigon:
    # ...
```

**Commands:**
```bash
docker-compose up -d    # Start all
docker-compose down     # Stop all
docker-compose ps       # Status
docker-compose logs     # View logs
```

---

## 🤔 TẠI SAO CHỌN DOCKER?

### So sánh với alternatives:

| Aspect | Docker | VirtualBox | Bare Metal |
|--------|--------|------------|------------|
| **Setup time** | 30 phút | 10+ giờ | 5+ giờ |
| **RAM needed** | 8GB | 16GB+ | 4GB |
| **Disk space** | 10GB | 50GB+ | 20GB |
| **Portability** | ⭐⭐⭐⭐⭐ | ⭐⭐ | ⭐ |
| **Isolation** | ⭐⭐⭐⭐ | ⭐⭐⭐⭐⭐ | ⭐ |
| **Performance** | ⭐⭐⭐⭐⭐ | ⭐⭐⭐ | ⭐⭐⭐⭐⭐ |

### Lý do em chọn Docker:

**✅ Pros:**
1. **Fast:** 30 phút setup vs 10 giờ VirtualBox
2. **Lightweight:** 8GB RAM đủ cho 3 sites
3. **Reproducible:** 1 script chạy mọi nơi
4. **Modern:** Industry standard
5. **Learning:** Skill quan trọng
6. **Demo friendly:** Dễ show

**❌ Cons:**
1. **No full Replication:** SQL Server Linux limitation
2. **Less isolation:** Shared kernel
3. **Learning curve:** Cần học Docker

### Decision:
> **Demo/Academic: Docker**  
> **Production: VMs hoặc Cloud**

---

## 📊 DOCKER TRONG PROJECT

### Architecture:
```
Ubuntu 22.04 Host
├─ Docker Engine
│   ├─ distributed_db_network (172.20.0.0/24)
│   │   ├─ SITE_HANOI (172.20.0.11:1433)
│   │   ├─ SITE_DANANG (172.20.0.12:1434)
│   │   └─ SITE_SAIGON (172.20.0.13:1435)
│   │
│   └─ Volumes
│       ├─ sqlserver_hanoi
│       ├─ sqlserver_danang
│       └─ sqlserver_saigon
```

### Workflow:
```bash
# 1. Install Docker
./install-docker.sh

# 2. Start containers
docker-compose up -d

# 3. Setup databases
./docker-complete-setup.sh

# 4. Monitor
./docker-monitor.sh

# 5. Backup
./docker-backup.sh
```

---

## 🎓 DOCKER COMMANDS CẦN BIẾT

### Container management:
```bash
# List running containers
docker ps

# List all containers (including stopped)
docker ps -a

# Start container
docker start SITE_HANOI

# Stop container
docker stop SITE_HANOI

# Restart container
docker restart SITE_HANOI

# Remove container
docker rm SITE_HANOI

# View logs
docker logs SITE_HANOI

# Follow logs real-time
docker logs -f SITE_HANOI

# Execute command in container
docker exec SITE_HANOI <command>
```

### Image management:
```bash
# List images
docker images

# Pull image
docker pull mssql/server:2019-latest

# Remove image
docker rmi <image-id>

# Build custom image
docker build -t myapp:1.0 .
```

### Volume management:
```bash
# List volumes
docker volume ls

# Inspect volume
docker volume inspect sqlserver_hanoi

# Remove volume
docker volume rm sqlserver_hanoi

# Remove unused volumes
docker volume prune
```

### Network management:
```bash
# List networks
docker network ls

# Inspect network
docker network inspect distributed_db_network

# Create network
docker network create mynetwork
```

### System:
```bash
# Show resource usage
docker stats

# Remove everything (CAREFUL!)
docker system prune -a

# Disk usage
docker system df
```

---

## 🔧 DOCKER COMPOSE COMMANDS

```bash
# Start services
docker-compose up -d

# Stop services
docker-compose down

# View status
docker-compose ps

# View logs
docker-compose logs

# Follow logs
docker-compose logs -f

# Restart services
docker-compose restart

# Build and start
docker-compose up --build
```

---

## 💡 BEST PRACTICES

### 1. **Always use specific tags:**
```yaml
# ✅ Good
image: mssql/server:2019-latest

# ❌ Bad
image: mssql/server
```

### 2. **Name your containers:**
```bash
# ✅ Good
docker run --name SITE_HANOI ...

# ❌ Bad
docker run ...  # Random name
```

### 3. **Use volumes for data:**
```yaml
# ✅ Good
volumes:
  - sqlserver_hanoi:/var/opt/mssql

# ❌ Bad
# No volume = data loss on delete
```

### 4. **Environment variables for secrets:**
```yaml
# ✅ Good (for demo)
environment:
  - SA_PASSWORD=${SA_PASSWORD}

# 🔒 Best (production)
secrets:
  - db_password
```

### 5. **Health checks:**
```yaml
healthcheck:
  test: ["CMD", "/opt/mssql-tools/bin/sqlcmd", "-Q", "SELECT 1"]
  interval: 30s
  timeout: 10s
  retries: 3
```

---

## 🚨 COMMON ISSUES & FIXES

### Issue 1: Cannot connect to Docker daemon
```bash
# Fix: Start Docker
sudo systemctl start docker
```

### Issue 2: Port already in use
```bash
# Find process using port
sudo lsof -i :1433

# Kill process
sudo kill <PID>
```

### Issue 3: Container keeps restarting
```bash
# Check logs
docker logs SITE_HANOI

# Common cause: Wrong SA_PASSWORD
```

### Issue 4: Out of disk space
```bash
# Clean up
docker system prune -a
docker volume prune
```

---

## 📚 HỌC THÊM

### Resources:
- **Official docs:** https://docs.docker.com
- **Docker Hub:** https://hub.docker.com
- **Tutorials:** Docker Getting Started
- **Practice:** Play with Docker (online sandbox)

### Next steps:
1. Kubernetes (container orchestration)
2. Docker Swarm (clustering)
3. CI/CD pipelines
4. Microservices architecture

---

## 📖 FILES LIÊN QUAN

- `06-HUONG-DAN-CAI-DAT.md` - Setup Docker
- `docker-compose.yml` - Config file
- `docker-complete-setup.sh` - Automation script

---

**Đã hiểu Docker cơ bản! Sang phần cài đặt! 🚀**
