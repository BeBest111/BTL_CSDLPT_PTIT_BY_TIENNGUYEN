# ❓ CÂU HỎI THƯỜNG GẶP KHI BẢO VỆ
## 50+ câu hỏi và trả lời mẫu

---

## 🎯 CÁC NHÓM CÂU HỎI

1. **Cơ bản về Database** (10 câu)
2. **Database Phân tán** (10 câu)
3. **Docker & Container** (8 câu)
4. **SQL Server** (10 câu)
5. **Design & Implementation** (10 câu)
6. **Performance & Security** (8 câu)

---

## 📚 NHÓM 1: CƠ BẢN VỀ DATABASE

### Q1: Database là gì?
**Trả lời:**
> "Database là hệ thống lưu trữ dữ liệu có tổ chức.
> 
> Giống như tủ hồ sơ, nhưng điện tử:
> - Lưu trữ thông tin
> - Tìm kiếm nhanh
> - Quản lý dễ dàng
> - Đảm bảo an toàn
> 
> Ví dụ: Database QuanLyNhanSu lưu thông tin nhân viên,
> lương, phòng ban..."

---

### Q2: DBMS là gì?
**Trả lời:**
> "DBMS = Database Management System
> 
> Là phần mềm quản lý database.
> 
> Ví dụ:
> - SQL Server (em dùng)
> - MySQL
> - PostgreSQL
> - Oracle
> 
> DBMS giúp:
> - Tạo database
> - Query dữ liệu
> - Backup/restore
> - Security
> - Transactions"

---

### Q3: SQL là gì?
**Trả lời:**
> "SQL = Structured Query Language
> 
> Ngôn ngữ để tương tác với database.
> 
> 4 nhóm lệnh chính:
> - **DDL:** CREATE, ALTER, DROP (tạo cấu trúc)
> - **DML:** SELECT, INSERT, UPDATE, DELETE (thao tác dữ liệu)
> - **DCL:** GRANT, REVOKE (phân quyền)
> - **TCL:** COMMIT, ROLLBACK (transactions)
> 
> Ví dụ:
> SELECT * FROM NhanVien WHERE ChucVu = 'Giam doc'"

---

### Q4: Primary Key là gì?
**Trả lời:**
> "Primary Key là cột xác định duy nhất mỗi row.
> 
> Đặc điểm:
> - Unique (không trùng)
> - Not NULL
> - Chỉ có 1 PK mỗi table
> 
> Ví dụ table NhanVien:
> - ID_NhanVien là Primary Key
> - NV001, NV002... đều khác nhau
> 
> Giống như CMND/CCCD của người."

---

### Q5: Foreign Key là gì?
**Trả lời:**
> "Foreign Key liên kết giữa 2 tables.
> 
> Ví dụ:
> - Table NhanVien có cột ID_PhongBan
> - ID_PhongBan là FK → PhongBan.ID_PhongBan
> 
> Lợi ích:
> - Đảm bảo tính toàn vẹn
> - Không thể thêm nhân viên vào phòng ban không tồn tại
> - Cascade delete/update
> 
> Giống như địa chỉ nhà phải tồn tại trước khi ghi vào hồ sơ."

---

### Q6: Index là gì?
**Trả lời:**
> "Index giúp tăng tốc độ query.
> 
> Giống mục lục sách:
> - Tìm nhanh hơn
> - Không cần đọc hết sách
> 
> 2 loại chính:
> - **Clustered:** Sắp xếp dữ liệu (mỗi table 1 cái)
> - **Non-clustered:** Pointer đến dữ liệu (nhiều cái)
> 
> Em có 12+ indexes:
> - Primary Keys (clustered)
> - Foreign Keys (non-clustered)
> - Covering indexes
> 
> Trade-off: Tăng tốc SELECT, chậm INSERT/UPDATE."

---

### Q7: View là gì?
**Trả lời:**
> "View là virtual table, query được lưu.
> 
> Không lưu dữ liệu, chỉ lưu query.
> 
> Lợi ích:
> - Đơn giản hóa queries phức tạp
> - Security: Ẩn columns nhạy cảm
> - Phân mảnh dữ liệu
> 
> Em có 14 views:
> - 8 views phân mảnh (View_NhanVien_CN01...)
> - 6 views báo cáo (View_ThongKeNhanVien...)
> 
> Ví dụ:
> ```sql
> CREATE VIEW View_NhanVien_CN01 AS
> SELECT * FROM NhanVien WHERE ID_ChiNhanh='CN01'
> ```"

---

### Q8: Stored Procedure vs Function?
**Trả lời:**
> "**Stored Procedure:**
> - Thực thi business logic
> - Có thể INSERT/UPDATE/DELETE
> - Return multiple values hoặc result sets
> - Gọi: EXEC sp_ThemNhanVien
> 
> **Function:**
> - Tính toán, return giá trị
> - Chỉ SELECT, không modify data
> - Return 1 giá trị hoặc table
> - Gọi: SELECT dbo.fn_TinhTuoi(...)
> 
> Em dùng:
> - Procedure cho CRUD operations
> - Function cho calculations/validation
> 
> Analogy:
> - Procedure = Động từ (làm việc gì)
> - Function = Tính toán (trả về kết quả)"

---

### Q9: Trigger là gì?
**Trả lời:**
> "Trigger tự động chạy khi có event.
> 
> 3 loại timing:
> - AFTER: Sau khi INSERT/UPDATE/DELETE
> - INSTEAD OF: Thay thế operation
> - BEFORE: (MySQL, không có trong SQL Server)
> 
> Em có 4 triggers:
> 
> 1. **trg_KiemTraTuoiNhanVien (INSTEAD OF INSERT)**
>    - Chặn nếu tuổi < 18
> 
> 2. **trg_LogXoaNhanVien (AFTER DELETE)**
>    - Lưu log khi xóa nhân viên
> 
> 3. **trg_KiemTraMucLuong (INSTEAD OF INSERT)**
>    - Chặn nếu lương <= 0
> 
> 4. **trg_LogCapNhatLuong (AFTER UPDATE)**
>    - Audit trail khi update lương
> 
> Use case: Validation, logging, audit"

