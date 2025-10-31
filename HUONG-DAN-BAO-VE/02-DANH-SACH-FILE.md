# 📂 DANH SÁCH FILE TRONG PROJECT
## Giải thích chi tiết từng file - Dành cho người mới

---

## 🗂️ TỔNG QUAN FOLDER

Folder `BTL-CSDLPT-PTIT` có **30+ files** được chia thành **6 nhóm**:

```
BTL-CSDLPT-PTIT/
├── 📄 1. FILES TÀI LIỆU WORD (2 files)
├── 📜 2. FILES SQL (5 files)  
├── 🐳 3. FILES DOCKER (8 files)
├── 📖 4. FILES DOCUMENTATION (14 files)
├── 📁 5. FOLDERS (2 folders)
└── ⚙️  6. FILES CẤU HÌNH (1 file)
```

---

## 📄 NHÓM 1: TÀI LIỆU WORD (2 files)

### 1.1 `CSDLPT - Nhom 5 - Quan ly nhan vien.docx` ⭐⭐⭐⭐⭐
**Mục đích:** Đề bài và yêu cầu của giảng viên  
**Nội dung:**
- Đề tài: Quản lý nhân viên công ty đa chi nhánh
- Yêu cầu chi tiết
- Phân quyền người dùng
- Chức năng cần làm
- Ví dụ SQL queries

**Khi nào dùng:**
- Đọc để hiểu yêu cầu
- Kiểm tra xem đã làm đủ chưa
- Chuẩn bị câu trả lời cho giảng viên

**Quan trọng:** ⭐⭐⭐⭐⭐ (Rất quan trọng - Đề bài gốc)

---

### 1.2 `BÀI-TẬP-LỚN-CỦA-MỖI-NHÓM_2025_vienkinhte.docx`
**Mục đích:** Hướng dẫn chung của giảng viên  
**Nội dung:**
- Phần 3.1: Cài đặt VPN
- Phần 3.2: Tạo liên kết mạng
- Phần 3.3: Cài SQL Server
- Phần 3.4: Kiểm tra Agent
- Phần 3.5: Tạo Linked Server
- Phần 3.6: Tạo Publication
- Phần 3.7: Test giao dịch

**Quan trọng:** ⭐⭐⭐⭐ (Hướng dẫn từ giảng viên)

---

## 📜 NHÓM 2: FILES SQL (5 files)

### 2.1 `HR.sql` ⭐⭐⭐⭐⭐
**Mục đích:** Tạo cấu trúc database (tables)  
**Nội dung:**
```sql
CREATE DATABASE QuanLyNhanSu;
CREATE TABLE TruSoChinh (...);
CREATE TABLE ChiNhanh (...);
CREATE TABLE PhongBan (...);
CREATE TABLE DuAn (...);
CREATE TABLE ChucVu (...);
CREATE TABLE NhanVien (...);
CREATE TABLE Luong (...);
CREATE TABLE ChinhSach (...);
```

**Khi nào dùng:**
- Chạy đầu tiên để tạo database
- Tạo 8 bảng chính

**Quan trọng:** ⭐⭐⭐⭐⭐ (Phải chạy trước tiên!)

**Kích thước:** ~2KB  
**Số dòng:** ~100 dòng

---

### 2.2 `HR-Data.sql` ⭐⭐⭐⭐⭐
**Mục đích:** Thêm dữ liệu mẫu vào database  
**Nội dung:**
```sql
INSERT INTO TruSoChinh VALUES (...);    -- 1 record
INSERT INTO ChiNhanh VALUES (...);      -- 10 records
INSERT INTO PhongBan VALUES (...);      -- 10 records
INSERT INTO DuAn VALUES (...);          -- 10 records
INSERT INTO ChucVu VALUES (...);        -- 10 records
INSERT INTO NhanVien VALUES (...);      -- 40 records
INSERT INTO Luong VALUES (...);         -- 40 records
INSERT INTO ChinhSach VALUES (...);     -- 10 records
```

**Khi nào dùng:**
- Chạy sau HR.sql
- Tạo 131 bản ghi dữ liệu mẫu

**Quan trọng:** ⭐⭐⭐⭐⭐ (Phải chạy sau HR.sql!)

