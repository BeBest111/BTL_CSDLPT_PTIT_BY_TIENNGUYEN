# 📚 KIẾN THỨC CƠ BẢN CẦN BIẾT
## Dành cho người mới bắt đầu - Giải thích từ con số 0

---

## 🎯 MỤC TIÊU FILE NÀY

Sau khi đọc xong, bạn sẽ hiểu:
- Cơ sở dữ liệu là gì?
- Cơ sở dữ liệu phân tán khác gì bình thường?
- SQL Server là gì?
- Docker là gì?
- Project này làm gì?

---

## 1️⃣ CƠ SỞ DỮ LIỆU (DATABASE) LÀ GÌ?

### Khái niệm đơn giản:
**Database = Kho chứa thông tin có tổ chức**

### Ví dụ thực tế:

**Giống như tủ hồ sơ trong văn phòng:**
```
Tủ hồ sơ (Database)
├── Ngăn A: Hồ sơ nhân viên (Table NhanVien)
│   ├── Hồ sơ Nguyễn Văn A
│   ├── Hồ sơ Trần Thị B
│   └── ...
├── Ngăn B: Phiếu lương (Table Luong)
│   ├── Lương tháng 1
│   ├── Lương tháng 2
│   └── ...
└── Ngăn C: Phòng ban (Table PhongBan)
    ├── Phòng Marketing
    ├── Phòng IT
    └── ...
```

### Trong máy tính:
- **Tủ hồ sơ** = Database (QuanLyNhanSu)
- **Ngăn tủ** = Table (Bảng)
- **Mỗi hồ sơ** = Row (Hàng/Record)
- **Thông tin trong hồ sơ** = Column (Cột/Field)

---

## 2️⃣ CƠ SỞ DỮ LIỆU PHÂN TÁN LÀ GÌ?

### Khái niệm:
**Database phân tán = Chia database ra nhiều nơi**

### So sánh:

#### Database thường (Tập trung):
```
      [Database duy nhất ở Hà Nội]
             ↓
    Tất cả chi nhánh đều kết nối về HN
    
❌ Vấn đề:
- Nếu HN hỏng → Toàn bộ hệ thống chết
- Chi nhánh xa kết nối chậm
- Nhiều người truy cập → Quá tải
```

#### Database phân tán (Project của chúng ta):
```
[DB Hà Nội]  ←→  [DB Đà Nẵng]  ←→  [DB Sài Gòn]
     ↓                ↓                 ↓
  CN HN           CN ĐN              CN SG
  
✅ Lợi ích:
- HN hỏng → ĐN và SG vẫn hoạt động
- Mỗi chi nhánh truy cập DB gần nhất → Nhanh
- Dữ liệu được đồng bộ giữa các nơi
```

### Ví dụ thực tế:
**Giống như hệ thống ngân hàng:**
- Bạn gửi tiền ở chi nhánh Hà Nội
- Dữ liệu được lưu ở DB Hà Nội
- Đồng thời được đồng bộ sang DB Đà Nẵng, SG
- Bạn đi Đà Nẵng vẫn rút được tiền
- Rút tiền ở ĐN → Dữ liệu tự động sync về HN

---

## 3️⃣ SQL VÀ SQL SERVER LÀ GÌ?

### SQL (Structured Query Language):
**SQL = Ngôn ngữ để "nói chuyện" với database**

### Ví dụ:
```sql
-- Tiếng Việt: "Cho tôi xem danh sách nhân viên"
-- SQL:
SELECT * FROM NhanVien;

-- Tiếng Việt: "Thêm nhân viên mới tên Nguyễn Văn A"
-- SQL:
INSERT INTO NhanVien VALUES ('NV001', 'Nguyễn Văn A', ...);

-- Tiếng Việt: "Xóa nhân viên có mã NV001"
-- SQL:
DELETE FROM NhanVien WHERE ID = 'NV001';
```

### SQL Server:
**SQL Server = Phần mềm quản lý database của Microsoft**

**Giống như:**
- Word là phần mềm soạn thảo văn bản
- SQL Server là phần mềm quản lý database

**Các loại SQL Server:**
- MySQL (miễn phí, phổ biến)
- PostgreSQL (miễn phí)
- **Microsoft SQL Server** (chúng ta dùng cái này)
- Oracle (đắt tiền, doanh nghiệp lớn)