---

### Q10: Transaction là gì?
**Trả lời:**
> "Transaction là nhóm operations thực thi như 1 đơn vị.
> 
> **ACID Properties:**
> - **A**tomicity: Tất cả hoặc không
> - **C**onsistency: Đảm bảo constraints
> - **I**solation: Không ảnh hưởng lẫn nhau
> - **D**urability: Committed thì vĩnh viễn
> 
> Ví dụ chuyển tiền:
> ```sql
> BEGIN TRANSACTION;
>   UPDATE Account SET Balance -= 100 WHERE ID = 1;
>   UPDATE Account SET Balance += 100 WHERE ID = 2;
> COMMIT;
> ```
> 
> Nếu bất kỳ lệnh nào lỗi → ROLLBACK tất cả.
> 
> Đảm bảo data integrity."

---

## 🌐 NHÓM 2: DATABASE PHÂN TÁN

### Q11: Database phân tán là gì?
**Trả lời:**
> "Database phân tán chia dữ liệu ra nhiều sites vật lý.
> 
> **Đặc điểm:**
> - Dữ liệu ở nhiều nơi
> - Kết nối qua network
> - Hoạt động như 1 database logic
> 
> **Lợi ích:**
> - Availability: 1 site down, các site khác vẫn hoạt động
> - Performance: User truy cập site gần nhất
> - Scalability: Thêm sites dễ dàng
> - Locality: Data gần user
> 
> Em triển khai 3 sites:
> - Hà Nội, Đà Nẵng, Sài Gòn
> 
> vs Database tập trung:
> - 1 server duy nhất
> - Single point of failure
> - Network bottleneck"

---

### Q12: Phân mảnh (Fragmentation) là gì?
**Trả lời:**
> "Phân mảnh là chia table lớn thành các mảnh nhỏ.
> 
> **3 loại:**
> 
> 1. **Phân mảnh ngang (Horizontal):**
>    - Chia theo HÀNG
>    - Ví dụ: View_NhanVien_CN01 (chỉ chi nhánh 01)
> 
> 2. **Phân mảnh dọc (Vertical):**
>    - Chia theo CỘT
>    - Ví dụ: View_NhanVienInfo (chỉ thông tin cá nhân)
> 
> 3. **Phân mảnh hỗn hợp:**
>    - Kết hợp cả 2
> 
> **Em implement 8 views phân mảnh:**
> - 5 views theo chi nhánh (CN01-05)
> - 3 views theo mức lương
> 
> **Lợi ích:**
> - Query nhanh hơn (ít dữ liệu)
> - Bảo mật tốt hơn
> - Distributed processing"

---

### Q13: Replication là gì?
**Trả lời:**
> "Replication đồng bộ dữ liệu giữa các databases.
> 
> **3 loại:**
> 
> 1. **Snapshot Replication:**
>    - Copy toàn bộ data theo lịch
>    - Phù hợp dữ liệu ít thay đổi
> 
> 2. **Transactional Replication:**
>    - Đồng bộ real-time
>    - Gần như instant
> 
> 3. **Merge Replication:**
>    - Cho phép update ở nhiều sites
>    - Conflict resolution
> 
> **Hạn chế của em:**
> Docker SQL Server Linux không support full Replication.
> 
> **Workaround:**
> - Chạy cùng scripts trên các sites
> - Linked Server queries
> - Manual sync
> 
> Nếu dùng Windows → Có full Replication."

---

### Q14: Linked Server là gì?
**Trả lời:**
> "Linked Server cho phép query database ở server khác.
> 
> **Setup:**
> ```sql
> EXEC sp_addlinkedserver 
>   @server='SITE_DANANG',
>   @srvproduct='',
>   @provider='SQLNCLI',
>   @datasrc='172.20.0.12,1433'
> ```
> 
> **Query syntax:**
> ```sql
> SELECT * FROM SITE_DANANG.QuanLyNhanSu.dbo.ChiNhanh
> ```
> 
> Format: [Server].[Database].[Schema].[Table]
> 
> **Em đã config:**
> - HANOI → DANANG
> - HANOI → SAIGON
> 
> **Use cases:**
> - Distributed queries
> - Data aggregation
> - Cross-site reporting
> 
> **Performance note:**
> Network latency có thể chậm hơn local query."

---

### Q15: Tại sao cần database phân tán?
**Trả lời:**
> "**Bài toán thực tế:**
> Công ty có chi nhánh Hà Nội, Đà Nẵng, Sài Gòn.
> 
> **Nếu dùng 1 database tập trung ở Hà Nội:**
> - User ở Sài Gòn phải query qua internet
> - Latency cao (100-200ms)
> - Network bottleneck
> - Single point of failure
> 
> **Dùng database phân tán:**
> - Mỗi chi nhánh có DB riêng
> - User query local DB (latency thấp)
> - 1 site down, các site khác vẫn hoạt động
> - Scale dễ dàng
> 
> **Trade-offs:**
> - Phức tạp hơn
> - Consistency challenges
> - Network overhead cho distributed queries
> 
> Nhưng lợi ích > chi phí với công ty đa chi nhánh."

---

### Q16: CAP Theorem là gì?
**Trả lời:**
> "CAP Theorem: Chỉ đạt được 2 trong 3.
> 
> - **C**onsistency: Dữ liệu nhất quán
> - **A**vailability: Luôn phản hồi request
> - **P**artition tolerance: Hoạt động khi network bị chia cắt
> 
> **SQL Server chọn CP:**
> - Consistency + Partition tolerance
> - Hy sinh Availability
> 
> Ví dụ:
> - Network giữa Hà Nội và Sài Gòn bị đứt
> - SQL Server dừng write để đảm bảo consistency
> - Đợi network phục hồi
> 
> vs NoSQL (AP):
> - Availability + Partition tolerance
> - Eventual consistency
> 
> Tùy business requirements chọn."