**Kích thước:** ~13KB  
**Số dòng:** ~200 dòng

---

### 2.3 `Physical-Implementation.sql` ⭐⭐⭐⭐⭐
**Mục đích:** Tạo Views, Procedures, Functions, Triggers, Indexes  
**Nội dung:**
```sql
-- PHẦN 1: PHÂN MẢNH (Fragmentation Views)
CREATE VIEW View_NhanVien_CN01 AS ...    -- 8 views
CREATE VIEW View_Luong_CaoCap AS ...

-- PHẦN 2: STORED PROCEDURES
CREATE PROCEDURE sp_ThemNhanVien ...     -- 6 procedures
CREATE PROCEDURE sp_CapNhatNhanVien ...

-- PHẦN 3: FUNCTIONS
CREATE FUNCTION fn_TongNhanVienTheoChiNhanh ...  -- 6 functions

-- PHẦN 4: TRIGGERS
CREATE TRIGGER trg_KiemTraTuoiNhanVien ...       -- 4 triggers

-- PHẦN 5: REPORTING VIEWS
CREATE VIEW View_ThongTinNhanVienChiTiet ...     -- 6 views

-- PHẦN 6: INDEXES
CREATE INDEX idx_NhanVien_ChiNhanh ...           -- 12+ indexes

-- PHẦN 7: SECURITY
CREATE ROLE Role_Admin ...                       -- 5 roles
```

**Khi nào dùng:**
- Chạy sau HR-Data.sql
- Tạo tất cả business logic

**Quan trọng:** ⭐⭐⭐⭐⭐ (Core functionality!)

**Kích thước:** ~20KB  
**Số dòng:** ~600 dòng

---

### 2.4 `Test-Physical-Implementation.sql` ⭐⭐⭐⭐
**Mục đích:** Kiểm tra xem tất cả có hoạt động không  
**Nội dung:**
```sql
-- TEST 1: Kiểm tra tables
SELECT COUNT(*) FROM NhanVien;

-- TEST 2: Kiểm tra views
SELECT * FROM View_NhanVien_CN01;

-- TEST 3: Kiểm tra procedures
EXEC sp_ThemNhanVien @ID_NhanVien='TEST01', ...;

-- TEST 4: Kiểm tra functions
SELECT dbo.fn_TongNhanVienTheoChiNhanh('CN01');

-- TEST 5: Kiểm tra triggers
INSERT INTO NhanVien VALUES (...);  -- Tuổi < 18 → Lỗi

-- ... 40+ test cases
```

**Khi nào dùng:**
- Sau khi setup xong
- Kiểm tra mọi thứ hoạt động

**Quan trọng:** ⭐⭐⭐⭐ (Để test!)

**Kích thước:** ~12KB  
**Số dòng:** ~300 dòng

---

### 2.5 `Deploy-Full.sql` ⭐⭐⭐
**Mục đích:** Chạy tất cả trong 1 file  
**Nội dung:**
```sql
-- Chạy HR.sql
-- Chạy HR-Data.sql
-- Chạy Physical-Implementation.sql
-- Tất cả trong 1 file
```

**Khi nào dùng:**
- Muốn deploy nhanh
- Alternative thay vì chạy từng file

**Quan trọng:** ⭐⭐⭐ (Optional - có thể dùng)

---

## 🐳 NHÓM 3: FILES DOCKER (8 files)

### 3.1 `install-docker.sh` ⭐⭐⭐⭐⭐
**Mục đích:** Cài Docker tự động  
**Cách dùng:**
```bash
./install-docker.sh
```

**Khi nào dùng:**
- Máy chưa có Docker
- Lần đầu tiên setup

**Quan trọng:** ⭐⭐⭐⭐⭐ (Bắt buộc nếu chưa có Docker!)

---

### 3.2 `docker-compose.yml` ⭐⭐⭐⭐⭐
**Mục đích:** Cấu hình 3 containers SQL Server  
**Nội dung:**
```yaml
services:
  sqlserver-hanoi:
    image: mcr.microsoft.com/mssql/server:2019-latest
    ports: 1433:1433
    
  sqlserver-danang:
    ports: 1434:1433
    
  sqlserver-saigon:
    ports: 1435:1433
```

