# HƯỚNG DẪN SỬ DỤNG HỆ THỐNG
## Quản Lý Nhân Viên Phân Tán - Nhóm 5

---

## 📁 CẤU TRÚC THỨ MỤC

```
BTL-CSDLPT-PTIT/
│
├── HR.sql                              # Script tạo cấu trúc database
├── HR-Data.sql                         # Script import dữ liệu mẫu
├── Physical-Implementation.sql         # Script cài đặt vật lý
├── Test-Physical-Implementation.sql    # Script test hệ thống
├── Deploy-Full.sql                     # Script deployment tự động
├── README-Physical-Implementation.md   # Tài liệu kỹ thuật chi tiết
└── HUONG-DAN-SU-DUNG.md               # File này
```

---

## 🚀 HƯỚNG DẪN TRIỂN KHAI NHANH

### Phương án 1: Triển khai từng bước (Khuyến nghị)

#### Bước 1️⃣: Tạo cơ sở dữ liệu
```sql
-- Mở SQL Server Management Studio (SSMS)
-- File > Open > File > Chọn HR.sql
-- Nhấn Execute (F5)
```

**Kết quả:** Database `QuanLyNhanSu` và các bảng được tạo

#### Bước 2️⃣: Import dữ liệu mẫu
```sql
-- File > Open > File > Chọn HR-Data.sql
-- Nhấn Execute (F5)
```

**Kết quả:** Dữ liệu mẫu 40 nhân viên, 10 phòng ban, 10 dự án được thêm vào

#### Bước 3️⃣: Cài đặt vật lý
```sql
-- File > Open > File > Chọn Physical-Implementation.sql
-- Nhấn Execute (F5)
```

**Kết quả:** 
- ✅ 11+ Views
- ✅ 6 Stored Procedures
- ✅ 6 Functions
- ✅ 4 Triggers
- ✅ 12+ Indexes
- ✅ 5 Roles (phân quyền)

#### Bước 4️⃣: Kiểm tra hệ thống
```sql
-- File > Open > File > Chọn Test-Physical-Implementation.sql
-- Nhấn Execute (F5)
```

**Kết quả:** Tất cả chức năng được test và hiển thị kết quả

---

### Phương án 2: Triển khai tự động

```sql
-- File > Open > File > Chọn Deploy-Full.sql
-- Nhấn Execute (F5)
```

**Lưu ý:** Phương án này chỉ tạo cấu trúc, bạn vẫn cần chạy thêm:
- HR-Data.sql (để có dữ liệu)
- Physical-Implementation.sql (để có đầy đủ chức năng)

---

## 📊 CÁC CHỨC NĂNG CHÍNH

### 1. Quản Lý Nhân Viên

#### Thêm nhân viên mới
```sql
EXEC sp_ThemNhanVien 
    @ID_NhanVien = 'NTNV99',
    @ID_DuAn = 'NTDA01',
    @ID_ChucVu = 'NTCV07',
    @ID_ChiNhanh = 'CN04',
    @ID_PhongBan = 'NTPB01',
    @HoTen = N'Nguyễn Văn A',
    @NgaySinh = '1995-05-15',
    @GioiTinh = N'Nam',
    @DanToc = N'Kinh',
    @CCCD = '001234567899',
    @SoDienThoai = '0987654321',
    @Email = 'nguyenvana@gmail.com',
    @DiaChi = N'Nha Trang';
```

#### Cập nhật thông tin nhân viên
```sql
EXEC sp_CapNhatNhanVien
    @ID_NhanVien = 'NTNV99',
    @SoDienThoai = '0999888777',
    @Email = 'newemail@gmail.com',
    @DiaChi = N'Khánh Hòa';
```

#### Xóa nhân viên
```sql
EXEC sp_XoaNhanVien @ID_NhanVien = 'NTNV99';
```

#### Chuyển phòng ban
```sql
EXEC sp_ChuyenPhongBan
    @ID_NhanVien = 'NTNV01',
    @ID_PhongBan_Moi = 'NTPB02';
```

---

### 2. Quản Lý Lương

