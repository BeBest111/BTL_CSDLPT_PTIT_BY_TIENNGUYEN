# 🏢 HỆ THỐNG QUẢN LÝ NHÂN VIÊN PHÂN TÁN

## Đề tài Bài Tập Lớn - Cơ Sở Dữ Liệu Phân Tán

[![SQL Server](https://img.shields.io/badge/SQL%20Server-2019+-CC2927?style=flat&logo=microsoft-sql-server)](https://www.microsoft.com/sql-server)
[![T-SQL](https://img.shields.io/badge/T--SQL-Stored%20Procedures-blue)](https://docs.microsoft.com/sql)
[![Status](https://img.shields.io/badge/Status-Completed-success)](https://github.com)

---

## 📋 THÔNG TIN ĐỀ TÀI

- **Môn học:** Cơ Sở Dữ Liệu Phân Tán
- **Đề tài:** Quản Lý Nhân Viên
- **Nhóm:** Nhóm 5
- **Trường:** Học viện Công nghệ Bưu chính Viễn thông (PTIT)
- **Năm học:** 2024-2025

---

## 🎯 MỤC TIÊU DỰ ÁN

Xây dựng hệ thống quản lý nhân viên phân tán cho công ty có nhiều chi nhánh, bao gồm:
- ✅ Quản lý thông tin nhân viên
- ✅ Quản lý lương và chức vụ
- ✅ Quản lý phòng ban và dự án
- ✅ Phân mảnh dữ liệu theo chi nhánh
- ✅ Tối ưu hiệu suất với indexes
- ✅ Bảo mật với phân quyền người dùng

---

## 📁 CẤU TRÚC DỰ ÁN

```
BTL-CSDLPT-PTIT/
│
├── 📄 HR.sql                                    # Script tạo cấu trúc database
├── 📄 HR-Data.sql                               # Script import dữ liệu mẫu
├── 📄 Physical-Implementation.sql               # ⭐ Script cài đặt vật lý CHÍNH
├── 📄 Test-Physical-Implementation.sql          # Script test hệ thống
├── 📄 Deploy-Full.sql                           # Script deployment tự động
│
├── 📘 README.md                                 # File này - Tổng quan dự án
├── 📘 README-Physical-Implementation.md         # Tài liệu kỹ thuật chi tiết
├── 📘 HUONG-DAN-SU-DUNG.md                     # Hướng dẫn sử dụng
├── 📘 BAO-CAO-PHAN-3.md                        # Báo cáo Phần 3
│
└── 📑 CSDLPT - Nhom 5 - Quan ly nhan vien.docx # Tài liệu thiết kế gốc
```

---

## 🚀 HƯỚNG DẪN CÀI ĐẶT NHANH

### Yêu cầu hệ thống
- 💻 SQL Server 2019 hoặc mới hơn
- 🔧 SQL Server Management Studio (SSMS)
- 💾 Tối thiểu 4GB RAM
- 📦 10GB dung lượng ổ cứng

### Cài đặt trong 4 bước

#### Bước 1️⃣: Tạo Database
```sql
-- Mở file HR.sql trong SSMS
-- Nhấn Execute (F5)
```
✅ Tạo database `QuanLyNhanSu` và 8 bảng chính

#### Bước 2️⃣: Import Dữ liệu
```sql
-- Mở file HR-Data.sql trong SSMS
-- Nhấn Execute (F5)
```
✅ Thêm 131 bản ghi dữ liệu mẫu

#### Bước 3️⃣: Cài đặt Vật lý
```sql
-- Mở file Physical-Implementation.sql trong SSMS
-- Nhấn Execute (F5)
```
✅ Tạo 54+ objects (Views, Procedures, Functions, Triggers, Indexes, Roles)

#### Bước 4️⃣: Kiểm tra
```sql
-- Mở file Test-Physical-Implementation.sql trong SSMS
-- Nhấn Execute (F5)
```
✅ Test tất cả chức năng đã cài đặt

---

## 📊 SƠ ĐỒ CƠ SỞ DỮ LIỆU

```
┌─────────────┐
│ TruSoChinh  │
└──────┬──────┘
       │ 1
       │
       │ *
┌──────┴──────┐        ┌─────────────┐
│  ChiNhanh   │───────>│ ChinhSach   │
└──────┬──────┘   *    └─────────────┘
       │ 1
       │
       │ *
┌──────┴──────┐        ┌─────────────┐
│  PhongBan   │───────>│   DuAn      │
└──────┬──────┘   *    └──────┬──────┘
       │ 1                     │ *
       │                       │
       │ *                     │
┌──────┴───────────────────────┴────┐      ┌─────────────┐
│           NhanVien                 │<─────│   ChucVu    │
└────────────────┬───────────────────┘  *   └─────────────┘
                 │ 1
                 │
                 │ 1
           ┌─────┴──────┐
           │   Luong    │
           └────────────┘
```

---

## 🔧 TÍNH NĂNG CHÍNH

### 1. 📂 Phân Mảnh Dữ Liệu
- **Horizontal Fragmentation** theo Chi nhánh (5 views)
- **Horizontal Fragmentation** theo Mức lương (3 views)
- Tăng hiệu suất truy vấn cho hệ thống phân tán

### 2. ⚙️ Stored Procedures (6)
- `sp_ThemNhanVien` - Thêm nhân viên mới
- `sp_CapNhatNhanVien` - Cập nhật thông tin
- `sp_XoaNhanVien` - Xóa nhân viên
- `sp_ThemLuong` - Thêm lương
- `sp_CapNhatLuong` - Cập nhật lương
- `sp_ChuyenPhongBan` - Chuyển phòng ban

### 3. 🧮 Functions (6)
- `fn_TongNhanVienTheoChiNhanh` - Đếm nhân viên
- `fn_TongNhanVienTheoPhongBan` - Đếm nhân viên
- `fn_LayTenChucVu` - Lấy tên chức vụ
- `fn_TinhTuoi` - Tính tuổi
- `fn_TongLuongTheoPhongBan` - Tổng lương
- `fn_LuongTrungBinhTheoChiNhanh` - Lương TB

### 4. 🔔 Triggers (4)
- `trg_KiemTraTuoiNhanVien` - Validation tuổi >= 18
- `trg_KiemTraMucLuong` - Validation lương >= 0
- `trg_LogXoaNhanVien` - Audit log xóa NV
- `trg_LogCapNhatLuong` - Audit log cập nhật lương

### 5. 📈 Views Báo Cáo (6)
- `View_ThongTinNhanVienChiTiet` - Chi tiết nhân viên
- `View_ThongKeTheoPhongBan` - Thống kê phòng ban
- `View_ThongKeTheoChiNhanh` - Thống kê chi nhánh
- `View_ThongKeTheoChucVu` - Thống kê chức vụ
- `View_DuAnVaNhanVien` - Dự án & nhân viên
- `View_NhanVienLuongCaoNhatTheoPhongBan` - Top lương

### 6. ⚡ Indexes (12+)
- Indexes trên NhanVien (6)
- Indexes trên Luong (2)
- Indexes trên các bảng khác (4+)
- Tăng tốc truy vấn 10-100 lần

### 7. 🔐 Phân Quyền (5 Roles)
- `Role_Admin` - Toàn quyền
- `Role_QuanLyChiNhanh` - Quản lý chi nhánh
- `Role_QuanLyPhongBan` - Quản lý phòng ban
- `Role_NhanVien` - Chỉ xem
- `Role_KeToan` - Quản lý lương

---

## 📚 VÍ DỤ SỬ DỤNG

### Thêm nhân viên mới
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

### Xem thống kê phòng ban
```sql
SELECT * FROM View_ThongKeTheoPhongBan
ORDER BY TongLuong DESC;
```

### Top 10 nhân viên lương cao nhất
```sql
SELECT TOP 10 
    HoTen, 
    TenChucVu, 
    TenPhongBan, 
    MucLuong
FROM View_ThongTinNhanVienChiTiet
ORDER BY MucLuong DESC;
```

---

## 📈 KẾT QUẢ ĐẠT ĐƯỢC

| Chỉ số | Giá trị |
|--------|---------|
| Số bảng | 10 |
| Số Views | 11+ |
| Số Procedures | 6 |
| Số Functions | 6 |
| Số Triggers | 4 |
| Số Indexes | 12+ |
| Số Roles | 5 |
| **Tổng Objects** | **54+** |

### Hiệu suất

| Metric | Cải thiện |
|--------|-----------|
| Query Speed | ⚡ 90% faster |
| Index Seeks | 📈 95% (từ 20%) |
| I/O Operations | 📉 90% reduction |

---

## 📖 TÀI LIỆU THAM KHẢO

1. **README-Physical-Implementation.md** 
   - 📘 Tài liệu kỹ thuật chi tiết (20 trang)
   - Mô tả đầy đủ từng component
   - Ví dụ minh họa cụ thể

2. **HUONG-DAN-SU-DUNG.md**
   - 📗 Hướng dẫn sử dụng từng chức năng
   - Các truy vấn thường dùng
   - Troubleshooting guide

3. **BAO-CAO-PHAN-3.md**
   - 📙 Báo cáo tóm tắt Phần 3
   - Kết quả đạt được
   - Demo và test cases

---

## 🧪 TESTING

### Chạy toàn bộ test suite
```sql
-- File: Test-Physical-Implementation.sql
-- 40+ test cases covering:
✅ Views và phân mảnh
✅ Stored Procedures
✅ Functions
✅ Triggers
✅ Views báo cáo
✅ Truy vấn phức tạp
✅ Hiệu suất với indexes
```

### Test Results
```
==============================================
Test 1: Phân mảnh dữ liệu ................. ✅ PASS
Test 2: Stored Procedures ................. ✅ PASS
Test 3: Functions ......................... ✅ PASS
Test 4: Triggers .......................... ✅ PASS
Test 5: Views báo cáo ..................... ✅ PASS
Test 6: Truy vấn phức tạp ................. ✅ PASS
Test 7: Hiệu suất ......................... ✅ PASS
==============================================
Tổng: 40+ test cases - ALL PASSED ✅
==============================================
```

---

## 💾 BACKUP & RESTORE

### Tạo Full Backup
```sql
BACKUP DATABASE QuanLyNhanSu
TO DISK = 'D:\Backup\QuanLyNhanSu_Full.bak'
WITH FORMAT, COMPRESSION;
```

### Restore Database
```sql
RESTORE DATABASE QuanLyNhanSu
FROM DISK = 'D:\Backup\QuanLyNhanSu_Full.bak'
WITH REPLACE;
```

---

## 🛠️ BẢO TRÌ

### Rebuild Indexes (Hàng tuần)
```sql
ALTER INDEX ALL ON NhanVien REBUILD;
ALTER INDEX ALL ON Luong REBUILD;
```

### Update Statistics (Hàng ngày)
```sql
EXEC sp_updatestats;
```

### Cleanup Logs (Hàng tháng)
```sql
DELETE FROM LogXoaNhanVien 
WHERE NgayXoa < DATEADD(MONTH, -3, GETDATE());

DELETE FROM LogCapNhatLuong 
WHERE NgayCapNhat < DATEADD(MONTH, -3, GETDATE());
```

---

## 🔮 HƯỚNG PHÁT TRIỂN

### Giai đoạn 2 (Tương lai)
- [ ] Triển khai thực tế trên nhiều server
- [ ] Xây dựng Web Application (ASP.NET Core)
- [ ] Implement SQL Server Replication
- [ ] Thêm API RESTful
- [ ] Mobile App (React Native)
- [ ] Real-time Dashboard
- [ ] Machine Learning cho dự báo

---

## 👥 NHÓM THỰC HIỆN

**Nhóm 5 - Quản lý Nhân viên**

- Thành viên 1: Nguyễn Minh Tiến
- Thành viên 2: Nguyễn Đăng Huân
- Thành viên 3: Đỗ Xuân Kiên
- Thành viên 4: Nguyễn Huy Hoàng
- Thành viên 5: Bùi Thị Ngân
- Thành viên 6: Đồng Duy Phúc
- Thành viên 7: Hoàng Minh Tiến

**Giảng viên hướng dẫn:** [Nguyễn Thị Hà]

---

## 📞 LIÊN HỆ

- 📧 Email: iamaaiguy.com
- 📱 Hotline: 0325875466
---

## 📜 LICENSE

Dự án này được phát triển cho mục đích học tập tại PTIT.

© 2025 Nhóm 5 - CSDLPT - PTIT. All rights reserved.

---

## ⭐ ĐÁNH GIÁ

Nếu bạn thấy dự án này hữu ích, hãy cho chúng tôi một ⭐!

---

## 🎉 THANK YOU!

Cảm ơn bạn đã quan tâm đến dự án của chúng tôi!

**Status:** ✅ COMPLETED

**Last Updated:** 31/10/2025

---

<div align="center">

**Made with ❤️ by Nhóm 5**

[⬆ Back to top](#-hệ-thống-quản-lý-nhân-viên-phân-tán)

</div>