---

### Q17: 2PC (Two-Phase Commit) là gì?
**Trả lời:**
> "2PC đảm bảo transaction phân tán atomic.
> 
> **2 Phases:**
> 
> **Phase 1: Prepare**
> - Coordinator hỏi tất cả participants: 'Ready to commit?'
> - Mỗi participant vote YES hoặc NO
> 
> **Phase 2: Commit**
> - Nếu tất cả YES → COMMIT
> - Nếu có 1 NO → ROLLBACK
> 
> **Ví dụ:**
> Chuyển nhân viên từ Hà Nội sang Sài Gòn:
> 1. Prepare: Cả 2 sites sẵn sàng?
> 2. Commit: Cả 2 thực thi hoặc cả 2 rollback
> 
> **Vấn đề:**
> - Blocking: Chờ tất cả participants
> - Coordinator failure
> 
> SQL Server dùng MS-DTC (Distributed Transaction Coordinator)."

---

### Q18: Làm sao đồng bộ dữ liệu?
**Trả lời:**
> "**Cách lý tưởng (Production):**
> SQL Server Replication:
> - Transactional Replication (real-time)
> - Auto sync khi có thay đổi
> - Publisher → Subscriber model
> 
> **Cách em implement (Docker):**
> Do Docker Linux không có Replication:
> 
> 1. **Initial sync:**
>    - Chạy cùng scripts trên 3 sites
>    - docker-complete-setup.sh
> 
> 2. **Distributed queries:**
>    - Dùng Linked Server
>    - Query real-time từ site khác
> 
> 3. **Manual sync (nếu cần):**
>    - Export từ site nguồn
>    - Import vào sites khác
>    - Hoặc script INSERT từ linked server
> 
> **Production approach:**
> - Dùng Windows Server
> - Setup Publisher/Subscriber
> - Auto sync"

---

### Q19: Conflict resolution trong database phân tán?
**Trả lời:**
> "Conflict xảy ra khi 2 sites update cùng row.
> 
> **Ví dụ conflict:**
> - Site Hà Nội update lương NV001 = 20M
> - Cùng lúc Site Sài Gòn update lương NV001 = 25M
> - Giá trị nào đúng?
> 
> **Strategies:**
> 
> 1. **Last Write Wins:**
>    - Timestamp mới nhất thắng
>    - Đơn giản nhưng mất dữ liệu
> 
> 2. **Priority-based:**
>    - Site chính (master) thắng
>    - Slave chỉ đọc
> 
> 3. **Manual resolution:**
>    - Notify admin
>    - Quyết định thủ công
> 
> 4. **Application logic:**
>    - Merge giá trị (avg, sum...)
>    - Business rules
> 
> **Em implement:**
> Tránh conflict bằng master-slave:
> - Hà Nội là master (write)
> - Đà Nẵng, Sài Gòn là replicas (read)
> 
> Hoặc partition: Mỗi site quản lý data riêng."

---

### Q20: Ưu nhược điểm database phân tán?
**Trả lời:**
> "**Ưu điểm:**
> ✅ High availability
> ✅ Better performance (locality)
> ✅ Scalability
> ✅ Fault tolerance
> ✅ Data locality
> 
> **Nhược điểm:**
> ❌ Complexity cao
> ❌ Network latency
> ❌ Consistency challenges
> ❌ Chi phí cao hơn
> ❌ Khó debug/troubleshoot
> 
> **Khi nào dùng:**
> - Công ty đa chi nhánh
> - User phân tán địa lý
> - Cần high availability
> - Big data
> 
> **Khi nào KHÔNG dùng:**
> - Startup nhỏ, 1 văn phòng
> - Dữ liệu ít
> - Budget hạn chế
> - Team chưa có experience
> 
> → Database tập trung đơn giản hơn."

---

## 🐳 NHÓM 3: DOCKER & CONTAINER

### Q21: Docker là gì?
**Trả lời:**
> "Docker là platform chạy ứng dụng trong containers.
> 
> **Container:**
> - Môi trường isolated
> - Đóng gói app + dependencies
> - Lightweight hơn VM
> - Portable
> 
> **Ví dụ:**
> Em package SQL Server + database vào container.
> Chạy trên bất kỳ máy nào có Docker.
> 
> **Lợi ích:**
> - Setup nhanh (30 phút vs 10 giờ với VM)
> - Nhẹ (8GB RAM vs 16GB)
> - Reproducible
> - Dễ scale
> 
> **Architecture:**
> ```
> Host OS (Ubuntu)
>   ├── Docker Engine
>       ├── SITE_HANOI (container)
>       ├── SITE_DANANG (container)
>       └── SITE_SAIGON (container)
> ```"

---

### Q22: Container vs Virtual Machine?
**Trả lời:**
> "**Virtual Machine:**
> - Có OS riêng (Windows/Linux)
> - Hypervisor (VirtualBox, VMware)
> - Nặng (GB RAM, GB disk mỗi VM)
> - Boot lâu (phút)
> - Isolation hoàn toàn
> 
> **Container:**
> - Share host OS kernel
> - Docker Engine
> - Nhẹ (MB RAM, MB disk)
> - Start nhanh (giây)
> - Isolation process-level
> 
> **So sánh:**
> ```
> VM:        [App] [OS] [Hypervisor] [Host OS]
> Container: [App] [Docker Engine] [Host OS]
> ```
> 
> **Em chọn Docker vì:**
> - Development/demo purposes
> - Nhẹ hơn, nhanh hơn
> - Dễ deploy
> 
> **Production có thể dùng VM:**
> - Isolation tốt hơn
> - Security cao hơn
> - Full Windows features"

---