#### Thêm lương cho nhân viên
```sql
EXEC sp_ThemLuong
    @ID_Luong = 'NTL99',
    @ID_NhanVien = 'NTNV99',
    @MucLuong = 35000000;
```

#### Cập nhật lương
```sql
EXEC sp_CapNhatLuong
    @ID_NhanVien = 'NTNV99',
    @MucLuong = 40000000;
```

#### Xem log thay đổi lương
```sql
SELECT * FROM LogCapNhatLuong 
ORDER BY NgayCapNhat DESC;
```

---

### 3. Truy Vấn Báo Cáo

#### Xem thông tin nhân viên chi tiết
```sql
SELECT * FROM View_ThongTinNhanVienChiTiet
WHERE TenChiNhanh = 'ORGASM Nha Trang';
```

#### Thống kê theo phòng ban
```sql
SELECT * FROM View_ThongKeTheoPhongBan
ORDER BY TongLuong DESC;
```

#### Thống kê theo chi nhánh
```sql
SELECT * FROM View_ThongKeTheoChiNhanh
ORDER BY SoLuongNhanVien DESC;
```

#### Top nhân viên lương cao
```sql
SELECT TOP 10 * FROM View_ThongTinNhanVienChiTiet
ORDER BY MucLuong DESC;
```

#### Nhân viên theo độ tuổi
```sql
SELECT 
    CASE 
        WHEN Tuoi < 30 THEN N'Dưới 30 tuổi'
        WHEN Tuoi BETWEEN 30 AND 40 THEN N'30-40 tuổi'
        ELSE N'Trên 40 tuổi'
    END AS NhomTuoi,
    COUNT(*) AS SoLuong,
    AVG(MucLuong) AS LuongTrungBinh
FROM View_ThongTinNhanVienChiTiet
GROUP BY 
    CASE 
        WHEN Tuoi < 30 THEN N'Dưới 30 tuổi'
        WHEN Tuoi BETWEEN 30 AND 40 THEN N'30-40 tuổi'
        ELSE N'Trên 40 tuổi'
    END;
```

---

### 4. Sử Dụng Functions

#### Đếm nhân viên theo chi nhánh
```sql
SELECT 
    CN.TenChiNhanh,
    dbo.fn_TongNhanVienTheoChiNhanh(CN.ID_ChiNhanh) AS SoLuongNV
FROM ChiNhanh CN;
```

#### Tính tuổi nhân viên
```sql
SELECT 
    HoTen,
    NgaySinh,
    dbo.fn_TinhTuoi(NgaySinh) AS Tuoi
FROM NhanVien
ORDER BY Tuoi DESC;
```

#### Tổng lương theo phòng ban
```sql
SELECT 
    PB.TenPhongBan,
    dbo.fn_TongLuongTheoPhongBan(PB.ID_PhongBan) AS TongLuong
FROM PhongBan PB
ORDER BY TongLuong DESC;
```

---

## 🔐 PHÂN QUYỀN NGƯỜI DÙNG

### Tạo Login và User

#### Admin (Toàn quyền)
```sql
-- Tạo login
CREATE LOGIN Admin_Login WITH PASSWORD = 'Admin@123';

-- Tạo user
USE QuanLyNhanSu;
CREATE USER Admin_User FOR LOGIN Admin_Login;

-- Gán quyền
ALTER ROLE Role_Admin ADD MEMBER Admin_User;
```

#### Quản lý Chi nhánh
```sql
CREATE LOGIN QuanLyCN_Login WITH PASSWORD = 'QuanLyCN@123';
USE QuanLyNhanSu;
CREATE USER QuanLyCN_User FOR LOGIN QuanLyCN_Login;
ALTER ROLE Role_QuanLyChiNhanh ADD MEMBER QuanLyCN_User;
```

#### Quản lý Phòng ban
```sql
CREATE LOGIN QuanLyPB_Login WITH PASSWORD = 'QuanLyPB@123';
USE QuanLyNhanSu;
CREATE USER QuanLyPB_User FOR LOGIN QuanLyPB_Login;
ALTER ROLE Role_QuanLyPhongBan ADD MEMBER QuanLyPB_User;
```