**Khi nào dùng:**
- Docker đọc file này để tạo containers
- Không cần chỉnh sửa

**Quan trọng:** ⭐⭐⭐⭐⭐ (Core config!)

---

### 3.3 `docker-setup.sh` ⭐⭐⭐
**Mục đích:** Setup ban đầu (cũ, ít dùng)  
**Cách dùng:**
```bash
./docker-setup.sh
```

**Quan trọng:** ⭐⭐⭐ (Có thể bỏ qua, dùng docker-complete-setup.sh)

---

### 3.4 `docker-complete-setup.sh` ⭐⭐⭐⭐⭐
**Mục đích:** ONE-CLICK SETUP - Tự động làm mọi thứ!  
**Cách dùng:**
```bash
./docker-complete-setup.sh
```

**Nó làm gì:**
1. Tạo database trên cả 3 sites
2. Chạy HR.sql
3. Chạy HR-Data.sql
4. Chạy Physical-Implementation.sql
5. Tạo Linked Servers
6. Chạy tests
7. Hiển thị thông tin kết nối

**Khi nào dùng:**
- Setup lần đầu
- Muốn tạo lại từ đầu

**Quan trọng:** ⭐⭐⭐⭐⭐ (KHUYÊN DÙNG NHẤT!)

---

### 3.5 `docker-quick-setup.sh` ⭐⭐⭐
**Mục đích:** Setup nhanh (đơn giản hơn)  
**Quan trọng:** ⭐⭐⭐ (Có thể dùng)

---

### 3.6 `docker-cleanup.sh` ⭐⭐⭐⭐
**Mục đích:** Xóa tất cả để bắt đầu lại  
**Cách dùng:**
```bash
./docker-cleanup.sh
```

**Khi nào dùng:**
- Muốn xóa hết và làm lại
- Database bị lỗi
- Reset về ban đầu

**Cảnh báo:** ⚠️ Xóa TẤT CẢ dữ liệu!

**Quan trọng:** ⭐⭐⭐⭐ (Để reset!)

---

### 3.7 `docker-backup.sh` ⭐⭐⭐⭐
**Mục đích:** Backup databases  
**Cách dùng:**
```bash
./docker-backup.sh
```

**Khi nào dùng:**
- Trước khi demo
- Backup định kỳ
- Trước khi thay đổi lớn

**Quan trọng:** ⭐⭐⭐⭐ (An toàn!)

---

### 3.8 `docker-monitor.sh` ⭐⭐⭐⭐
**Mục đích:** Theo dõi real-time  
**Cách dùng:**
```bash
./docker-monitor.sh
```

**Hiển thị:**
- Container status
- CPU/Memory usage
- SQL Server status
- Employee count
- Network connectivity

**Khi nào dùng:**
- Kiểm tra hệ thống
- Demo cho giảng viên

**Quan trọng:** ⭐⭐⭐⭐ (Để show off!)

---

## 📖 NHÓM 4: DOCUMENTATION (14 files)

### 4.1 `README.md` ⭐⭐⭐⭐⭐
**Mục đích:** Trang chủ project - đọc đầu tiên!  
**Nội dung:**
- Giới thiệu project
- Features
- Quick start
- Architecture
- Team members

**Quan trọng:** ⭐⭐⭐⭐⭐ (START HERE!)

---

### 4.2 `QUICKSTART.md` ⭐⭐⭐⭐⭐
**Mục đích:** Hướng dẫn setup nhanh (3 bước)  
**Nội dung:**
```bash
# Bước 1: Cài Docker
./install-docker.sh

# Bước 2: Khởi động
sudo docker compose up -d

# Bước 3: Setup
./docker-complete-setup.sh
```

**Quan trọng:** ⭐⭐⭐⭐⭐ (Để setup nhanh!)

---

### 4.3 `ARCHITECTURE.md` ⭐⭐⭐⭐
**Mục đích:** Giải thích kiến trúc hệ thống  
**Nội dung:**
- Sơ đồ kiến trúc
- Mô hình phân tán
- Network topology
- Data flow

**Khi nào dùng:**
- Hiểu cách hệ thống hoạt động
- Giải thích cho giảng viên