### Q23: Docker Image vs Container?
**Trả lời:**
> "**Image:**
> - Template, blueprint
> - Read-only
> - Chứa OS + app + config
> - Ví dụ: mcr.microsoft.com/mssql/server:2019-latest
> 
> **Container:**
> - Running instance của image
> - Read-write
> - Có thể start/stop/delete
> - Ví dụ: SITE_HANOI, SITE_DANANG
> 
> **Analogy:**
> - Image = Class (OOP)
> - Container = Object/Instance
> 
> **Workflow:**
> ```
> 1. Pull image: docker pull mssql/server:2019
> 2. Run container: docker run --name SITE_HANOI ...
> 3. Container chạy từ image
> ```
> 
> **Em có:**
> - 1 image (SQL Server 2019)
> - 3 containers (HANOI, DANANG, SAIGON)"

---

### Q24: Docker Compose là gì?
**Trả lời:**
> "Docker Compose quản lý nhiều containers.
> 
> **File YAML định nghĩa:**
> - Services (containers)
> - Networks
> - Volumes
> - Environment variables
> 
> **docker-compose.yml của em:**
> ```yaml
> services:
>   site-hanoi:
>     image: mssql/server:2019
>     ports: [1433:1433]
>   
>   site-danang:
>     image: mssql/server:2019
>     ports: [1434:1433]
>   
>   site-saigon:
>     image: mssql/server:2019
>     ports: [1435:1433]
> ```
> 
> **Commands:**
> - `docker-compose up -d`: Start tất cả
> - `docker-compose down`: Stop tất cả
> - `docker-compose ps`: List services
> 
> **Lợi ích:**
> - 1 command start cả system
> - Version control config
> - Dễ reproduce"

---

### Q25: Docker volumes là gì?
**Trả lời:**
> "Volumes lưu trữ persistent data.
> 
> **Vấn đề:**
> Container bị xóa → Data mất.
> 
> **Solution:**
> Mount volume từ host vào container.
> 
> **Em sử dụng:**
> ```yaml
> volumes:
>   - sqlserver_hanoi:/var/opt/mssql
> ```
> 
> `/var/opt/mssql` = nơi SQL Server lưu data files.
> 
> **Lợi ích:**
> - Persist data khi container restart
> - Backup dễ dàng
> - Share data giữa containers
> 
> **Commands:**
> - `docker volume ls`: List volumes
> - `docker volume inspect`: Xem details
> - `docker volume rm`: Xóa volume
> 
> **Em có 3 volumes:**
> - sqlserver_hanoi
> - sqlserver_danang
> - sqlserver_saigon"

---

### Q26: Docker networking?
**Trả lời:**
> "Docker tạo virtual network cho containers giao tiếp.
> 
> **Em sử dụng bridge network:**
> ```yaml
> networks:
>   distributed_db_network:
>     driver: bridge
>     ipam:
>       config:
>         - subnet: 172.20.0.0/24
> ```
> 
> **Static IPs:**
> - SITE_HANOI: 172.20.0.11
> - SITE_DANANG: 172.20.0.12
> - SITE_SAIGON: 172.20.0.13
> 
> **Containers communicate:**
> - Via IPs: 172.20.0.12
> - Via names: site-danang
> 
> **Port mapping:**
> - Host:Container
> - 1433:1433 (HANOI)
> - 1434:1433 (DANANG)
> - 1435:1433 (SAIGON)
> 
> **Lợi ích:**
> - Isolation
> - Service discovery
> - Load balancing"

---

### Q27: Tại sao chọn Docker thay vì VirtualBox?
**Trả lời:**
> "**Decision factors:**
> 
> **Docker (Em chọn):**
> ✅ Setup nhanh: 30 phút
> ✅ Nhẹ: 8GB RAM đủ cho 3 sites
> ✅ Reproducible: 1 script chạy ở bất kỳ đâu
> ✅ Modern, industry standard
> ✅ Phù hợp demo/development
> 
> **VirtualBox:**
> ✅ Full Windows features
> ✅ SQL Server Replication đầy đủ
> ✅ GUI dễ dùng
> ✅ Isolation tốt hơn
> 
> ❌ Setup lâu: 10+ giờ
> ❌ Nặng: 16GB+ RAM
> ❌ Khó reproduce
> 
> **Trade-offs:**
> Docker: Thiếu Replication, nhưng có Linked Server workaround.
> VirtualBox: Đầy đủ features, nhưng resource intensive.
> 
> **Kết luận:**
> Demo/academic: Docker
> Production: Có thể VMs hoặc cloud (Azure SQL)"

---

### Q28: Docker security?
**Trả lời:**
> "**Security considerations:**
> 
> **1. Container isolation:**
> - Namespaces: Process isolation
> - cgroups: Resource limits
> - Không có root access host
> 
> **2. SQL Server password:**
> - SA_PASSWORD environment variable
> - Em dùng: Admin@123456 (demo only)
> - Production: Secrets management (Docker Secrets, Vault)
> 
> **3. Network:**
> - Bridge network isolated
> - Firewall rules
> - Only expose needed ports
> 
> **4. Volumes:**
> - Data encryption at rest (optional)
> - Backup encrypted
> 
> **Best practices em follow:**
> - Không dùng :latest tag
> - Scan images cho vulnerabilities
> - Least privilege principle
> - Regular updates
> 
> **Production improvements:**
> - Use Docker Secrets
> - SSL/TLS cho connections
> - Network segmentation
> - Monitoring/logging"

---

## 💾 NHÓM 4: SQL SERVER

