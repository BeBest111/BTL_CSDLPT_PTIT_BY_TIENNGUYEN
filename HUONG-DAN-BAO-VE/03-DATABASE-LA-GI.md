# 💾 DATABASE QUANLYNHANSU LÀ GÌ?
## Hiểu về cấu trúc database của project

---

## 🎯 MỤC TIÊU

Sau khi đọc file này, bạn sẽ:
- Hiểu database QuanLyNhanSu làm gì
- Biết có bao nhiêu tables
- Hiểu mối quan hệ giữa các tables
- Nắm được sample data

---

## 📚 GIỚI THIỆU

**QuanLyNhanSu** là database quản lý nhân viên công ty đa chi nhánh.

### Bài toán thực tế:
Công ty có:
- ✅ Nhiều chi nhánh (Hà Nội, Đà Nẵng, Sài Gòn...)
- ✅ Nhiều phòng ban
- ✅ Nhiều nhân viên
- ✅ Nhiều dự án
- ✅ Quản lý lương, chính sách

### Cần quản lý:
- Thông tin nhân viên
- Phòng ban, chức vụ
- Dự án nhân viên tham gia
- Lương, thưởng
- Chính sách công ty

---

## 🗂️ CẤU TRÚC DATABASE

### Tổng quan:
```
Database: QuanLyNhanSu
├── 8 Tables chính
├── 2 Audit Log Tables
├── 14 Views
├── 6 Stored Procedures
├── 6 Functions
├── 4 Triggers
└── 12+ Indexes
```

---

## 📊 8 TABLES CHÍNH

### 1. **TruSoChinh** (Trụ sở chính)
```
Lưu thông tin trụ sở chính công ty.

Columns:
- ID_TruSo (PRIMARY KEY)
- TenCongTy
- DiaChi
- DienThoai
- Email
- Website

Ví dụ:
ID_TruSo: TSC01
TenCongTy: Công ty TNHH Công nghệ ABC
DiaChi: Tầng 10, Tòa nhà XYZ, Hà Nội
```

---

### 2. **ChiNhanh** (Chi nhánh)
```
Lưu các chi nhánh của công ty.

Columns:
- ID_ChiNhanh (PRIMARY KEY)
- TenChiNhanh
- DiaChi
- DienThoai
- Email
- ID_TruSo (FOREIGN KEY → TruSoChinh)

Ví dụ:
ID_ChiNhanh: CN01
TenChiNhanh: Chi nhánh Hà Nội
DiaChi: 123 Láng Hạ, Đống Đa
```

**Sample data:** 10 chi nhánh

---

### 3. **PhongBan** (Phòng ban)
```
Các phòng ban trong công ty.

Columns:
- ID_PhongBan (PRIMARY KEY)
- TenPhongBan
- SoNhanVien
- ID_ChiNhanh (FOREIGN KEY → ChiNhanh)

Ví dụ:
ID_PhongBan: PB01
TenPhongBan: Phòng Kỹ Thuật
SoNhanVien: 20
```

**Sample data:** 10 phòng ban

---

### 4. **ChucVu** (Chức vụ)
```
Các chức vụ trong công ty.

Columns:
- ID_ChucVu (PRIMARY KEY)
- TenChucVu
- MoTa
- MucLuongCoBan

Ví dụ:
ID_ChucVu: CV01
TenChucVu: Giám đốc
MucLuongCoBan: 50000000
```

**Sample data:** 20 chức vụ

---

### 5. **NhanVien** (Nhân viên) ⭐ TABLE QUAN TRỌNG NHẤT
```
Thông tin chi tiết nhân viên.

Columns:
- ID_NhanVien (PRIMARY KEY)
- HoTen
- NgaySinh
- GioiTinh
- SoDienThoai
- Email
- DiaChi
- NgayVaoLam
- ID_ChucVu (FK → ChucVu)
- ID_PhongBan (FK → PhongBan)
- ID_ChiNhanh (FK → ChiNhanh)

Ví dụ:
ID_NhanVien: NV001
HoTen: Nguyễn Văn An
NgaySinh: 1990-05-15
GioiTinh: Nam
Email: an.nv@company.com
```

**Sample data:** 40 nhân viên

---

### 6. **DuAn** (Dự án)
```
Các dự án công ty đang thực hiện.

Columns:
- ID_DuAn (PRIMARY KEY)
- TenDuAn
- MoTa
- NgayBatDau
- NgayKetThuc
- ID_PhongBan (FK → PhongBan)

Ví dụ:
ID_DuAn: DA001
TenDuAn: Hệ thống quản lý bán hàng
NgayBatDau: 2024-01-01
NgayKetThuc: 2024-12-31
```

**Sample data:** 15 dự án

---

### 7. **Luong** (Lương)
```
Thông tin lương nhân viên theo tháng.

Columns:
- ID_Luong (PRIMARY KEY)
- ID_NhanVien (FK → NhanVien)
- Thang
- Nam
- LuongCoBan
- PhuCap
- Thuong
- KhauTru
- TongLuong

Ví dụ:
ID_Luong: L001
ID_NhanVien: NV001
Thang: 12
Nam: 2024
TongLuong: 25000000
```

**Sample data:** 30 bản ghi lương

---