**Quan trọng:** ⭐⭐⭐⭐ (Để hiểu hệ thống!)

---

### 4.4 `DOCKER-SETUP.md` ⭐⭐⭐⭐
**Mục đích:** Hướng dẫn chi tiết về Docker  
**Nội dung:**
- Ưu điểm Docker
- So sánh Docker vs VirtualBox
- Setup từng bước
- ~15 screenshots cần thiết

**Quan trọng:** ⭐⭐⭐⭐ (Alternative approach!)

---

### 4.5 `HUONG-DAN-TRIEN-KHAI-THUC-TE.md` ⭐⭐⭐
**Mục đích:** Hướng dẫn VirtualBox (không dùng Docker)  
**Nội dung:**
- Setup VirtualBox
- Install Windows Server (3 VMs)
- Install SQL Server
- ~230 screenshots
- 8-10 giờ để hoàn thành

**Khi nào dùng:**
- Nếu giảng viên yêu cầu strict VirtualBox
- Hiện tại dùng Docker nên có thể bỏ qua

**Quan trọng:** ⭐⭐⭐ (Backup plan nếu cần)

---

### 4.6 `HUONG-DAN-SU-DUNG.md` ⭐⭐⭐⭐
**Mục đích:** User guide - Cách dùng hệ thống  
**Nội dung:**
- Kết nối với SSMS
- Chạy queries
- Sử dụng Procedures
- Examples

**Quan trọng:** ⭐⭐⭐⭐ (Hướng dẫn sử dụng!)

---

### 4.7 `README-Physical-Implementation.md` ⭐⭐⭐⭐
**Mục đích:** Giải thích chi tiết Physical-Implementation.sql  
**Nội dung:**
- Chi tiết 14 views
- Chi tiết 6 procedures
- Chi tiết 6 functions
- Chi tiết 4 triggers
- Examples và use cases

**Quan trọng:** ⭐⭐⭐⭐ (Technical documentation!)

---

### 4.8 `BAO-CAO-PHAN-3.md` ⭐⭐⭐⭐
**Mục đích:** Báo cáo Phần 3: Cài đặt vật lý  
**Quan trọng:** ⭐⭐⭐⭐ (Báo cáo chính thức!)

---

### 4.9 `CHECKLIST.md` ⭐⭐⭐⭐⭐
**Mục đích:** Checklist để kiểm tra đã làm gì  
**Nội dung:**
- [ ] Database schema
- [ ] Sample data
- [ ] Views
- [ ] Procedures
- [ ] Functions
- [ ] Triggers
- [ ] ...

**Quan trọng:** ⭐⭐⭐⭐⭐ (Để check progress!)

---

### 4.10 `INDEX.md` ⭐⭐⭐
**Mục đích:** Mục lục tất cả tài liệu  
**Quan trọng:** ⭐⭐⭐ (Tìm file nhanh!)

---

### 4.11 `TASK-COMPLETION-REPORT.md` ⭐⭐⭐⭐⭐
**Mục đích:** Báo cáo tổng kết - Đã làm gì?  
**Nội dung:**
- Core requirements: 95% ✅
- Bonus features
- Limitations
- Recommendations

**Quan trọng:** ⭐⭐⭐⭐⭐ (Để biết status!)

---

### 4.12 `SO-SANH-YEU-CAU.md` ⭐⭐⭐⭐⭐
**Mục đích:** So sánh yêu cầu vs thực tế  
**Nội dung:**
- Checklist từng yêu cầu
- Đã làm / Chưa làm
- Lý do nếu chưa làm
- % hoàn thành

**Quan trọng:** ⭐⭐⭐⭐⭐ (Để bảo vệ!)

---

### 4.13-4.14 `HUONG-DAN-BAO-VE/` folder
**Mục đích:** 12 files hướng dẫn bảo vệ chi tiết  
**Quan trọng:** ⭐⭐⭐⭐⭐ (Đang đọc đây!)

---

## 📁 NHÓM 5: FOLDERS (2 folders)

### 5.1 `scripts/` ⭐⭐⭐⭐⭐
**Mục đích:** Chứa SQL scripts cho Docker containers  
**Nội dung:**
```
scripts/
├── HR.sql
├── HR-Data.sql
├── Physical-Implementation.sql
├── create-linked-servers.sql
└── test-distributed.sql
```

