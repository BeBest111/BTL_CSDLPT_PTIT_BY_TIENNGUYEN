# 🎤 CHUẨN BỊ BẢO VỆ ĐỒ ÁN
## Hướng dẫn chi tiết từng bước - FILE QUAN TRỌNG NHẤT!

---

## 🎯 MỤC TIÊU

Sau khi đọc file này, bạn sẽ:
- Biết cần chuẩn bị gì
- Demo được trước giảng viên  
- Trả lời được câu hỏi
- Tự tin bảo vệ thành công!

---

## ⏰ TIMELINE CHUẨN BỊ

### 1 TUẦN TRƯỚC (Ngày -7):
- [ ] Đọc hết 12 files hướng dẫn này
- [ ] Hiểu được project làm gì
- [ ] Test setup trên máy

### 3 NGÀY TRƯỚC (Ngày -3):
- [ ] Tập demo ít nhất 3 lần
- [ ] Chuẩn bị slides
- [ ] Viết script trình bày

### 1 NGÀY TRƯỚC (Ngày -1):
- [ ] Check hệ thống lần cuối
- [ ] Backup database
- [ ] Ôn câu hỏi thường gặp
- [ ] Ngủ đủ giấc!

### NGÀY BẢO VỆ:
- [ ] Đến sớm 30 phút
- [ ] Test máy chiếu/laptop
- [ ] Khởi động Docker
- [ ] Thở sâu, tự tin!

---

## 💻 CHUẨN BỊ KỸ THUẬT

### 1. Laptop/Máy tính:
```
✅ Đã cài Docker
✅ Đã test chạy được
✅ Pin đầy/có sạc
✅ Không bị lag
```

### 2. Phần mềm cần có:
```
✅ Docker Desktop (running)
✅ Terminal/Command Prompt
✅ Text editor (để show code)
✅ Browser (để show docs)
✅ SSMS hoặc Azure Data Studio (optional nhưng tốt)
```

### 3. Commands chuẩn bị sẵn:
Tạo file `demo-commands.txt`:

```bash
# 1. Kiểm tra containers
sudo docker ps

# 2. Kiểm tra database
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT COUNT(*) FROM QuanLyNhanSu.dbo.NhanVien"

# 3. Test Linked Server
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT * FROM SITE_DANANG.QuanLyNhanSu.dbo.ChiNhanh"

# 4. Monitor
./docker-monitor.sh
```

---

## 📊 CHUẨN BỊ SLIDES

### Cấu trúc slides đề xuất (15-20 slides):

**Slide 1: Title**
- Tên đề tài
- Nhóm số mấy
- Thành viên

**Slide 2-3: Giới thiệu**
- Bài toán
- Tại sao cần database phân tán?

**Slide 4-5: Kiến trúc**
- Sơ đồ 3 sites
- Docker containers
- Network topology

**Slide 6-8: Database**
- 8 tables
- Relationships
- Sample data (131 records)

**Slide 9-12: Features**
- 14 Views
- 6 Procedures
- 6 Functions
- 4 Triggers

**Slide 13-14: Demo**
- Screenshots
- Query results

**Slide 15: Kết quả**
- Đã hoàn thành 95%
- Features làm được
- Limitations

**Slide 16: Q&A**

---

## 🎭 KỊCH BẢN DEMO (10-15 phút)

### PHẦN 1: Giới thiệu (2 phút)
**Nói:**
> "Xin chào thầy/cô. Em là [tên], thành viên nhóm [số].
> Đề tài của nhóm em là 'Quản lý nhân viên công ty đa chi nhánh'.
> Hệ thống sử dụng database phân tán với 3 sites: Hà Nội, Đà Nẵng, Sài Gòn."

**Show:** Slide kiến trúc

---

### PHẦN 2: Show Containers (1 phút)
**Nói:**
> "Em sử dụng Docker để triển khai 3 SQL Server containers.
> Đây là 3 containers đang chạy..."

**Chạy:**
```bash
sudo docker ps
```

**Show output:**
```
NAMES         STATUS    PORTS
SITE_HANOI    Up        0.0.0.0:1433->1433/tcp
SITE_DANANG   Up        0.0.0.0:1434->1433/tcp
SITE_SAIGON   Up        0.0.0.0:1435->1433/tcp
```

---

### PHẦN 3: Show Database (2 phút)
**Nói:**
> "Database QuanLyNhanSu có 8 tables chính với 131 records.
> Cho em kiểm tra dữ liệu..."

**Chạy:**
```bash
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; 
      SELECT 'NhanVien' AS TableName, COUNT(*) AS Total FROM NhanVien
      UNION ALL SELECT 'ChiNhanh', COUNT(*) FROM ChiNhanh
      UNION ALL SELECT 'PhongBan', COUNT(*) FROM PhongBan"
```

**Show output:**
```
TableName    Total
NhanVien     40
ChiNhanh     10
PhongBan     10
```

---

### PHẦN 4: Demo Linked Server (2 phút)
**Nói:**
> "Em đã cấu hình Linked Server giữa các sites.
> Từ Hà Nội có thể query dữ liệu ở Đà Nẵng..."