#### Nhân viên (Chỉ xem)
```sql
CREATE LOGIN NhanVien_Login WITH PASSWORD = 'NhanVien@123';
USE QuanLyNhanSu;
CREATE USER NhanVien_User FOR LOGIN NhanVien_Login;
ALTER ROLE Role_NhanVien ADD MEMBER NhanVien_User;
```

#### Kế toán
```sql
CREATE LOGIN KeToan_Login WITH PASSWORD = 'KeToan@123';
USE QuanLyNhanSu;
CREATE USER KeToan_User FOR LOGIN KeToan_Login;
ALTER ROLE Role_KeToan ADD MEMBER KeToan_User;
```

---

## 💾 BACKUP VÀ RESTORE

### Backup Database

#### Full Backup
```sql
BACKUP DATABASE QuanLyNhanSu
TO DISK = 'D:\Backup\QuanLyNhanSu_Full.bak'
WITH FORMAT, 
     NAME = 'Full Backup',
     COMPRESSION,
     STATS = 10;
```

#### Differential Backup
```sql
BACKUP DATABASE QuanLyNhanSu
TO DISK = 'D:\Backup\QuanLyNhanSu_Diff.bak'
WITH DIFFERENTIAL,
     NAME = 'Differential Backup',
     COMPRESSION;
```

### Restore Database
```sql
-- Restore Full Backup
RESTORE DATABASE QuanLyNhanSu
FROM DISK = 'D:\Backup\QuanLyNhanSu_Full.bak'
WITH REPLACE,
     STATS = 10;
```

---

## 🛠️ BẢO TRÌ HỆ THỐNG

### Rebuild Indexes (Hàng tuần)
```sql
-- Rebuild tất cả indexes
USE QuanLyNhanSu;
EXEC sp_MSforeachtable 'ALTER INDEX ALL ON ? REBUILD';

-- Hoặc rebuild từng bảng
ALTER INDEX ALL ON NhanVien REBUILD;
ALTER INDEX ALL ON Luong REBUILD;
```

### Update Statistics (Hàng ngày)
```sql
-- Update tất cả statistics
EXEC sp_updatestats;

-- Hoặc update từng bảng
UPDATE STATISTICS NhanVien WITH FULLSCAN;
UPDATE STATISTICS Luong WITH FULLSCAN;
```

### Dọn dẹp Log cũ (Hàng tháng)
```sql
-- Xóa log cũ hơn 3 tháng
DELETE FROM LogXoaNhanVien 
WHERE NgayXoa < DATEADD(MONTH, -3, GETDATE());

DELETE FROM LogCapNhatLuong 
WHERE NgayCapNhat < DATEADD(MONTH, -3, GETDATE());
```

### Kiểm tra kích thước Database
```sql
EXEC sp_spaceused;

-- Chi tiết từng bảng
EXEC sp_MSforeachtable 'EXEC sp_spaceused ''?''';
```

---

## 🔍 XỬ LÝ SỰ CỐ

### Lỗi 1: Không thể thêm nhân viên dưới 18 tuổi
**Thông báo:** "Nhân viên phải đủ 18 tuổi trở lên!"

**Nguyên nhân:** Trigger `trg_KiemTraTuoiNhanVien` chặn

**Giải pháp:** Kiểm tra lại ngày sinh, đảm bảo >= 18 tuổi

### Lỗi 2: Không thể thêm lương âm
**Thông báo:** "Mức lương phải lớn hơn hoặc bằng 0!"

**Nguyên nhân:** Trigger `trg_KiemTraMucLuong` chặn

**Giải pháp:** Nhập mức lương >= 0

### Lỗi 3: CCCD đã tồn tại
**Thông báo:** "Số CCCD đã tồn tại!"

**Nguyên nhân:** CCCD phải duy nhất

**Giải pháp:** Kiểm tra CCCD trong database
```sql
SELECT * FROM NhanVien WHERE CCCD = '001234567890';
```

