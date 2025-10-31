# 🚀 QUICK START GUIDE
## Hệ Thống Quản Lý Nhân Viên Phân Tán

---

## ⚡ CÀI ĐẶT TRONG 5 PHÚT

### Bước 1: Mở SQL Server Management Studio (SSMS)

### Bước 2: Chạy 3 file theo thứ tự

```
1. HR.sql                           → Tạo database và bảng
2. HR-Data.sql                      → Thêm dữ liệu mẫu  
3. Physical-Implementation.sql      → Cài đặt vật lý (Views, Procedures, Functions, Triggers, Indexes)
```

### Bước 3: Test hệ thống (Optional)

```
4. Test-Physical-Implementation.sql → Kiểm tra tất cả chức năng
```

---

## 📂 DANH SÁCH FILE

### 🔵 Files BẮT BUỘC chạy (Theo thứ tự)
1. **HR.sql** - Tạo database
2. **HR-Data.sql** - Import dữ liệu
3. **Physical-Implementation.sql** - Cài đặt vật lý ⭐

### 🟢 Files HỖ TRỢ
4. **Test-Physical-Implementation.sql** - Test hệ thống
5. **Deploy-Full.sql** - Deploy tự động (alternative)

### 📘 Files TÀI LIỆU
- **README.md** - Tổng quan dự án (ĐỌC ĐẦU TIÊN)
- **README-Physical-Implementation.md** - Tài liệu kỹ thuật chi tiết
- **HUONG-DAN-SU-DUNG.md** - Hướng dẫn sử dụng từng chức năng
- **BAO-CAO-PHAN-3.md** - Báo cáo tóm tắt
- **CHECKLIST.md** - Checklist hoàn thành
- **QUICKSTART.md** - File này

---

## 🎯 CÁC TÍNH NĂNG CHÍNH

### 1. Quản lý Nhân viên
```sql
-- Thêm nhân viên
EXEC sp_ThemNhanVien @ID_NhanVien='NTNV99', @HoTen=N'Nguyễn Văn A', ...

-- Cập nhật nhân viên
EXEC sp_CapNhatNhanVien @ID_NhanVien='NTNV99', @Email='new@email.com'

-- Xóa nhân viên
EXEC sp_XoaNhanVien @ID_NhanVien='NTNV99'
```

### 2. Quản lý Lương
```sql
-- Thêm lương
EXEC sp_ThemLuong @ID_Luong='NTL99', @ID_NhanVien='NTNV99', @MucLuong=35000000

-- Cập nhật lương
EXEC sp_CapNhatLuong @ID_NhanVien='NTNV99', @MucLuong=40000000
```

### 3. Báo cáo
```sql
-- Xem chi tiết nhân viên
SELECT * FROM View_ThongTinNhanVienChiTiet

-- Thống kê theo phòng ban
SELECT * FROM View_ThongKeTheoPhongBan

-- Top 10 lương cao nhất
SELECT TOP 10 * FROM View_ThongTinNhanVienChiTiet ORDER BY MucLuong DESC
```

---

## 📊 KẾT QUẢ SAU KHI CÀI ĐẶT

Bạn sẽ có:

✅ 10 bảng dữ liệu
✅ 131 bản ghi mẫu
✅ 11+ Views
✅ 6 Stored Procedures
✅ 6 Functions
✅ 4 Triggers
✅ 12+ Indexes
✅ 5 Roles phân quyền

**Tổng cộng:** 54+ database objects

---

## 🆘 XỬ LÝ LỖI THƯỜNG GẶP

### Lỗi 1: "Database 'QuanLyNhanSu' already exists"
**Giải pháp:** Xóa database cũ hoặc đổi tên

```sql
DROP DATABASE QuanLyNhanSu;
```

### Lỗi 2: "Object already exists"
**Giải pháp:** Chạy Deploy-Full.sql để cleanup hoặc xóa thủ công

```sql
DROP VIEW IF EXISTS View_ThongTinNhanVienChiTiet;
DROP PROCEDURE IF EXISTS sp_ThemNhanVien;
-- etc...
```

### Lỗi 3: "Cannot insert duplicate key"
**Giải pháp:** Database đã có dữ liệu, bỏ qua HR-Data.sql hoặc xóa dữ liệu cũ

```sql
DELETE FROM Luong;
DELETE FROM NhanVien;
-- etc...
```

---

## 📞 TRỢ GIÚP

- 📖 Xem chi tiết: **README-Physical-Implementation.md**
- 📗 Hướng dẫn đầy đủ: **HUONG-DAN-SU-DUNG.md**
- 📋 Kiểm tra: **CHECKLIST.md**
- 📊 Báo cáo: **BAO-CAO-PHAN-3.md**

---

## ✅ CHECKLIST NHANH

- [ ] Đã mở SSMS
- [ ] Đã chạy HR.sql
- [ ] Đã chạy HR-Data.sql
- [ ] Đã chạy Physical-Implementation.sql
- [ ] Đã test một vài câu lệnh
- [ ] Đọc README.md để hiểu rõ hơn

---

## 🎉 HOÀN THÀNH!

Hệ thống đã sẵn sàng sử dụng!

**Next steps:**
1. Đọc README.md để hiểu tổng quan
2. Đọc HUONG-DAN-SU-DUNG.md để biết cách dùng
3. Thử các câu lệnh ví dụ
4. Khám phá các Views và Procedures

**Chúc bạn thành công!** 🚀

---

*Tạo bởi Nhóm 5 - CSDLPT - PTIT*
*Ngày: 31/10/2025*