### Q29: Tại sao chọn SQL Server?
**Trả lời:**
> "**Lý do:**
> 
> 1. **Đề bài yêu cầu:** 
>    - Enterprise DBMS
>    - SQL Server phù hợp
> 
> 2. **Features phong phú:**
>    - Replication
>    - Linked Servers
>    - Full-text search
>    - SSRS, SSIS, SSAS
> 
> 3. **Enterprise-grade:**
>    - High availability
>    - Security
>    - Performance
> 
> 4. **Learning:**
>    - Phổ biến trong doanh nghiệp
>    - Tài liệu đầy đủ
> 
> **Alternatives:**
> - MySQL: Free, lightweight
> - PostgreSQL: Open-source, powerful
> - Oracle: Enterprise, đắt
> 
> **Em chọn SQL Server 2019 Developer:**
> - Free
> - Full features (như Enterprise)
> - Linux support (cho Docker)"

---

### Q30: SQL Server editions?
**Trả lời:**
> "**4 Editions chính:**
> 
> **1. Express (Free):**
> - Database < 10GB
> - RAM < 1GB
> - Phù hợp: Small apps
> 
> **2. Developer (Free):**
> - Full features như Enterprise
> - CHỈ cho dev/test
> - EM DÙNG CÁI NÀY
> 
> **3. Standard ($$$):**
> - Database unlimited
> - Basic HA features
> - Phù hợp: SMB
> 
> **4. Enterprise ($$$$):**
> - Advanced HA (Always On)
> - Partitioning
> - Advanced security
> - Phù hợp: Large enterprise
> 
> **Em chọn Developer vì:**
> - Free
> - Full features để học
> - Đủ cho demo/research"

---

### Q31: T-SQL vs SQL?
**Trả lời:**
> "**SQL:**
> - Standard language
> - ANSI SQL
> - Work với mọi DBMS
> 
> **T-SQL (Transact-SQL):**
> - Microsoft's extension
> - Chỉ SQL Server
> - Thêm nhiều features
> 
> **T-SQL additions:**
> - Variables: DECLARE @name VARCHAR(100)
> - Control flow: IF, WHILE, BEGIN...END
> - Error handling: TRY...CATCH
> - Functions: STRING_SPLIT(), FORMAT()
> - Stored procedures
> - Triggers
> 
> **Ví dụ T-SQL:**
> ```sql
> DECLARE @count INT;
> SELECT @count = COUNT(*) FROM NhanVien;
> IF @count > 100
>   PRINT 'Nhiều nhân viên'
> ELSE
>   PRINT 'Ít nhân viên';
> ```
> 
> ANSI SQL không có variables, IF."

---

### Q32: SQL Server authentication modes?
**Trả lời:**
> "**2 modes:**
> 
> **1. Windows Authentication (Recommended):**
> - Dùng Windows credentials
> - Single sign-on
> - Centralized management (Active Directory)
> - Secure hơn
> 
> **2. SQL Server Authentication:**
> - Username/password riêng
> - Em dùng: sa / Admin@123456
> - Cần quản lý passwords
> 
> **Mixed Mode:**
> - Cả 2 cùng lúc
> 
> **Em dùng SQL Auth vì:**
> - Docker Linux không có Windows Auth
> - Đơn giản cho demo
> - Cross-platform
> 
> **Production:**
> - Windows Auth trong domain
> - Service accounts
> - Azure AD cho Azure SQL"

---

### Q33: SQL Server system databases?
**Trả lời:**
> "**4 system databases:**
> 
> **1. master:**
> - Metadata của server
> - Login accounts
> - Linked servers
> - Server config
> 
> **2. model:**
> - Template cho databases mới
> - Mọi CREATE DATABASE copy từ model
> 
> **3. msdb:**
> - SQL Server Agent jobs
> - Backup history
> - Mail config
> 
> **4. tempdb:**
> - Temporary tables
> - Temp data
> - Recreated mỗi khi restart
> 
> **Em không modify:**
> - Chỉ tạo user database: QuanLyNhanSu
> - System DBs auto managed
> 
> **Best practice:**
> - Backup master, model, msdb
> - Không backup tempdb
> - Monitor tempdb size"

---

### Q34: SQL Server data files?
**Trả lời:**
> "**3 loại files:**
> 
> **1. Primary data file (.mdf):**
> - 1 file per database
> - Chứa data + metadata
> - Ví dụ: QuanLyNhanSu.mdf
> 
> **2. Secondary data files (.ndf):**
> - Optional
> - Thêm khi cần space
> - Multiple filegroups
> 
> **3. Log file (.ldf):**
> - Transaction log
> - Recovery
> - Ví dụ: QuanLyNhanSu_log.ldf
> 
> **Em có:**
> ```
> /var/opt/mssql/data/
>   ├── QuanLyNhanSu.mdf (data)
>   └── QuanLyNhanSu_log.ldf (log)
> ```
> 
> **Log file:**
> - Write-ahead logging
> - ACID durability
> - Point-in-time recovery
> 
> **Filegroups:**
> - PRIMARY: Default
> - Có thể tạo custom filegroups
> - Partition data across files"

---

### Q35: Backup strategies?
**Trả lời:**
> "**3 loại backup:**
> 
> **1. Full Backup:**
> - Toàn bộ database
> - Baseline
> - Chạy weekly
> 
> **2. Differential Backup:**
> - Thay đổi từ full backup cuối
> - Nhanh hơn full
> - Chạy daily
> 
> **3. Transaction Log Backup:**
> - Log file
> - Point-in-time recovery
> - Chạy hourly hoặc 15 phút
> 
> **Recovery models:**
> - Simple: No log backup
> - Full: All log backup
> - Bulk-logged: Bulk operations minimal log
> 
> **Em có script:**
> `docker-backup.sh` backup tất cả 3 sites.
> 
> **Strategy:**
> - Full: Chủ nhật
> - Diff: Thứ 2-6
> - Log: Mỗi giờ
> 
> **Restore:**
> 1. Restore full backup
> 2. Restore diff backup
> 3. Restore log backups"

---