**Chạy:**
```bash
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT 'HANOI' AS Site, COUNT(*) FROM QuanLyNhanSu.dbo.NhanVien
      UNION ALL 
      SELECT 'DANANG', COUNT(*) FROM SITE_DANANG.QuanLyNhanSu.dbo.NhanVien
      UNION ALL
      SELECT 'SAIGON', COUNT(*) FROM SITE_SAIGON.QuanLyNhanSu.dbo.NhanVien"
```

---

### PHẦN 5: Demo Views (2 phút)
**Nói:**
> "Em có tạo 14 views cho phân mảnh và báo cáo.
> Ví dụ view phân mảnh theo chi nhánh..."

**Show code:** View_NhanVien_CN01

---

### PHẦN 6: Demo Procedures (2 phút)
**Nói:**
> "Em có 6 stored procedures quản lý nghiệp vụ.
> Ví dụ thêm nhân viên mới..."

**Show code:** sp_ThemNhanVien

---

### PHẦN 7: Monitoring (1 phút)
**Nói:**
> "Em có script monitoring real-time..."

**Chạy:**
```bash
./docker-monitor.sh
```

**Giải thích output**

---

### PHẦN 8: Kết luận (1 phút)
**Nói:**
> "Tổng kết, nhóm em đã hoàn thành:
> - 100% core functionality
> - 8 tables, 131 records
> - 14 views, 6 procedures, 6 functions, 4 triggers
> - 3-site distributed architecture với Linked Servers
> 
> Hạn chế: Do dùng Docker nên không có full SQL Server Replication.
> Nhưng đã implement workaround với Linked Server queries.
> 
> Em xin cảm ơn và sẵn sàng trả lời câu hỏi!"

---

## ❓ CÂU HỎI THƯỜNG GẶP & TRẢ LỜI MẪU

### Q1: "Tại sao dùng Docker thay vì VirtualBox?"
**Trả lời:**
> "Thưa thầy/cô, em chọn Docker vì:
> 1. Setup nhanh hơn (30 phút vs 10 giờ)
> 2. Nhẹ hơn (8GB RAM vs 16GB)
> 3. Dễ reproduce và demo
> 4. Tiết kiệm tài nguyên
> 
> Nhược điểm là không có full SQL Server Replication,
> nhưng em đã implement Linked Server để query phân tán."

---

### Q2: "Database phân tán khác gì database thường?"
**Trả lời:**
> "Database phân tán chia dữ liệu ra nhiều sites:
> - Tăng availability: 1 site hỏng, các site khác vẫn hoạt động
> - Tăng performance: User truy cập DB gần nhất
> - Scale tốt hơn: Thêm sites dễ dàng
> 
> Database thường tập trung 1 chỗ, dễ bị single point of failure."

---

### Q3: "Giải thích Linked Server?"
**Trả lời:**
> "Linked Server cho phép:
> - Query dữ liệu từ DB khác
> - Ví dụ: Từ HANOI query data ở DANANG
> - Syntax: SELECT * FROM SITE_DANANG.QuanLyNhanSu.dbo.Table
> 
> Em đã config 2 linked servers:
> - HANOI → DANANG
> - HANOI → SAIGON"

---

### Q4: "Phân mảnh ngang là gì?"
**Trả lời:**
> "Phân mảnh ngang là chia table theo HÀNG.
> Ví dụ table NhanVien:
> - View_NhanVien_CN01: Chỉ nhân viên chi nhánh 01
> - View_NhanVien_CN02: Chỉ nhân viên chi nhánh 02
> 
> Em có 8 views phân mảnh:
> - 5 views theo chi nhánh (CN01-05)
> - 3 views theo mức lương (Cao/Trung/Cơ bản)"

---

### Q5: "Trigger làm gì?"
**Trả lời:**
> "Trigger tự động chạy khi có event.
> Em có 4 triggers:
> 
> 1. trg_KiemTraTuoiNhanVien: 
>    - Chặn INSERT nếu tuổi < 18
> 
> 2. trg_LogXoaNhanVien:
>    - Lưu log khi XÓA nhân viên
> 
> 3. trg_KiemTraMucLuong:
>    - Chặn nếu lương <= 0
> 
> 4. trg_LogCapNhatLuong:
>    - Audit log khi UPDATE lương"

---

### Q6: "Transaction là gì?"
**Trả lời:**
> "Transaction là nhóm các operations:
> - Tất cả thành công HOẶC tất cả rollback
> - ACID properties
> 
> Ví dụ: Chuyển nhân viên sang phòng khác
> BEGIN TRANSACTION;
>   UPDATE NhanVien SET PhongBan = 'PB02';
>   INSERT INTO LogChuyenPhong VALUES (...);
> COMMIT;
> 
> Nếu bất kỳ lệnh nào lỗi → ROLLBACK tất cả."

---