### Lỗi 4: Không thể xóa nhân viên (Khóa ngoại)
**Giải pháp:** Sử dụng stored procedure để xóa tự động
```sql
EXEC sp_XoaNhanVien @ID_NhanVien = 'NTNV01';
```

### Lỗi 5: Truy vấn chậm
**Nguyên nhân:** Index bị fragmented

**Kiểm tra:**
```sql
SELECT 
    OBJECT_NAME(object_id) AS TableName,
    name AS IndexName,
    avg_fragmentation_in_percent
FROM sys.dm_db_index_physical_stats(
    DB_ID(), NULL, NULL, NULL, 'DETAILED'
)
WHERE avg_fragmentation_in_percent > 30;
```

**Giải pháp:**
```sql
ALTER INDEX ALL ON NhanVien REBUILD;
```

---

## 📈 MONITORING VÀ HIỆU SUẤT

### Kiểm tra số lượng bản ghi
```sql
SELECT 
    t.name AS TableName,
    SUM(p.rows) AS RowCount
FROM sys.tables t
INNER JOIN sys.partitions p ON t.object_id = p.object_id
WHERE p.index_id IN (0,1)
GROUP BY t.name
ORDER BY RowCount DESC;
```

### Top 10 truy vấn chậm nhất
```sql
SELECT TOP 10
    qs.execution_count,
    qs.total_elapsed_time / 1000000 AS total_elapsed_time_sec,
    qs.total_worker_time / 1000000 AS total_worker_time_sec,
    SUBSTRING(st.text, (qs.statement_start_offset/2)+1,
        ((CASE qs.statement_end_offset
            WHEN -1 THEN DATALENGTH(st.text)
            ELSE qs.statement_end_offset
        END - qs.statement_start_offset)/2) + 1) AS query_text
FROM sys.dm_exec_query_stats qs
CROSS APPLY sys.dm_exec_sql_text(qs.sql_handle) st
ORDER BY total_elapsed_time_sec DESC;
```

### Kiểm tra Index sử dụng
```sql
SELECT 
    OBJECT_NAME(s.object_id) AS TableName,
    i.name AS IndexName,
    s.user_seeks,
    s.user_scans,
    s.user_lookups,
    s.user_updates
FROM sys.dm_db_index_usage_stats s
INNER JOIN sys.indexes i ON s.object_id = i.object_id
    AND s.index_id = i.index_id
WHERE database_id = DB_ID()
ORDER BY user_seeks + user_scans + user_lookups DESC;
```

---

## 📞 LIÊN HỆ VÀ HỖ TRỢ

**Nhóm phát triển:** Nhóm 5 - Quản lý Nhân viên CSDLPT

**Thành viên:**
- Sinh viên 1
- Sinh viên 2
- Sinh viên 3
- Sinh viên 4
- Sinh viên 5

**Giảng viên hướng dẫn:** [Tên giảng viên]

**Email hỗ trợ:** support@orgasm.com

**Hotline:** 0350899999

---

## 📚 TÀI LIỆU THAM KHẢO

1. **README-Physical-Implementation.md** - Tài liệu kỹ thuật chi tiết
2. **Physical-Implementation.sql** - Source code đầy đủ
3. **Test-Physical-Implementation.sql** - Các test case

---

## ✅ CHECKLIST TRIỂN KHAI

- [ ] Đã cài đặt SQL Server 2019+
- [ ] Đã tạo database thành công
- [ ] Đã import dữ liệu mẫu
- [ ] Đã chạy Physical-Implementation.sql
- [ ] Đã test tất cả chức năng
- [ ] Đã tạo users và phân quyền
- [ ] Đã thiết lập backup plan
- [ ] Đã kiểm tra hiệu suất

---

## 🎉 HOÀN THÀNH!

Bạn đã sẵn sàng sử dụng hệ thống Quản lý Nhân viên Phân tán!

**Chúc bạn sử dụng hiệu quả!** 🚀

---

*Tài liệu được tạo ngày 31/10/2025*
*Phiên bản: 1.0*
*Nhóm 5 - CSDLPT - PTIT*