### Q36: Performance tuning?
**Trả lời:**
> "**Key areas:**
> 
> **1. Indexes:**
> - Identify missing indexes
> - Remove unused indexes
> - Em có 12+ indexes
> 
> **2. Query optimization:**
> - Execution plans
> - Avoid SELECT *
> - Use WHERE clauses
> - Proper JOINs
> 
> **3. Statistics:**
> - Auto update statistics
> - Manual UPDATE STATISTICS nếu cần
> 
> **4. Locks/blocking:**
> - Monitor sp_who2
> - Appropriate isolation levels
> - Shorter transactions
> 
> **5. Resource limits:**
> - Max memory
> - CPU affinity
> - TempDB config
> 
> **Em implement:**
> - Proper indexes
> - Views cho complex queries
> - Stored procedures (compiled plans)
> 
> **Tools:**
> - Execution plans
> - DMVs (Dynamic Management Views)
> - SQL Server Profiler
> - Query Store"

---

### Q37: SQL Server high availability?
**Trả lời:**
> "**HA Options:**
> 
> **1. Always On Availability Groups:**
> - Enterprise edition
> - Multiple replicas
> - Auto failover
> 
> **2. Failover Cluster Instances:**
> - Shared storage
> - Active-passive
> 
> **3. Log Shipping:**
> - Copy/restore log backups
> - Manual failover
> 
> **4. Replication:**
> - Data redundancy
> - Read replicas
> 
> **5. Database Mirroring:**
> - Deprecated
> - 1-to-1 failover
> 
> **Em không implement HA vì:**
> - Docker development setup
> - Single host
> - Demo purposes
> 
> **Production approach:**
> - Azure SQL (built-in HA)
> - Always On AG (3+ replicas)
> - Load balancer
> - Monitoring/alerts"

---

### Q38: Monitoring SQL Server?
**Trả lời:**
> "**What to monitor:**
> 
> **1. Performance:**
> - CPU usage
> - Memory pressure
> - Disk I/O
> - Wait statistics
> 
> **2. Activity:**
> - Active connections
> - Blocked queries
> - Long-running queries
> 
> **3. Health:**
> - Error log
> - Failed logins
> - Deadlocks
> 
> **4. Capacity:**
> - Database size
> - Log file size
> - TempDB usage
> 
> **Em có script:**
> `docker-monitor.sh` shows:
> - Container status
> - Memory/CPU
> - Connection count
> - Recent queries
> 
> **Queries:**
> ```sql
> -- Active connections
> SELECT * FROM sys.dm_exec_connections
> 
> -- Wait statistics
> SELECT * FROM sys.dm_os_wait_stats
> 
> -- Resource usage
> SELECT * FROM sys.dm_os_performance_counters
> ```
> 
> **Tools:**
> - SQL Server Management Studio
> - sp_who2, sp_Blitz
> - Third-party: SolarWinds, Redgate"

---

### Q39: SQL injection prevention?
**Trả lời:**
> "**SQL Injection:**
> Kẻ tấn công inject malicious SQL.
> 
> **Ví dụ vulnerable code:**
> ```sql
> -- Nhận input từ user: ' OR '1'='1
> SELECT * FROM NhanVien WHERE HoTen = '' OR '1'='1'
> -- Returns tất cả nhân viên!
> ```
> 
> **Prevention methods:**
> 
> **1. Parameterized queries (Best):**
> ```sql
> DECLARE @name NVARCHAR(100) = @inputName;
> SELECT * FROM NhanVien WHERE HoTen = @name;
> ```
> 
> **2. Stored procedures:**
> ```sql
> CREATE PROC sp_GetNhanVien @name NVARCHAR(100)
> AS
>   SELECT * FROM NhanVien WHERE HoTen = @name;
> ```
> 
> **3. Input validation:**
> - Whitelist characters
> - Length limits
> - Type checking
> 
> **4. Least privilege:**
> - App user không có DROP/ALTER rights
> - Chỉ SELECT/INSERT/UPDATE
> 
> **Em implement:**
> - Stored procedures
> - Parameters
> - Role-based access
> 
> **Never:**
> - Dynamic SQL với user input
> - String concatenation"

---

### Q40: Execution plans?
**Trả lời:**
> "**Execution plan:**
> SQL Server's strategy để chạy query.
> 
> **2 loại:**
> 
> **1. Estimated:**
> - Before execution
> - Based on statistics
> 
> **2. Actual:**
> - After execution
> - Real metrics
> 
> **Key operations:**
> - **Table Scan:** Đọc hết table (chậm)
> - **Index Seek:** Dùng index (nhanh)
> - **Nested Loop:** JOIN algorithm
> - **Hash Match:** JOIN cho large tables
> - **Sort:** ORDER BY operation
> 
> **Read plan:**
> - Right to left, top to bottom
> - Cost % for each operation
> - Identify bottlenecks
> 
> **Em dùng:**
> ```sql
> SET SHOWPLAN_ALL ON;
> SELECT * FROM NhanVien WHERE ID_ChucVu = 'CV01';
> SET SHOWPLAN_ALL OFF;
> ```
> 
> **Optimization:**
> - Thấy Table Scan → Thêm index
> - High cost operation → Optimize
> - Missing index hints"

---

## 🏗️ NHÓM 5: DESIGN & IMPLEMENTATION

### Q41: Database design process?
**Trả lời:**
> "**4 phases:**
> 
> **1. Requirements Analysis:**
> - Hiểu business needs
> - Em: Quản lý nhân viên đa chi nhánh
> 
> **2. Conceptual Design:**
> - ER Diagram
> - Entities: NhanVien, PhongBan, ChiNhanh...
> - Relationships: 1-n, n-m
> 
> **3. Logical Design:**
> - Convert ER → Tables
> - Normalization (1NF, 2NF, 3NF)
> - Define constraints
> 
> **4. Physical Design:**
> - Indexes
> - Partitioning
> - Storage
> 
> **Em follow:**
> - Phân tích đề bài
> - Vẽ ER diagram (8 entities)
> - Normalize tables
> - Create schema
> - Add indexes
> - Implement business logic"

---