### Q7: "Index để làm gì?"
**Trả lời:**
> "Index tăng tốc độ query.
> Giống như mục lục sách.
> 
> Em có 12+ indexes:
> - Clustered index: Primary Keys
> - Non-clustered: Foreign Keys
> - Covering index: Cho queries thường dùng
> 
> Ví dụ: Index trên NhanVien.ID_ChiNhanh
> → Query theo chi nhánh nhanh hơn."

---

### Q8: "Stored Procedure vs Function?"
**Trả lời:**
> "Procedure:
> - Thực thi business logic
> - Có thể INSERT/UPDATE/DELETE
> - Gọi: EXEC sp_ThemNhanVien
> 
> Function:
> - Tính toán, return giá trị
> - Chỉ SELECT
> - Gọi: SELECT dbo.fn_TinhTuoi(...)
> 
> Em dùng Procedure cho CRUD,
> Function cho calculations/statistics."

---

### Q9: "View là gì?"
**Trả lời:**
> "View là virtual table, query được lưu lại.
> 
> Lợi ích:
> - Đơn giản hóa queries phức tạp
> - Security: Ẩn columns nhạy cảm
> - Phân mảnh dữ liệu
> 
> Em có 14 views:
> - 8 views phân mảnh
> - 6 views báo cáo"

---

### Q10: "Làm sao đồng bộ dữ liệu giữa các sites?"
**Trả lời:**
> "Trong production: SQL Server Replication
> 
> Em dùng Docker Linux nên không có Replication.
> Workaround:
> 1. Chạy cùng script trên cả 3 sites
> 2. Dùng Linked Server queries
> 3. Manual sync qua scripts
> 
> Nếu dùng VirtualBox + Windows → Có full Replication."

---

## ⚠️ LỖI THƯỜNG GẶP & CÁCH XỬ LÝ

### Lỗi 1: Docker không chạy
**Triệu chứng:** `Cannot connect to Docker daemon`  
**Fix:**
```bash
sudo systemctl start docker
sudo docker ps
```

---

### Lỗi 2: Container không start
**Triệu chứng:** Container status = Exited  
**Fix:**
```bash
sudo docker logs SITE_HANOI
sudo docker restart SITE_HANOI
```

---

### Lỗi 3: SQL Server chưa sẵn sàng
**Triệu chứng:** Connection refused  
**Fix:**
```bash
# Chờ 60 giây
sleep 60

# Test lại
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C -Q "SELECT 1"
```

---

### Lỗi 4: Quên password
**Fix:** Password là: `Admin@123456`

---

### Lỗi 5: Demo bị lag
**Chuẩn bị trước:**
- Chạy commands trước, copy output
- Tạo screenshots sẵn
- Có backup plan: Show slides thay vì live demo

---

## 📝 CHECKLIST TRƯỚC KHI BẢO VỆ

### 1 GIỜ TRƯỚC:
- [ ] Laptop pin đầy
- [ ] Docker đang chạy
- [ ] Containers đang UP
- [ ] Database có dữ liệu
- [ ] Test queries thành công
- [ ] Slides sẵn sàng
- [ ] Adapter HDMI/VGA có
- [ ] Backup USB (phòng hờ)

### CHECKLIST TECHNICAL:
```bash
# Run all checks:
sudo docker ps | grep -E "HANOI|DANANG|SAIGON"
→ All should be "Up"

sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT COUNT(*) FROM QuanLyNhanSu.dbo.NhanVien"
→ Should return 40

sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT name FROM sys.servers WHERE server_id > 0"
→ Should show SITE_DANANG, SITE_SAIGON
```

---

## 💡 MẸO THÀNH CÔNG

### 1. Tự tin:
- Bạn đã làm được rồi!
- Hiểu rõ project
- Đã tập demo nhiều lần

### 2. Giọng nói:
- Nói rõ ràng, đủ lớn
- Không nói quá nhanh
- Pause sau mỗi ý quan trọng

### 3. Body language:
- Đứng thẳng, nhìn giảng viên
- Không khoanh tay
- Tay chỉ vào màn hình khi giải thích

### 4. Xử lý câu hỏi:
- Nghe kỹ câu hỏi
- Suy nghĩ 2-3 giây
- Trả lời rõ ràng
- "Em xin phép suy nghĩ một chút" là OK!
- Không biết thì thành thật: "Em chưa tìm hiểu phần này"

### 5. Time management:
- Tập demo trong 10-15 phút
- Để 5-10 phút cho Q&A
- Đừng nói quá lâu 1 phần

---

## 🎯 MỤC TIÊU CUỐI CÙNG

Sau khi bảo vệ thành công:

✅ Trình bày rõ ràng  
✅ Demo hoạt động  
✅ Trả lời được câu hỏi  
✅ Thể hiện hiểu bài  
✅ **ĐIỂM CAO!** 🎉

---

## 📖 FILES LIÊN QUAN

- `10-KICH-BAN-DEMO.md` - Kịch bản demo chi tiết hơn
- `11-CAU-HOI-THUONG-GAP.md` - Thêm nhiều câu hỏi
- `12-CHECKLIST-CUOI-CUNG.md` - Final checklist

---

**Chúc bạn bảo vệ thành công! Tin tưởng vào bản thân! 💪**