**Khi nào dùng:**
- Docker mount folder này vào containers
- Scripts tự động copy vào đây

**Quan trọng:** ⭐⭐⭐⭐⭐ (Auto-created!)

---

### 5.2 `HUONG-DAN-BAO-VE/` ⭐⭐⭐⭐⭐
**Mục đích:** Folder này đang đọc!  
**Nội dung:** 12 files hướng dẫn bảo vệ

**Quan trọng:** ⭐⭐⭐⭐⭐ (Quan trọng nhất!)

---

## ⚙️ NHÓM 6: FILES CẤU HÌNH

### 6.1 `.git/` (hidden)
**Mục đích:** Git version control  
**Không cần động vào!**

---

## 📊 BẢNG TỔNG HỢP

### Theo mức độ quan trọng:

| Level | Files | Mục đích |
|-------|-------|----------|
| ⭐⭐⭐⭐⭐ | `HR.sql`, `HR-Data.sql`, `Physical-Implementation.sql` | Core SQL |
| ⭐⭐⭐⭐⭐ | `docker-complete-setup.sh`, `install-docker.sh` | Setup |
| ⭐⭐⭐⭐⭐ | `README.md`, `QUICKSTART.md`, `CHECKLIST.md` | Docs quan trọng |
| ⭐⭐⭐⭐⭐ | `TASK-COMPLETION-REPORT.md`, `SO-SANH-YEU-CAU.md` | Báo cáo |
| ⭐⭐⭐⭐⭐ | `HUONG-DAN-BAO-VE/*.md` | Hướng dẫn bảo vệ |
| ⭐⭐⭐⭐ | `Test-Physical-Implementation.sql` | Testing |
| ⭐⭐⭐⭐ | `docker-cleanup.sh`, `docker-backup.sh`, `docker-monitor.sh` | Utilities |
| ⭐⭐⭐⭐ | `ARCHITECTURE.md`, `DOCKER-SETUP.md` | Technical docs |
| ⭐⭐⭐ | Others | Optional/Reference |

---

## 🎯 FILES CẦN NHỚ (TOP 10)

### Cho setup:
1. `install-docker.sh` - Cài Docker
2. `docker-complete-setup.sh` - Setup tất cả
3. `HR.sql` - Tạo tables
4. `HR-Data.sql` - Thêm data
5. `Physical-Implementation.sql` - Business logic

### Cho documentation:
6. `README.md` - Tổng quan
7. `QUICKSTART.md` - Quick start
8. `TASK-COMPLETION-REPORT.md` - Status report

### Cho bảo vệ:
9. `SO-SANH-YEU-CAU.md` - So sánh requirements
10. `HUONG-DAN-BAO-VE/09-CHUAN-BI-BAO-VE.md` - Prep guide

---

## 💡 MẸO SỬ DỤNG

### Tìm file nhanh:
```bash
# List tất cả files
ls -lh

# Tìm file SQL
ls *.sql

# Tìm file .sh
ls *.sh

# Tìm file markdown
ls *.md
```

### Đọc file nhanh:
```bash
# Xem nội dung
cat README.md

# Xem 10 dòng đầu
head -10 HR.sql

# Tìm từ khóa
grep "NhanVien" HR.sql
```

---

## ✅ CHECKLIST: BẠN ĐÃ BIẾT CHƯA?

- [ ] Tôi biết folder có những file gì
- [ ] Tôi hiểu mục đích từng file
- [ ] Tôi biết file nào quan trọng nhất
- [ ] Tôi biết file nào dùng khi nào
- [ ] Tôi biết top 10 files cần nhớ

---

## 📖 BƯỚC TIẾP THEO

```
✅ Đã hiểu danh sách files
↓
👉 Đọc tiếp: 03-DATABASE-LA-GI.md
```

Trong file tiếp theo, bạn sẽ hiểu:
- Database QuanLyNhanSu chứa gì?
- 8 tables là gì?
- Dữ liệu được tổ chức thế nào?

---

**Chúc mừng! Bạn đã biết tất cả files trong project! 🎉**