---

## 4️⃣ DOCKER LÀ GÌ?

### Khái niệm đơn giản:
**Docker = "Thùng container" đóng gói ứng dụng**

### Vấn đề trước khi có Docker:

```
❌ Cài SQL Server trên máy thật:
- Phải download 5GB
- Cài đặt 2 giờ
- Cấu hình phức tạp
- Xóa khó, để lại "rác"
- Máy khác setup lại từ đầu
```

### Giải pháp với Docker:

```
✅ Dùng Docker:
- Download image (như "khuôn mẫu") 1 lần
- Chạy container trong 30 giây
- Cấu hình tự động
- Xóa sạch trong 5 giây
- Máy khác chạy y chang
```

### Ví dụ thực tế:

**Docker giống như "đồ ăn nhanh":**

**Không có Docker** (nấu từ đầu):
```
1. Mua nguyên liệu (download SQL Server)
2. Rửa, cắt, chế biến (cài đặt)
3. Nấu 2 tiếng (config)
4. Ăn xong phải dọn bếp (xóa phức tạp)
```

**Có Docker** (đồ ăn có sẵn):
```
1. Mở hộp (chạy container)
2. Hâm nóng 2 phút (docker run)
3. Ăn luôn!
4. Vứt hộp (docker rm)
```

### Thuật ngữ Docker:

| Thuật ngữ | Giải thích | Ví dụ |
|-----------|------------|-------|
| **Image** | Khuôn mẫu, bản thiết kế | Công thức nấu phở |
| **Container** | Ứng dụng đang chạy | Tô phở đã nấu sẵn |
| **Docker Hub** | Kho chứa images | Siêu thị đồ ăn |
| **docker run** | Chạy container | Nấu phở |
| **docker stop** | Dừng container | Tắt bếp |

---

## 5️⃣ PROJECT CỦA CHÚNG TA LÀM GÌ?

### Đề tài:
**"Quản lý nhân viên trong công ty đa chi nhánh"**

### Tình huống:

```
Công ty XYZ có:
- Trụ sở chính ở Hà Nội
- 7 chi nhánh: TP.HCM, Đà Nẵng, Nha Trang, Hải Phòng, Cần Thơ, Huế, Vũng Tàu
- 100+ nhân viên
- Nhiều phòng ban, dự án

Cần quản lý:
- Thông tin nhân viên (tên, tuổi, CCCD, ...)
- Lương
- Chức vụ
- Phòng ban
- Dự án
```

### Giải pháp:

**Xây dựng hệ thống database phân tán:**

```
Site 1: Hà Nội (Server chính)
├── Quản lý tất cả dữ liệu
├── Đồng bộ với các chi nhánh
└── Báo cáo tổng hợp

Site 2: Đà Nẵng (Server phụ)
├── Dữ liệu nhân viên miền Trung
├── Kết nối với Hà Nội
└── Có thể hoạt động độc lập

Site 3: Sài Gòn (Server phụ)
├── Dữ liệu nhân viên miền Nam
├── Kết nối với Hà Nội
└── Có thể hoạt động độc lập
```

### Chức năng chính:

1. **Quản lý nhân viên**
   - Thêm nhân viên mới
   - Sửa thông tin
   - Xóa (khi nghỉ việc)
   - Tìm kiếm

2. **Quản lý lương**
   - Nhập lương hàng tháng
   - Tính tổng lương phòng ban
   - Thống kê lương

3. **Quản lý phòng ban**
   - Tạo phòng ban mới
   - Chuyển nhân viên giữa các phòng
   - Xem danh sách nhân viên

4. **Báo cáo thống kê**
   - Số nhân viên theo chi nhánh
   - Lương trung bình
   - Top nhân viên lương cao

---

## 6️⃣ KIẾN TRÚC HỆ THỐNG

### Mô hình tổng quan:

