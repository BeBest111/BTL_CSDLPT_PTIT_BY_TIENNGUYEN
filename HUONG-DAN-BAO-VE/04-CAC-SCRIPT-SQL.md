# 📜 CÁC SCRIPT SQL TRONG PROJECT
## Hiểu từng file SQL làm gì

---

## 🎯 TỔNG QUAN

Project có **5 SQL scripts chính:**

1. **HR.sql** - Tạo database và tables
2. **HR-Data.sql** - Insert sample data
3. **Physical-Implementation.sql** - Views, SPs, Functions, Triggers
4. **Test-Physical-Implementation.sql** - Test cases
5. **Deploy-Full.sql** - Combined deployment

---

## 📄 1. HR.sql (2.1 KB)

### Mục đích:
Tạo database và 8 tables chính.

### Cấu trúc:
```sql
-- Bước 1: Tạo database
CREATE DATABASE QuanLyNhanSu;
GO

USE QuanLyNhanSu;
GO

-- Bước 2: Tạo 8 tables
CREATE TABLE TruSoChinh (...);
CREATE TABLE ChiNhanh (...);
CREATE TABLE PhongBan (...);
CREATE TABLE ChucVu (...);
CREATE TABLE NhanVien (...);
CREATE TABLE DuAn (...);
CREATE TABLE Luong (...);
CREATE TABLE ChinhSach (...);

-- Bước 3: Tạo 2 audit log tables
CREATE TABLE AuditLog_XoaNhanVien (...);
CREATE TABLE AuditLog_Luong (...);
```

### Điểm quan trọng:
- `GO` statements phân cách batches
- Primary Keys defined
- Foreign Keys tạo relationships
- `NVARCHAR` cho tiếng Việt
- `DECIMAL(18,2)` cho money

### Ví dụ 1 table:
```sql
CREATE TABLE NhanVien (
    ID_NhanVien VARCHAR(10) PRIMARY KEY,
    HoTen NVARCHAR(100) NOT NULL,
    NgaySinh DATE,
    GioiTinh NVARCHAR(10),
    SoDienThoai VARCHAR(20),
    Email VARCHAR(100),
    DiaChi NVARCHAR(255),
    NgayVaoLam DATE,
    ID_ChucVu VARCHAR(10) FOREIGN KEY REFERENCES ChucVu(ID_ChucVu),
    ID_PhongBan VARCHAR(10) FOREIGN KEY REFERENCES PhongBan(ID_PhongBan),
    ID_ChiNhanh VARCHAR(10) FOREIGN KEY REFERENCES ChiNhanh(ID_ChiNhanh)
);
```

---

## 📄 2. HR-Data.sql (13 KB)

### Mục đích:
Insert 131 sample records.

### Cấu trúc:
```sql
USE QuanLyNhanSu;
GO

-- Insert 1 trụ sở chính
INSERT INTO TruSoChinh VALUES (...);

-- Insert 10 chi nhánh
INSERT INTO ChiNhanh VALUES ('CN01', ...);
INSERT INTO ChiNhanh VALUES ('CN02', ...);
-- ... 8 more

-- Insert 10 phòng ban
INSERT INTO PhongBan VALUES ('PB01', ...);
-- ... 9 more

-- Insert 20 chức vụ
INSERT INTO ChucVu VALUES ('CV01', 'Giám đốc', ...);
-- ... 19 more

-- Insert 40 nhân viên
INSERT INTO NhanVien VALUES ('NV001', N'Nguyễn Văn An', ...);
-- ... 39 more

-- Insert 15 dự án
INSERT INTO DuAn VALUES ('DA001', N'Hệ thống quản lý...', ...);
-- ... 14 more

-- Insert 30 bản ghi lương
INSERT INTO Luong VALUES ('L001', 'NV001', 12, 2024, ...);
-- ... 29 more

-- Insert 6 chính sách
INSERT INTO ChinhSach VALUES ('CS001', ...);
-- ... 5 more
```

### Data highlights:
- **Chi nhánh**: CN01 (Hà Nội), CN02 (Đà Nẵng), CN03 (Sài Gòn)...
- **Phòng ban**: Kỹ Thuật, Kinh Doanh, Nhân Sự...
- **Chức vụ**: Giám đốc (50M), Trưởng phòng (30M), Nhân viên (15M)
- **Nhân viên**: 40 người với thông tin đầy đủ

---

## 📄 3. Physical-Implementation.sql (20 KB)

### Mục đích:
Implement business logic.