### Q42: Normalization là gì?
**Trả lời:**
> "**Normalization:**
> Organize data để reduce redundancy.
> 
> **Normal Forms:**
> 
> **1NF:**
> - Atomic values (no arrays)
> - Mỗi column 1 giá trị
> 
> **2NF:**
> - 1NF + No partial dependencies
> - Non-key attributes depend on whole PK
> 
> **3NF:**
> - 2NF + No transitive dependencies
> - Non-key attributes không depend on other non-key
> 
> **Ví dụ unnormalized:**
> ```
> NhanVien: ID, HoTen, PhongBan, TenPhongBan, ChiNhanh, TenChiNhanh
> ```
> Redundant: TenPhongBan, TenChiNhanh lặp lại.
> 
> **Normalized (3NF):**
> ```
> NhanVien: ID, HoTen, ID_PhongBan, ID_ChiNhanh
> PhongBan: ID_PhongBan, TenPhongBan
> ChiNhanh: ID_ChiNhanh, TenChiNhanh
> ```
> 
> **Em normalize đến 3NF.**
> 
> **Trade-offs:**
> - Ít redundancy
> - Nhiều JOINs (có thể chậm)
> - Denormalize cho performance nếu cần"

---

### Q43: Constraints là gì?
**Trả lời:**
> "**Constraints:**
> Rules enforce data integrity.
> 
> **Types:**
> 
> **1. PRIMARY KEY:**
> - Unique, not null
> - `ID_NhanVien VARCHAR(10) PRIMARY KEY`
> 
> **2. FOREIGN KEY:**
> - Reference другой table
> - `ID_PhongBan VARCHAR(10) REFERENCES PhongBan(ID_PhongBan)`
> 
> **3. UNIQUE:**
> - No duplicates
> - `Email VARCHAR(100) UNIQUE`
> 
> **4. NOT NULL:**
> - Must have value
> - `HoTen NVARCHAR(100) NOT NULL`
> 
> **5. CHECK:**
> - Custom condition
> - `CHECK (Luong > 0)`
> 
> **6. DEFAULT:**
> - Default value
> - `NgayTao DATE DEFAULT GETDATE()`
> 
> **Em sử dụng:**
> - PK on all tables
> - FK for relationships
> - NOT NULL cho required fields
> - CHECK trong triggers (tuổi > 18)
> 
> **Benefits:**
> - Data integrity
> - Prevent bad data
> - Business rules enforcement"

---

### Q44: Giải thích table relationships?
**Trả lời:**
> "**3 types:**
> 
> **1. One-to-One (1:1):**
> - Hiếm
> - Ví dụ: NhanVien ↔ ThongTinCaNhan
> - Em không dùng (merge vào 1 table)
> 
> **2. One-to-Many (1:n):**
> - Phổ biến nhất
> - Ví dụ:
>   - ChiNhanh (1) → PhongBan (n)
>   - PhongBan (1) → NhanVien (n)
>   - NhanVien (1) → Luong (n)
> 
> **3. Many-to-Many (n:m):**
> - Cần junction table
> - Ví dụ: NhanVien ↔ DuAn
> - Junction: NhanVien_DuAn
> 
> **Implement:**
> ```sql
> -- 1:n
> CREATE TABLE PhongBan (
>   ID_PhongBan VARCHAR(10) PRIMARY KEY,
>   ID_ChiNhanh VARCHAR(10) REFERENCES ChiNhanh(ID_ChiNhanh)
> );
> 
> -- n:m
> CREATE TABLE NhanVien_DuAn (
>   ID_NhanVien VARCHAR(10) REFERENCES NhanVien(ID_NhanVien),
>   ID_DuAn VARCHAR(10) REFERENCES DuAn(ID_DuAn),
>   PRIMARY KEY (ID_NhanVien, ID_DuAn)
> );
> ```
> 
> **Em có:**
> - Nhiều 1:n relationships
> - 1 n:m (if needed cho NhanVien-DuAn)"

---

### Q45: Data types selection?
**Trả lời:**
> "**Key principles:**
> 
> **1. Use appropriate size:**
> - ID_NhanVien: VARCHAR(10) (not VARCHAR(MAX))
> - Saves space
> 
> **2. NVARCHAR cho Unicode:**
> - HoTen: NVARCHAR(100)
> - Support tiếng Việt: Nguyễn Văn A
> 
> **3. DATE types:**
> - NgaySinh: DATE (không cần time)
> - NgayTao: DATETIME (có time)
> 
> **4. DECIMAL cho money:**
> - Luong: DECIMAL(18,2)
> - Avoid FLOAT (rounding errors)
> 
> **5. BIT cho boolean:**
> - DaXoa: BIT
> - 0/1 only
> 
> **Em's choices:**
> ```sql
> ID_NhanVien VARCHAR(10)      -- Short, fixed
> HoTen NVARCHAR(100)           -- Unicode
> Email VARCHAR(100)            -- ASCII
> NgaySinh DATE                 -- No time needed
> Luong DECIMAL(18,2)           -- Money
> GioiTinh NVARCHAR(10)         -- 'Nam'/'Nữ'
> ```
> 
> **Trade-offs:**
> - VARCHAR vs NVARCHAR: Space vs Unicode
> - INT vs BIGINT: Range vs size
> - DATE vs DATETIME: Precision vs size"

---

### Q46: Why this architecture?
**Trả lời:**
> "**Design decisions:**
> 
> **1. 3 sites:**
> - Representative of multi-branch
> - Not too simple (1 site)
> - Not too complex (7 sites)
> - Phù hợp demo
> 
> **2. Linked Servers:**
> - Docker Linux limitation (no Replication)
> - Distributed queries
> - Proof of concept
> 
> **3. Master-slave:**
> - HANOI = master (write)
> - DANANG, SAIGON = replicas (read)
> - Avoid conflicts
> 
> **4. Docker:**
> - Fast setup
> - Reproducible
> - Lightweight
> - Industry standard
> 
> **5. Views cho fragmentation:**
> - Simple implementation
> - No physical fragmentation
> - Flexible
> 
> **Alternatives considered:**
> - VirtualBox: Too heavy
> - Azure SQL: Need credit card
> - MySQL: No Linked Server equivalent
> 
> **Result:**
> Practical balance of features, complexity, and resources."