```
┌─────────────────────────────────────────┐
│     MÁY TÍNH CỦA BẠN (Physical Host)    │
│  - Ubuntu Linux                          │
│  - Docker đã cài                         │
└─────────────────────────────────────────┘
              │
              ├── Docker Network (172.20.0.0/24)
              │
    ┌─────────┼─────────┬─────────┐
    ↓         ↓         ↓         ↓
┌────────┐ ┌────────┐ ┌────────┐
│HANOI   │ │DANANG  │ │SAIGON  │
│Container│ │Container│ │Container│
├────────┤ ├────────┤ ├────────┤
│SQL     │ │SQL     │ │SQL     │
│Server  │ │Server  │ │Server  │
│2019    │ │2019    │ │2019    │
├────────┤ ├────────┤ ├────────┤
│Port    │ │Port    │ │Port    │
│1433    │ │1434    │ │1435    │
├────────┤ ├────────┤ ├────────┤
│DB:     │ │DB:     │ │DB:     │
│QuanLy  │ │QuanLy  │ │QuanLy  │
│NhanSu  │ │NhanSu  │ │NhanSu  │
└────────┘ └────────┘ └────────┘
```

### Giải thích từng thành phần:

1. **Physical Host (Máy thật)**
   - Máy Linux của bạn
   - Cài Docker
   - Chạy 3 containers

2. **Docker Network**
   - Mạng ảo nội bộ
   - 3 containers kết nối với nhau
   - IP: 172.20.0.101, .102, .103

3. **Container HANOI (Site 1)**
   - SQL Server chạy trong container
   - Port 1433 (cổng mặc định)
   - Database: QuanLyNhanSu
   - Vai trò: Server chính

4. **Container DANANG (Site 2)**
   - Port 1434
   - Vai trò: Server phụ miền Trung

5. **Container SAIGON (Site 3)**
   - Port 1435
   - Vai trò: Server phụ miền Nam

---

## 7️⃣ DỮ LIỆU TRONG DATABASE

### Cấu trúc tables (bảng):

```
QuanLyNhanSu (Database)
├── TruSoChinh (1 record)
│   └── Trụ sở chính Hà Nội
│
├── ChiNhanh (10 records)
│   ├── CN01: TP.HCM
│   ├── CN02: Đà Nẵng
│   └── ...
│
├── PhongBan (10 records)
│   ├── PB01: Phòng Marketing
│   ├── PB02: Phòng IT
│   └── ...
│
├── DuAn (10 records)
│   ├── DA01: Dự án A
│   └── ...
│
├── ChucVu (10 records)
│   ├── CV01: Giám đốc
│   ├── CV02: Trưởng phòng
│   └── ...
│
├── NhanVien (40 records)
│   ├── NV01: Nguyễn Văn A
│   ├── NV02: Trần Thị B
│   └── ...
│
├── Luong (40 records)
│   ├── Lương của NV01: 20,000,000đ
│   └── ...
│
└── ChinhSach (10 records)
    ├── CS01: Chính sách nghỉ phép
    └── ...
```

### Mối quan hệ giữa các bảng:

```
TruSoChinh
    ↓ (có nhiều)
ChiNhanh
    ↓ (có nhiều)
PhongBan
    ↓ (có nhiều)
NhanVien ←── ChucVu
    ↓ (có nhiều)       ↓ (thuộc về)
Luong              DuAn
```

**Giải thích:**
- 1 Trụ sở có nhiều Chi nhánh
- 1 Chi nhánh có nhiều Phòng ban
- 1 Phòng ban có nhiều Nhân viên
- 1 Nhân viên có 1 Chức vụ
- 1 Nhân viên có nhiều bản ghi Lương (mỗi tháng 1 bản)
- 1 Nhân viên làm 1 Dự án

---

## 8️⃣ CÔNG NGHỆ SỬ DỤNG

### Tổng quan:

| Công nghệ | Phiên bản | Mục đích |
|-----------|-----------|----------|
| **Ubuntu Linux** | 22.04+ | Hệ điều hành |
| **Docker** | 20.10+ | Container platform |
| **SQL Server** | 2019 | Database engine |
| **Bash** | 5.0+ | Scripts automation |
| **Git** | 2.0+ | Version control |

### Lý do chọn:

**1. Ubuntu Linux:**
- Miễn phí
- Ổn định
- Phù hợp với Docker

**2. Docker:**
- Setup nhanh (30 phút vs 10 giờ)
- Dễ dàng xóa/tạo lại
- Giống production environment

**3. SQL Server 2019:**
- Hỗ trợ distributed database tốt
- Có nhiều features:
  - Linked Servers (kết nối giữa các DB)
  - Replication (đồng bộ dữ liệu)
  - Transactions (giao dịch)
  - Views, Procedures, Functions

---