### Cấu trúc:
```sql
USE QuanLyNhanSu;
GO

-- PHẦN 1: 14 VIEWS (8 phân mảnh + 6 báo cáo)

-- 1.1. Views phân mảnh ngang theo chi nhánh
CREATE VIEW View_NhanVien_CN01 AS
SELECT * FROM NhanVien WHERE ID_ChiNhanh = 'CN01';
GO
-- ... 4 more (CN02, CN03, CN04, CN05)

-- 1.2. Views phân mảnh theo mức lương
CREATE VIEW View_NhanVien_MucLuongCao AS
SELECT * FROM NhanVien WHERE ID_ChucVu IN (
    SELECT ID_ChucVu FROM ChucVu WHERE MucLuongCoBan >= 30000000
);
GO
-- ... 2 more (Trung bình, Cơ bản)

-- 1.3. Views báo cáo
CREATE VIEW View_ThongKeNhanVienTheoPhongBan AS
SELECT 
    pb.TenPhongBan,
    COUNT(nv.ID_NhanVien) AS SoNhanVien,
    SUM(l.TongLuong) AS TongLuong,
    AVG(l.TongLuong) AS LuongTrungBinh
FROM PhongBan pb
LEFT JOIN NhanVien nv ON pb.ID_PhongBan = nv.ID_PhongBan
LEFT JOIN Luong l ON nv.ID_NhanVien = l.ID_NhanVien
GROUP BY pb.TenPhongBan;
GO
-- ... 5 more reporting views

-- PHẦN 2: 6 STORED PROCEDURES

CREATE PROCEDURE sp_ThemNhanVien
    @ID_NhanVien VARCHAR(10),
    @HoTen NVARCHAR(100),
    -- ... more params
AS
BEGIN
    BEGIN TRY
        -- Validation
        IF EXISTS (SELECT 1 FROM NhanVien WHERE ID_NhanVien = @ID_NhanVien)
            THROW 50001, N'ID nhân viên đã tồn tại', 1;
        
        -- Insert
        INSERT INTO NhanVien VALUES (@ID_NhanVien, @HoTen, ...);
        
        PRINT N'Thêm nhân viên thành công';
    END TRY
    BEGIN CATCH
        PRINT ERROR_MESSAGE();
        THROW;
    END CATCH
END
GO
-- ... 5 more (Sửa, Xóa, Tính lương, Tìm kiếm, Báo cáo)

-- PHẦN 3: 6 FUNCTIONS

CREATE FUNCTION fn_TinhTuoi(@NgaySinh DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(YEAR, @NgaySinh, GETDATE());
END
GO
-- ... 5 more functions

-- PHẦN 4: 4 TRIGGERS

CREATE TRIGGER trg_KiemTraTuoiNhanVien
ON NhanVien
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE DATEDIFF(YEAR, NgaySinh, GETDATE()) < 18)
    BEGIN
        THROW 50002, N'Nhân viên phải đủ 18 tuổi', 1;
        ROLLBACK TRANSACTION;
    END
    ELSE
    BEGIN
        INSERT INTO NhanVien SELECT * FROM inserted;
    END
END
GO
-- ... 3 more triggers

-- PHẦN 5: 12+ INDEXES

CREATE NONCLUSTERED INDEX IX_NhanVien_ChiNhanh 
ON NhanVien(ID_ChiNhanh);
GO
-- ... 11+ more indexes
```

### Sections:
1. **Views (14)**: Phân mảnh + báo cáo
2. **Procedures (6)**: CRUD + business logic
3. **Functions (6)**: Calculations
4. **Triggers (4)**: Validation + audit
5. **Indexes (12+)**: Performance

---

## 📄 4. Test-Physical-Implementation.sql (12 KB)

### Mục đích:
Test tất cả features.

### Cấu trúc:
```sql
USE QuanLyNhanSu;
GO

-- TEST GROUP 1: VIEWS (14 tests)
PRINT '=== TESTING VIEWS ===';

-- Test 1: View phân mảnh chi nhánh
SELECT * FROM View_NhanVien_CN01;
-- Expected: Chỉ nhân viên CN01

-- Test 2: View mức lương cao
SELECT * FROM View_NhanVien_MucLuongCao;
-- Expected: Nhân viên lương >= 30M

-- ... 12 more view tests

-- TEST GROUP 2: STORED PROCEDURES (6 tests)
PRINT '=== TESTING PROCEDURES ===';

-- Test 10: Thêm nhân viên hợp lệ
EXEC sp_ThemNhanVien 
    @ID_NhanVien = 'NV999',
    @HoTen = N'Test User',
    -- ... params
-- Expected: Success

-- Test 11: Thêm nhân viên trùng ID (should fail)
EXEC sp_ThemNhanVien @ID_NhanVien = 'NV001', ...
-- Expected: Error 50001

-- ... 4 more procedure tests

-- TEST GROUP 3: FUNCTIONS (6 tests)
PRINT '=== TESTING FUNCTIONS ===';

-- Test 20: Tính tuổi
SELECT dbo.fn_TinhTuoi('1990-05-15');
-- Expected: 34 (năm 2024)

-- ... 5 more function tests

-- TEST GROUP 4: TRIGGERS (4 tests)
PRINT '=== TESTING TRIGGERS ===';

-- Test 30: Trigger tuổi < 18 (should fail)
INSERT INTO NhanVien VALUES ('NV998', N'Em Bé', '2010-01-01', ...);
-- Expected: Error 50002

-- Test 31: Trigger lương <= 0 (should fail)
INSERT INTO Luong VALUES ('L999', 'NV001', 12, 2024, 0, 0, 0, 0, 0);
-- Expected: Error

-- ... 2 more trigger tests

-- TEST GROUP 5: INDEXES (performance tests)
-- Test 40: Query với index vs không index
SET STATISTICS TIME ON;
SELECT * FROM NhanVien WHERE ID_ChiNhanh = 'CN01';
-- Check execution time

-- TEST GROUP 6: LINKED SERVERS (distributed tests)
-- Test 45: Query từ HANOI sang DANANG
SELECT * FROM SITE_DANANG.QuanLyNhanSu.dbo.ChiNhanh;
-- Expected: 10 chi nhánh

-- ... more tests
```