### 8. **ChinhSach** (Chính sách)
```
Các chính sách, quy định công ty.

Columns:
- ID_ChinhSach (PRIMARY KEY)
- TenChinhSach
- MoTa
- NgayApDung
- NgayHetHan

Ví dụ:
ID_ChinhSach: CS001
TenChinhSach: Chính sách làm việc từ xa
NgayApDung: 2024-01-01
```

**Sample data:** 6 chính sách

---

## 🔐 2 AUDIT LOG TABLES

### 1. **AuditLog_XoaNhanVien**
```
Lưu log khi xóa nhân viên.

Columns:
- LogID (AUTO INCREMENT)
- ID_NhanVien
- HoTen
- NgayXoa
- NguoiXoa
- LyDo
```

---

### 2. **AuditLog_Luong**
```
Lưu log khi cập nhật lương.

Columns:
- LogID (AUTO INCREMENT)
- ID_Luong
- ID_NhanVien
- LuongCu
- LuongMoi
- NgayCapNhat
- NguoiCapNhat
```

---

## 🔗 MỐI QUAN HỆ GIỮA CÁC TABLES

```
TruSoChinh (1) ──→ (n) ChiNhanh
                       │
                       ├──→ (n) PhongBan
                       │       │
                       │       ├──→ (n) DuAn
                       │       │
                       │       └──→ (n) NhanVien
                       │                 │
                       └──────────────────┤
                                         │
                                         ├──→ (n) Luong
                                         │
ChucVu (1) ──────────────────────────────┘
```

### Giải thích:
1. **Một trụ sở chính** có nhiều **chi nhánh**
2. **Một chi nhánh** có nhiều **phòng ban**
3. **Một phòng ban** có nhiều **nhân viên** và **dự án**
4. **Một nhân viên** có một **chức vụ**
5. **Một nhân viên** có nhiều bản ghi **lương** (theo tháng)

---

## 📈 SAMPLE DATA OVERVIEW

```
Table Name         | Số Records
-------------------|------------
TruSoChinh        | 1
ChiNhanh          | 10
PhongBan          | 10
ChucVu            | 20
NhanVien          | 40
DuAn              | 15
Luong             | 30
ChinhSach         | 6
AuditLog_XoaNV    | 0 (ban đầu)
AuditLog_Luong    | 0 (ban đầu)
-------------------|------------
TOTAL             | 131 records
```

---

## 🎨 VÍ DỤ DỮ LIỆU THỰC TẾ

### Chi nhánh:
```
CN01: Chi nhánh Hà Nội
CN02: Chi nhánh Đà Nẵng
CN03: Chi nhánh Sài Gòn
CN04: Chi nhánh Hải Phòng
CN05: Chi nhánh Cần Thơ
```

### Phòng ban:
```
PB01: Phòng Kỹ Thuật (Chi nhánh 01)
PB02: Phòng Kinh Doanh (Chi nhánh 01)
PB03: Phòng Nhân Sự (Chi nhánh 02)
...
```

### Chức vụ:
```
CV01: Giám đốc (50,000,000 VNĐ)
CV02: Phó Giám đốc (40,000,000 VNĐ)
CV03: Trưởng phòng (30,000,000 VNĐ)
CV04: Nhân viên (15,000,000 VNĐ)
...
```

### Nhân viên (ví dụ):
```
NV001: Nguyễn Văn An
- Chi nhánh: CN01 (Hà Nội)
- Phòng ban: PB01 (Kỹ Thuật)
- Chức vụ: CV03 (Trưởng phòng)
- Lương: 30,000,000 VNĐ
```

---

## 🔍 QUERY MẪU

### Đếm nhân viên mỗi chi nhánh:
```sql
SELECT 
    cn.TenChiNhanh,
    COUNT(nv.ID_NhanVien) AS SoNhanVien
FROM ChiNhanh cn
LEFT JOIN NhanVien nv ON cn.ID_ChiNhanh = nv.ID_ChiNhanh
GROUP BY cn.TenChiNhanh
ORDER BY SoNhanVien DESC
```

### Top 5 nhân viên lương cao nhất:
```sql
SELECT TOP 5
    nv.HoTen,
    cv.TenChucVu,
    l.TongLuong
FROM NhanVien nv
JOIN Luong l ON nv.ID_NhanVien = l.ID_NhanVien
JOIN ChucVu cv ON nv.ID_ChucVu = cv.ID_ChucVu
WHERE l.Thang = 12 AND l.Nam = 2024
ORDER BY l.TongLuong DESC
```

---

## 📖 FILES LIÊN QUAN

- `HR.sql` - Script tạo database và tables
- `HR-Data.sql` - Script insert sample data
- `04-CAC-SCRIPT-SQL.md` - Giải thích chi tiết scripts

---

## ✅ TỰ KIỂM TRA

Sau khi đọc xong, bạn trả lời được không?

1. Database này làm gì?
2. Có bao nhiêu tables chính?
3. Table quan trọng nhất là gì?
4. Mối quan hệ giữa ChiNhanh và PhongBan?
5. Sample data có bao nhiêu nhân viên?

**Đáp án:**
1. Quản lý nhân viên công ty đa chi nhánh
2. 8 tables chính + 2 audit logs
3. NhanVien (nhân viên)
4. Một chi nhánh có nhiều phòng ban (1-n)
5. 40 nhân viên

---

**Đã hiểu rõ cấu trúc database! Sang file tiếp theo! 🚀**