## 9️⃣ GLOSSARY (BẢNG THUẬT NGỮ)

### Thuật ngữ Database:

| Thuật ngữ | Tiếng Anh | Giải thích đơn giản |
|-----------|-----------|---------------------|
| CSDL | Database | Kho chứa dữ liệu |
| Bảng | Table | Ngăn trong tủ hồ sơ |
| Hàng/Bản ghi | Row/Record | Một hồ sơ cụ thể |
| Cột/Trường | Column/Field | Thông tin trong hồ sơ |
| Khóa chính | Primary Key | Số định danh duy nhất |
| Khóa ngoại | Foreign Key | Liên kết giữa các bảng |
| Truy vấn | Query | Câu hỏi hỏi database |
| Giao dịch | Transaction | Nhóm các thao tác |

### Thuật ngữ Phân tán:

| Thuật ngữ | Tiếng Anh | Giải thích |
|-----------|-----------|------------|
| Phân mảnh | Fragmentation | Chia nhỏ dữ liệu |
| Phân mảnh ngang | Horizontal Frag. | Chia theo hàng |
| Phân mảnh dọc | Vertical Frag. | Chia theo cột |
| Đồng bộ | Replication | Copy dữ liệu giữa sites |
| Liên kết | Linked Server | Kết nối giữa các DB |

### Thuật ngữ Docker:

| Thuật ngữ | Giải thích |
|-----------|------------|
| Image | Bản thiết kế, khuôn mẫu |
| Container | Ứng dụng đang chạy |
| Volume | Nơi lưu dữ liệu |
| Network | Mạng kết nối containers |
| docker-compose | Công cụ quản lý nhiều containers |

### Thuật ngữ SQL:

| Lệnh | Mục đích | Ví dụ |
|------|----------|-------|
| SELECT | Xem dữ liệu | `SELECT * FROM NhanVien` |
| INSERT | Thêm dữ liệu | `INSERT INTO ...` |
| UPDATE | Sửa dữ liệu | `UPDATE NhanVien SET ...` |
| DELETE | Xóa dữ liệu | `DELETE FROM ...` |
| CREATE | Tạo table | `CREATE TABLE ...` |
| DROP | Xóa table | `DROP TABLE ...` |

---

## 🎯 KIỂM TRA HIỂU BÀI

### Câu hỏi tự kiểm tra:

1. **Database là gì?**
   <details>
   <summary>Đáp án</summary>
   Kho chứa thông tin có tổ chức, giống như tủ hồ sơ
   </details>

2. **Database phân tán khác gì database thường?**
   <details>
   <summary>Đáp án</summary>
   Chia database ra nhiều nơi thay vì tập trung một chỗ
   </details>

3. **Docker là gì?**
   <details>
   <summary>Đáp án</summary>
   Công cụ đóng gói ứng dụng vào "container" để chạy dễ dàng
   </details>

4. **Project này giải quyết vấn đề gì?**
   <details>
   <summary>Đáp án</summary>
   Quản lý nhân viên cho công ty có nhiều chi nhánh
   </details>

5. **Hệ thống có bao nhiêu sites?**
   <details>
   <summary>Đáp án</summary>
   3 sites: HANOI, DANANG, SAIGON
   </details>

---

## ✅ CHECKLIST: BẠN ĐÃ HIỂU CHƯA?

Đánh dấu ✅ vào những gì bạn đã hiểu:

- [ ] Tôi hiểu database là gì
- [ ] Tôi hiểu database phân tán là gì
- [ ] Tôi hiểu SQL và SQL Server
- [ ] Tôi hiểu Docker là gì
- [ ] Tôi hiểu project này làm gì
- [ ] Tôi hiểu kiến trúc hệ thống
- [ ] Tôi hiểu các thuật ngữ cơ bản

**Nếu chưa hiểu hết:** Đọc lại phần đó hoặc Google thêm!

---

## 📖 BƯỚC TIẾP THEO

```
✅ Đã đọc xong file này
↓
👉 Đọc tiếp: 02-DANH-SACH-FILE.md
```

Trong file tiếp theo, bạn sẽ biết:
- Folder BTL-CSDLPT-PTIT có những file gì?
- Mỗi file làm gì?
- File nào quan trọng nhất?

---

**Chúc mừng! Bạn đã hoàn thành phần kiến thức cơ bản! 🎉**