### Test results expected:
- ✅ 38/40 passed
- ❌ 2 known failures (by design)

---

## 📄 5. Deploy-Full.sql (12 KB)

### Mục đích:
Combined script để deploy tất cả.

### Cấu trúc:
```sql
-- Bước 1: Drop database cũ (nếu có)
IF EXISTS (SELECT 1 FROM sys.databases WHERE name = 'QuanLyNhanSu')
    DROP DATABASE QuanLyNhanSu;
GO

-- Bước 2: Chạy HR.sql
-- (Include full content of HR.sql)

-- Bước 3: Chạy HR-Data.sql
-- (Include full content of HR-Data.sql)

-- Bước 4: Chạy Physical-Implementation.sql
-- (Include full content of Physical-Implementation.sql)

PRINT '=== DEPLOYMENT COMPLETED ===';
```

### Usage:
```bash
# Deploy vào 1 site
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -i /scripts/Deploy-Full.sql

# Deploy vào tất cả 3 sites
./docker-complete-setup.sh
```

---

## 🔍 PHÂN TÍCH CHI TIẾT

### HR.sql - Line by line:
```sql
-- Line 1-3: Create database
CREATE DATABASE QuanLyNhanSu;
GO
-- GO: Batch separator, execute trước khi tiếp tục

-- Line 5-6: Switch context
USE QuanLyNhanSu;
GO
-- Tất cả lệnh sau đây chạy trong QuanLyNhanSu

-- Line 8-17: TruSoChinh table
CREATE TABLE TruSoChinh (
    ID_TruSo VARCHAR(10) PRIMARY KEY,  -- PK, unique
    TenCongTy NVARCHAR(200) NOT NULL,  -- Required
    DiaChi NVARCHAR(255),              -- Optional
    DienThoai VARCHAR(20),
    Email VARCHAR(100),
    Website VARCHAR(100)
);
GO

-- Line 19-28: ChiNhanh table
CREATE TABLE ChiNhanh (
    ID_ChiNhanh VARCHAR(10) PRIMARY KEY,
    TenChiNhanh NVARCHAR(100) NOT NULL,
    DiaChi NVARCHAR(255),
    DienThoai VARCHAR(20),
    Email VARCHAR(100),
    ID_TruSo VARCHAR(10) FOREIGN KEY REFERENCES TruSoChinh(ID_TruSo)
    -- FK: Must exist in TruSoChinh
);
GO

-- ... continues for 8 tables
```

---

## 💡 TIPS KHI ĐỌC CODE SQL

### 1. Đọc từ trên xuống:
- CREATE DATABASE trước
- CREATE TABLE theo thứ tự dependencies
- INSERT data sau khi có tables

### 2. Chú ý GO statements:
- Phân cách batches
- Execute riêng biệt
- Quan trọng cho CREATE VIEW/PROCEDURE

### 3. Foreign Keys:
- Hiểu relationships
- Parent table phải tồn tại trước
- CASCADE options

### 4. Data types:
- VARCHAR vs NVARCHAR (Unicode)
- DECIMAL(18,2) cho money
- DATE vs DATETIME

### 5. Error handling:
- TRY...CATCH blocks
- THROW vs RAISERROR
- Transaction management

---

## 📖 FILES LIÊN QUAN

- `03-DATABASE-LA-GI.md` - Hiểu database structure
- `06-HUONG-DAN-CAI-DAT.md` - Chạy scripts
- `08-CAC-LENH-THUONG-DUNG.md` - Query examples

---

**Đã hiểu rõ các SQL scripts! Sang phần Docker! 🚀**
