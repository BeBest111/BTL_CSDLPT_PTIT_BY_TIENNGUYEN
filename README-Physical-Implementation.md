# TÀI LIỆU KỸ THUẬT - CÀI ĐẶT VẬT LÝ
## HỆ THỐNG QUẢN LÝ NHÂN VIÊN PHÂN TÁN

---

## MỤC LỤC
1. [Giới thiệu](#1-giới-thiệu)
2. [Cấu trúc cơ sở dữ liệu](#2-cấu-trúc-cơ-sở-dữ-liệu)
3. [Phân mảnh dữ liệu](#3-phân-mảnh-dữ-liệu)
4. [Stored Procedures](#4-stored-procedures)
5. [Functions](#5-functions)
6. [Triggers](#6-triggers)
7. [Views](#7-views)
8. [Indexes](#8-indexes)
9. [Phân quyền](#9-phân-quyền)
10. [Hướng dẫn triển khai](#10-hướng-dẫn-triển-khai)

---

## 1. GIỚI THIỆU

### 1.1. Mục đích
Tài liệu này mô tả chi tiết việc cài đặt vật lý cơ sở dữ liệu phân tán cho hệ thống Quản lý Nhân viên.

### 1.2. Phạm vi
- Phân mảnh dữ liệu theo chi nhánh
- Tối ưu hóa truy vấn với Indexes
- Tự động hóa với Stored Procedures
- Bảo mật với phân quyền người dùng
- Giám sát với Triggers và Logs

### 1.3. Công nghệ sử dụng
- **DBMS:** Microsoft SQL Server 2019+
- **Ngôn ngữ:** T-SQL
- **Kiến trúc:** Phân tán (Distributed Database)

---

## 2. CẤU TRÚC CƠ SỞ DỮ LIỆU

### 2.1. Sơ đồ quan hệ

```
TruSoChinh (1) ----< (*) ChiNhanh (1) ----< (*) PhongBan
                                  |
                                  +-------< (*) ChinhSach
                                  |
                                  +-------< (*) NhanVien
                                  
DuAn (*) >---- (1) PhongBan
ChucVu (1) ----< (*) NhanVien (1) ----< (1) Luong
```

### 2.2. Các bảng chính

#### TruSoChinh
- **Mô tả:** Thông tin trụ sở chính
- **Khóa chính:** ID_TruSoChinh
- **Thuộc tính:** TenTruSoChinh, DiaChi, Email, SoDienThoai

#### ChiNhanh
- **Mô tả:** Thông tin các chi nhánh
- **Khóa chính:** ID_ChiNhanh
- **Khóa ngoại:** ID_TruSoChinh → TruSoChinh
- **Thuộc tính:** TenChiNhanh, DiaChi, Email, SoDienThoai

#### PhongBan
- **Mô tả:** Các phòng ban trong chi nhánh
- **Khóa chính:** ID_PhongBan
- **Khóa ngoại:** ID_ChiNhanh → ChiNhanh
- **Thuộc tính:** TenPhongBan, Email, SoDienThoai

#### NhanVien
- **Mô tả:** Thông tin nhân viên
- **Khóa chính:** ID_NhanVien
- **Khóa ngoại:** 
  - ID_DuAn → DuAn
  - ID_ChucVu → ChucVu
  - ID_ChiNhanh → ChiNhanh
  - ID_PhongBan → PhongBan
- **Thuộc tính:** HoTen, NgaySinh, GioiTinh, DanToc, CCCD, SoDienThoai, Email, DiaChi

#### Luong
- **Mô tả:** Thông tin lương nhân viên
- **Khóa chính:** ID_Luong
- **Khóa ngoại:** ID_NhanVien → NhanVien
- **Thuộc tính:** MucLuong

---

## 3. PHÂN MẢNH DỮ LIỆU

### 3.1. Phân mảnh Horizontal (Theo hàng)

#### 3.1.1. Phân mảnh NhanVien theo Chi nhánh
**Lý do:** Tăng hiệu suất truy vấn cho từng chi nhánh

**Các View đã tạo:**
- `View_NhanVien_CN01` - Nhân viên Hue
- `View_NhanVien_CN02` - Nhân viên Nam Định
- `View_NhanVien_CN03` - Nhân viên Vinh
- `View_NhanVien_CN04` - Nhân viên Nha Trang
- `View_NhanVien_CN05` - Nhân viên Thái Bình

**Ví dụ sử dụng:**
```sql
-- Lấy tất cả nhân viên chi nhánh Nha Trang
SELECT * FROM View_NhanVien_CN04;
```

#### 3.1.2. Phân mảnh Luong theo Mức lương
**Lý do:** Phân loại nhân viên theo cấp bậc lương

**Các View đã tạo:**
- `View_Luong_CaoCap` - Lương >= 50 triệu
- `View_Luong_TrungCap` - Lương 30-50 triệu
- `View_Luong_CoBan` - Lương < 30 triệu

**Ví dụ sử dụng:**
```sql
-- Lấy danh sách nhân viên lương cao cấp
SELECT * FROM View_Luong_CaoCap;
```

### 3.2. Lợi ích phân mảnh
- ✅ Tăng tốc độ truy vấn
- ✅ Giảm tải cho server
- ✅ Dễ dàng quản lý theo vùng địa lý
- ✅ Tăng tính khả dụng

---

## 4. STORED PROCEDURES

### 4.1. sp_ThemNhanVien
**Chức năng:** Thêm nhân viên mới vào hệ thống

**Tham số:**
```sql
@ID_NhanVien VARCHAR(255)
@ID_DuAn VARCHAR(255)
@ID_ChucVu VARCHAR(255)
@ID_ChiNhanh VARCHAR(255)
@ID_PhongBan VARCHAR(255)
@HoTen VARCHAR(255)
@NgaySinh DATE
@GioiTinh VARCHAR(255)
@DanToc VARCHAR(255)
@CCCD VARCHAR(255)
@SoDienThoai VARCHAR(255)
@Email VARCHAR(255)
@DiaChi VARCHAR(255)
```

**Ví dụ:**
```sql
EXEC sp_ThemNhanVien 
    @ID_NhanVien = 'NTNV50',
    @ID_DuAn = 'NTDA01',
    @ID_ChucVu = 'NTCV07',
    @ID_ChiNhanh = 'CN04',
    @ID_PhongBan = 'NTPB01',
    @HoTen = 'Nguyen Van A',
    @NgaySinh = '1995-05-15',
    @GioiTinh = 'Nam',
    @DanToc = 'Kinh',
    @CCCD = '001234567899',
    @SoDienThoai = '0987654321',
    @Email = 'nva@gmail.com',
    @DiaChi = 'Nha Trang';
```

**Kiểm tra:**
- ID nhân viên đã tồn tại chưa
- CCCD đã được sử dụng chưa
- Sử dụng Transaction để đảm bảo tính toàn vẹn

### 4.2. sp_CapNhatNhanVien
**Chức năng:** Cập nhật thông tin nhân viên

**Tham số:**
```sql
@ID_NhanVien VARCHAR(255)
@SoDienThoai VARCHAR(255) = NULL
@Email VARCHAR(255) = NULL
@DiaChi VARCHAR(255) = NULL
```

**Ví dụ:**
```sql
EXEC sp_CapNhatNhanVien
    @ID_NhanVien = 'NTNV50',
    @SoDienThoai = '0999888777',
    @Email = 'newemail@gmail.com';
```

### 4.3. sp_XoaNhanVien
**Chức năng:** Xóa nhân viên khỏi hệ thống

**Tham số:**
```sql
@ID_NhanVien VARCHAR(255)
```

**Ví dụ:**
```sql
EXEC sp_XoaNhanVien @ID_NhanVien = 'NTNV50';
```

**Lưu ý:** Sẽ tự động xóa thông tin lương trước khi xóa nhân viên

### 4.4. sp_ThemLuong
**Chức năng:** Thêm thông tin lương cho nhân viên

**Tham số:**
```sql
@ID_Luong VARCHAR(255)
@ID_NhanVien VARCHAR(255)
@MucLuong INT
```

**Ví dụ:**
```sql
EXEC sp_ThemLuong
    @ID_Luong = 'NTL50',
    @ID_NhanVien = 'NTNV50',
    @MucLuong = 35000000;
```

### 4.5. sp_CapNhatLuong
**Chức năng:** Cập nhật mức lương nhân viên

**Tham số:**
```sql
@ID_NhanVien VARCHAR(255)
@MucLuong INT
```

**Ví dụ:**
```sql
EXEC sp_CapNhatLuong
    @ID_NhanVien = 'NTNV50',
    @MucLuong = 40000000;
```

### 4.6. sp_ChuyenPhongBan
**Chức năng:** Chuyển nhân viên sang phòng ban khác

**Tham số:**
```sql
@ID_NhanVien VARCHAR(255)
@ID_PhongBan_Moi VARCHAR(255)
```

**Ví dụ:**
```sql
EXEC sp_ChuyenPhongBan
    @ID_NhanVien = 'NTNV50',
    @ID_PhongBan_Moi = 'NTPB02';
```

---

## 5. FUNCTIONS

### 5.1. fn_TongNhanVienTheoChiNhanh
**Chức năng:** Đếm tổng số nhân viên theo chi nhánh

**Tham số:** `@ID_ChiNhanh VARCHAR(255)`

**Trả về:** `INT`

**Ví dụ:**
```sql
SELECT dbo.fn_TongNhanVienTheoChiNhanh('CN04') AS TongNhanVien;
```

### 5.2. fn_TongNhanVienTheoPhongBan
**Chức năng:** Đếm tổng số nhân viên theo phòng ban

**Tham số:** `@ID_PhongBan VARCHAR(255)`

**Trả về:** `INT`

**Ví dụ:**
```sql
SELECT dbo.fn_TongNhanVienTheoPhongBan('NTPB01') AS TongNhanVien;
```

### 5.3. fn_LayTenChucVu
**Chức năng:** Lấy tên chức vụ theo ID

**Tham số:** `@ID_ChucVu VARCHAR(255)`

**Trả về:** `VARCHAR(255)`

**Ví dụ:**
```sql
SELECT dbo.fn_LayTenChucVu('NTCV01') AS TenChucVu;
```

### 5.4. fn_TinhTuoi
**Chức năng:** Tính tuổi dựa trên ngày sinh

**Tham số:** `@NgaySinh DATE`

**Trả về:** `INT`

**Ví dụ:**
```sql
SELECT 
    HoTen,
    NgaySinh,
    dbo.fn_TinhTuoi(NgaySinh) AS Tuoi
FROM NhanVien;
```

### 5.5. fn_TongLuongTheoPhongBan
**Chức năng:** Tính tổng quỹ lương theo phòng ban

**Tham số:** `@ID_PhongBan VARCHAR(255)`

**Trả về:** `INT`

**Ví dụ:**
```sql
SELECT dbo.fn_TongLuongTheoPhongBan('NTPB01') AS TongLuong;
```

### 5.6. fn_LuongTrungBinhTheoChiNhanh
**Chức năng:** Tính lương trung bình theo chi nhánh

**Tham số:** `@ID_ChiNhanh VARCHAR(255)`

**Trả về:** `INT`

**Ví dụ:**
```sql
SELECT dbo.fn_LuongTrungBinhTheoChiNhanh('CN04') AS LuongTrungBinh;
```

---

## 6. TRIGGERS

### 6.1. trg_KiemTraTuoiNhanVien
**Loại:** FOR INSERT, UPDATE on NhanVien

**Chức năng:** Kiểm tra nhân viên phải đủ 18 tuổi trở lên

**Ví dụ kích hoạt:**
```sql
-- Sẽ bị chặn
INSERT INTO NhanVien (..., NgaySinh, ...)
VALUES (..., '2010-01-01', ...);  -- Dưới 18 tuổi
```

### 6.2. trg_LogXoaNhanVien
**Loại:** FOR DELETE on NhanVien

**Chức năng:** Ghi log khi xóa nhân viên

**Bảng log:** `LogXoaNhanVien`

**Cấu trúc log:**
- ID_Log
- ID_NhanVien
- HoTen
- NgayXoa
- NguoiXoa

**Xem log:**
```sql
SELECT * FROM LogXoaNhanVien ORDER BY NgayXoa DESC;
```

### 6.3. trg_KiemTraMucLuong
**Loại:** FOR INSERT, UPDATE on Luong

**Chức năng:** Kiểm tra mức lương phải >= 0

**Ví dụ kích hoạt:**
```sql
-- Sẽ bị chặn
UPDATE Luong SET MucLuong = -1000000 WHERE ID_Luong = 'NTL01';
```

### 6.4. trg_LogCapNhatLuong
**Loại:** FOR UPDATE on Luong

**Chức năng:** Ghi log khi cập nhật lương

**Bảng log:** `LogCapNhatLuong`

**Cấu trúc log:**
- ID_Log
- ID_NhanVien
- MucLuongCu
- MucLuongMoi
- NgayCapNhat
- NguoiCapNhat

**Xem log:**
```sql
SELECT * FROM LogCapNhatLuong ORDER BY NgayCapNhat DESC;
```

---

## 7. VIEWS

### 7.1. View_ThongTinNhanVienChiTiet
**Mô tả:** Hiển thị thông tin đầy đủ của nhân viên

**Các cột:**
- ID_NhanVien, HoTen, NgaySinh, Tuoi
- GioiTinh, DanToc, CCCD
- SoDienThoai, Email, DiaChi
- TenChucVu, BacLuong
- TenPhongBan, TenChiNhanh
- TenDuAn, MucLuong

**Ví dụ:**
```sql
SELECT * FROM View_ThongTinNhanVienChiTiet
WHERE TenChiNhanh = 'ORGASM Nha Trang';
```

### 7.2. View_ThongKeTheoPhongBan
**Mô tả:** Thống kê nhân viên theo phòng ban

**Các cột:**
- ID_PhongBan, TenPhongBan, TenChiNhanh
- SoLuongNhanVien
- LuongTrungBinh, TongLuong
- LuongCaoNhat, LuongThapNhat

**Ví dụ:**
```sql
SELECT * FROM View_ThongKeTheoPhongBan
ORDER BY TongLuong DESC;
```

### 7.3. View_ThongKeTheoChiNhanh
**Mô tả:** Thống kê nhân viên theo chi nhánh

**Các cột:**
- ID_ChiNhanh, TenChiNhanh, DiaChi
- SoLuongNhanVien
- LuongTrungBinh, TongLuong

**Ví dụ:**
```sql
SELECT * FROM View_ThongKeTheoChiNhanh
ORDER BY SoLuongNhanVien DESC;
```

### 7.4. View_ThongKeTheoChucVu
**Mô tả:** Thống kê nhân viên theo chức vụ

**Các cột:**
- ID_ChucVu, TenChucVu, BacLuong
- SoLuongNhanVien
- LuongTrungBinh

**Ví dụ:**
```sql
SELECT * FROM View_ThongKeTheoChucVu
ORDER BY BacLuong;
```

### 7.5. View_DuAnVaNhanVien
**Mô tả:** Thống kê dự án và nhân viên tham gia

**Các cột:**
- ID_DuAn, TenDuAn
- NgayBatDau, ThoiHan, MoTa
- TenPhongBan
- SoLuongNhanVien
- DanhSachNhanVien

**Ví dụ:**
```sql
SELECT * FROM View_DuAnVaNhanVien
WHERE SoLuongNhanVien > 0;
```

### 7.6. View_NhanVienLuongCaoNhatTheoPhongBan
**Mô tả:** Nhân viên có lương cao nhất mỗi phòng ban

**Các cột:**
- ID_PhongBan, TenPhongBan
- ID_NhanVien, HoTen
- TenChucVu, MucLuong

**Ví dụ:**
```sql
SELECT * FROM View_NhanVienLuongCaoNhatTheoPhongBan;
```

---

## 8. INDEXES

### 8.1. Indexes trên bảng NhanVien
```sql
IX_NhanVien_ChiNhanh    -- Tìm kiếm theo chi nhánh
IX_NhanVien_PhongBan    -- Tìm kiếm theo phòng ban
IX_NhanVien_ChucVu      -- Tìm kiếm theo chức vụ
IX_NhanVien_DuAn        -- Tìm kiếm theo dự án
IX_NhanVien_CCCD        -- Tìm kiếm theo CCCD
IX_NhanVien_Email       -- Tìm kiếm theo Email
```

### 8.2. Indexes trên bảng Luong
```sql
IX_Luong_NhanVien       -- Join với NhanVien
IX_Luong_MucLuong       -- Tìm kiếm theo mức lương
```

### 8.3. Indexes trên các bảng khác
```sql
IX_PhongBan_ChiNhanh    -- Join PhongBan-ChiNhanh
IX_DuAn_PhongBan        -- Join DuAn-PhongBan
IX_DuAn_NgayBatDau      -- Sắp xếp theo ngày bắt đầu
IX_ChinhSach_ChiNhanh   -- Join ChinhSach-ChiNhanh
```

### 8.4. Lợi ích của Indexes
- ⚡ Tăng tốc độ truy vấn 10-100 lần
- ⚡ Tối ưu JOIN giữa các bảng
- ⚡ Tăng hiệu suất WHERE, ORDER BY

---

## 9. PHÂN QUYỀN

### 9.1. Role_Admin
**Quyền:** Toàn quyền trên cơ sở dữ liệu

**Tạo user và gán quyền:**
```sql
CREATE USER Admin_User FOR LOGIN Admin_Login;
ALTER ROLE Role_Admin ADD MEMBER Admin_User;
```

### 9.2. Role_QuanLyChiNhanh
**Quyền:**
- SELECT, INSERT, UPDATE trên NhanVien, Luong
- SELECT trên ChiNhanh, PhongBan, ChucVu, DuAn
- EXECUTE các stored procedures quản lý nhân viên

**Tạo user và gán quyền:**
```sql
CREATE USER QuanLyCN_User FOR LOGIN QuanLyCN_Login;
ALTER ROLE Role_QuanLyChiNhanh ADD MEMBER QuanLyCN_User;
```

### 9.3. Role_QuanLyPhongBan
**Quyền:**
- SELECT, UPDATE trên NhanVien
- SELECT trên Luong, PhongBan, ChucVu, DuAn
- EXECUTE sp_CapNhatNhanVien

**Tạo user và gán quyền:**
```sql
CREATE USER QuanLyPB_User FOR LOGIN QuanLyPB_Login;
ALTER ROLE Role_QuanLyPhongBan ADD MEMBER QuanLyPB_User;
```

### 9.4. Role_NhanVien
**Quyền:**
- SELECT trên các View
- Chỉ xem thông tin, không sửa đổi

**Tạo user và gán quyền:**
```sql
CREATE USER NhanVien_User FOR LOGIN NhanVien_Login;
ALTER ROLE Role_NhanVien ADD MEMBER NhanVien_User;
```

### 9.5. Role_KeToan
**Quyền:**
- SELECT, INSERT, UPDATE trên Luong
- SELECT trên NhanVien, ChucVu
- EXECUTE các stored procedures về lương

**Tạo user và gán quyền:**
```sql
CREATE USER KeToan_User FOR LOGIN KeToan_Login;
ALTER ROLE Role_KeToan ADD MEMBER KeToan_User;
```

---

## 10. HƯỚNG DẪN TRIỂN KHAI

### 10.1. Yêu cầu hệ thống
- SQL Server 2019 hoặc mới hơn
- Tối thiểu 4GB RAM
- 10GB dung lượng ổ cứng

### 10.2. Các bước triển khai

#### Bước 1: Tạo cơ sở dữ liệu
```sql
-- Chạy file HR.sql
-- Tạo database và các bảng cơ bản
```

#### Bước 2: Import dữ liệu mẫu
```sql
-- Chạy file HR-Data.sql
-- Thêm dữ liệu mẫu vào các bảng
```

#### Bước 3: Cài đặt vật lý
```sql
-- Chạy file Physical-Implementation.sql
-- Tạo Views, Procedures, Functions, Triggers, Indexes, Roles
```

#### Bước 4: Kiểm tra
```sql
-- Chạy file Test-Physical-Implementation.sql
-- Test tất cả chức năng đã cài đặt
```

### 10.3. Kiểm tra sau triển khai

#### Kiểm tra Views
```sql
SELECT COUNT(*) FROM sys.views 
WHERE name LIKE 'View_%';
-- Kết quả mong đợi: >= 11 views
```

#### Kiểm tra Stored Procedures
```sql
SELECT COUNT(*) FROM sys.procedures 
WHERE name LIKE 'sp_%';
-- Kết quả mong đợi: >= 6 procedures
```

#### Kiểm tra Functions
```sql
SELECT COUNT(*) FROM sys.objects 
WHERE type IN ('FN', 'IF', 'TF') AND name LIKE 'fn_%';
-- Kết quả mong đợi: >= 6 functions
```

#### Kiểm tra Triggers
```sql
SELECT COUNT(*) FROM sys.triggers 
WHERE name LIKE 'trg_%';
-- Kết quả mong đợi: >= 4 triggers
```

#### Kiểm tra Indexes
```sql
SELECT COUNT(*) FROM sys.indexes 
WHERE name LIKE 'IX_%';
-- Kết quả mong đợi: >= 12 indexes
```

### 10.4. Backup và Restore

#### Backup Full
```sql
BACKUP DATABASE QuanLyNhanSu
TO DISK = 'D:\Backup\QuanLyNhanSu_Full.bak'
WITH FORMAT, 
     NAME = 'Full Backup of QuanLyNhanSu',
     COMPRESSION;
```

#### Restore
```sql
RESTORE DATABASE QuanLyNhanSu
FROM DISK = 'D:\Backup\QuanLyNhanSu_Full.bak'
WITH REPLACE;
```

### 10.5. Maintenance

#### Rebuild Indexes (Hàng tuần)
```sql
ALTER INDEX ALL ON NhanVien REBUILD;
ALTER INDEX ALL ON Luong REBUILD;
```

#### Update Statistics (Hàng ngày)
```sql
UPDATE STATISTICS NhanVien;
UPDATE STATISTICS Luong;
```

#### Xóa Log cũ (Hàng tháng)
```sql
-- Xóa log cũ hơn 3 tháng
DELETE FROM LogXoaNhanVien 
WHERE NgayXoa < DATEADD(MONTH, -3, GETDATE());

DELETE FROM LogCapNhatLuong 
WHERE NgayCapNhat < DATEADD(MONTH, -3, GETDATE());
```

---

## PHỤ LỤC

### A. Các truy vấn thường dùng

#### Tìm nhân viên theo tên
```sql
SELECT * FROM View_ThongTinNhanVienChiTiet
WHERE HoTen LIKE N'%Nguyen%';
```

#### Top 10 nhân viên lương cao nhất
```sql
SELECT TOP 10 * FROM View_ThongTinNhanVienChiTiet
ORDER BY MucLuong DESC;
```

#### Thống kê theo độ tuổi
```sql
SELECT 
    CASE 
        WHEN Tuoi < 30 THEN 'Duoi 30'
        WHEN Tuoi BETWEEN 30 AND 40 THEN '30-40'
        ELSE 'Tren 40'
    END AS NhomTuoi,
    COUNT(*) AS SoLuong
FROM View_ThongTinNhanVienChiTiet
GROUP BY 
    CASE 
        WHEN Tuoi < 30 THEN 'Duoi 30'
        WHEN Tuoi BETWEEN 30 AND 40 THEN '30-40'
        ELSE 'Tren 40'
    END;
```

### B. Xử lý sự cố thường gặp

#### Lỗi: Trigger chặn INSERT/UPDATE
**Nguyên nhân:** Dữ liệu không hợp lệ (tuổi < 18, lương < 0)
**Giải pháp:** Kiểm tra và sửa dữ liệu đầu vào

#### Lỗi: Truy vấn chậm
**Nguyên nhân:** Thiếu index hoặc index bị fragmented
**Giải pháp:** Rebuild indexes

#### Lỗi: Không thể xóa nhân viên
**Nguyên nhân:** Vi phạm ràng buộc khóa ngoại
**Giải pháp:** Sử dụng sp_XoaNhanVien để xóa tự động

---

## LIÊN HỆ HỖ TRỢ

**Nhóm phát triển:** Nhóm 5 - Quản lý Nhân viên
**Email:** support@orgasm.com
**Hotline:** 0350899999

---

*Tài liệu này được tạo ngày 31/10/2025*
*Phiên bản: 1.0*