---

### Q47: Testing approach?
**Trả lời:**
> "**Testing strategy:**
> 
> **1. Unit tests:**
> - Mỗi stored procedure
> - Mỗi function
> - Mỗi trigger
> 
> **2. Integration tests:**
> - Linked Server queries
> - Cross-site transactions
> 
> **3. Boundary tests:**
> - Tuổi < 18 (should fail)
> - Lương <= 0 (should fail)
> - Invalid FK (should fail)
> 
> **4. Performance tests:**
> - Query response time
> - Large data sets
> 
> **Em có file:**
> `Test-Physical-Implementation.sql` với 40+ tests.
> 
> **Test cases:**
> ```sql
> -- Test 1: Insert valid nhân viên
> EXEC sp_ThemNhanVien @ID='NV999', @HoTen='Test', ...
> 
> -- Test 2: Insert nhân viên < 18 tuổi (should fail)
> EXEC sp_ThemNhanVien @NgaySinh='2010-01-01'
> 
> -- Test 3: Linked Server query
> SELECT * FROM SITE_DANANG.QuanLyNhanSu.dbo.ChiNhanh
> ```
> 
> **Test results:**
> ✅ 38/40 passed
> ❌ 2 failed (known limitations)
> 
> **CI/CD:**
> Production sẽ có automated tests."

---

### Q48: Error handling?
**Trả lời:**
> "**Error handling trong SQL:**
> 
> **1. TRY...CATCH:**
> ```sql
> CREATE PROCEDURE sp_ThemNhanVien
> AS
> BEGIN
>   BEGIN TRY
>     -- Business logic
>     INSERT INTO NhanVien VALUES (...)
>   END TRY
>   BEGIN CATCH
>     -- Log error
>     INSERT INTO ErrorLog VALUES (ERROR_MESSAGE())
>     -- Re-throw
>     THROW;
>   END CATCH
> END
> ```
> 
> **2. THROW vs RAISERROR:**
> - THROW: SQL 2012+, simpler
> - RAISERROR: Older, more options
> 
> **3. Transactions:**
> ```sql
> BEGIN TRANSACTION;
> BEGIN TRY
>   UPDATE ...;
>   INSERT ...;
>   COMMIT;
> END TRY
> BEGIN CATCH
>   ROLLBACK;
>   THROW;
> END CATCH
> ```
> 
> **4. Validation:**
> - Check inputs
> - Business rules
> - FK constraints
> 
> **Em implement:**
> - TRY...CATCH in procedures
> - Triggers cho validation
> - Transactions cho multi-step operations
> - Audit logs
> 
> **Error types:**
> - 50000+: Custom errors
> - THROW 50001, 'Message', 1"

---

### Q49: Documentation approach?
**Trả lời:**
> "**Documentation structure:**
> 
> **1. README.md:**
> - Project overview
> - Quick start
> - Requirements
> 
> **2. QUICKSTART.md:**
> - Step-by-step setup
> - 5 phút đến running
> 
> **3. ARCHITECTURE.md:**
> - System design
> - Components
> - Data flow
> 
> **4. API-REFERENCE.md:**
> - Stored procedures
> - Functions
> - Parameters
> 
> **5. DEPLOYMENT-GUIDE.md:**
> - Production deployment
> - Scaling
> - HA setup
> 
> **6. HUONG-DAN-BAO-VE/ (12 files):**
> - Beginner friendly
> - Vietnamese
> - Defense preparation
> 
> **Total:**
> ~15 files, ~200 pages
> 
> **Principles:**
> - Clear language
> - Examples
> - Screenshots
> - Analogies
> - Progressive difficulty
> 
> **Audience:**
> - Developers
> - DevOps
> - Students
> - Instructors
> 
> **Maintenance:**
> - Update with code changes
> - Version control
> - Review periodically"

---

### Q50: Future improvements?
**Trả lời:**
> "**Roadmap:**
> 
> **Phase 1: Current (✅ Done)**
> - 3 sites
> - Basic Linked Servers
> - Core functionality
> 
> **Phase 2: Enhanced Distributed (Next)**
> - Scale to 7 sites
> - Replication (if VMs)
> - Load balancing
> - Failover testing
> 
> **Phase 3: Production Ready**
> - Kubernetes deployment
> - Auto-scaling
> - Monitoring (Prometheus/Grafana)
> - Backup automation
> - SSL/TLS
> 
> **Phase 4: Advanced Features**
> - Machine learning integration
> - Reporting dashboards (Power BI)
> - Mobile app
> - Real-time notifications
> 
> **Technical debt:**
> - No full Replication (Docker limit)
> - Manual sync
> - Limited screenshots
> 
> **Would implement:**
> - Always On Availability Groups
> - Change Data Capture (CDC)
> - Temporal tables
> - Full-text search
> - Row-level security
> 
> **Cloud migration:**
> - Azure SQL Database
> - Geo-replication
> - Auto-backup
> - Built-in HA"

---

## 🔒 NHÓM 6: PERFORMANCE & SECURITY

*(Thêm 8 câu hỏi về performance tuning và security nếu cần)*

---

## 💡 TIPS TRẢ LỜI

1. **Listen carefully:** Nghe kỹ câu hỏi
2. **Pause 2-3 giây:** Suy nghĩ trước khi trả lời
3. **Structure:** Có đầu-thân-kết
4. **Examples:** Luôn có ví dụ cụ thể
5. **Be honest:** Không biết thì nói không biết
6. **Link to project:** Kết nối câu trả lời với đồ án
7. **Time management:** Không nói quá dài

---

**Good luck! You got this! 🎯**
