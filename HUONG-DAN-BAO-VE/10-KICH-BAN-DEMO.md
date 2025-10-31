# 🎬 KỊCH BẢN DEMO CHI TIẾT
## Script trình bày từng bước với timing

---

## ⏰ TIMELINE (15 phút total)

```
00:00 - 02:00  →  Giới thiệu
02:00 - 03:00  →  Show containers
03:00 - 05:00  →  Kiểm tra database
05:00 - 07:00  →  Demo Linked Server
07:00 - 09:00  →  Demo Views
09:00 - 11:00  →  Demo Procedures/Functions
11:00 - 12:30  →  Demo Triggers
12:30 - 14:00  →  Monitoring
14:00 - 15:00  →  Kết luận
```

---

## 📝 SCRIPT CHI TIẾT

### [00:00 - 02:00] PHẦN 1: GIỚI THIỆU

**[Slide 1: Title]**

**Nói:**
> "Xin chào thầy/cô và các bạn!
> 
> Em là [Tên bạn], thành viên nhóm [số].
> 
> Hôm nay nhóm em xin trình bày đề tài:
> **'Hệ thống quản lý nhân viên công ty đa chi nhánh
> sử dụng cơ sở dữ liệu phân tán'**"

**[Pause 2 giây]**

---

**[Slide 2: Bài toán]**

**Nói:**
> "Đề tài của nhóm em giải quyết bài toán thực tế:
> 
> Một công ty có nhiều chi nhánh trên toàn quốc,
> cần quản lý thông tin nhân viên, phòng ban, dự án, và lương.
> 
> Với database phân tán, mỗi chi nhánh có database riêng,
> nhưng vẫn có thể truy vấn dữ liệu từ các chi nhánh khác."

---

**[Slide 3: Kiến trúc]**

**Nói:**
> "Hệ thống của nhóm em có kiến trúc 3 sites:
> - Site Hà Nội (port 1433)
> - Site Đà Nẵng (port 1434)
> - Site Sài Gòn (port 1435)
> 
> Mỗi site chạy SQL Server 2019 trong Docker container.
> 
> Các sites kết nối với nhau qua Linked Servers,
> cho phép query phân tán giữa các chi nhánh."

**[Point vào sơ đồ]**

---

### [02:00 - 03:00] PHẦN 2: SHOW CONTAINERS

**Nói:**
> "Bây giờ em sẽ demo hệ thống đang chạy.
> 
> Đầu tiên, kiểm tra các Docker containers..."

---

**[Chuyển sang Terminal]**

**Chạy lệnh:**
```bash
sudo docker ps
```

**[Đợi output]**

---

**[Point vào output]**

**Nói:**
> "Như các thầy cô thấy, em có 3 containers đang chạy:
> 
> SITE_HANOI - Up - Listening trên port 1433
> SITE_DANANG - Up - Listening trên port 1434
> SITE_SAIGON - Up - Listening trên port 1435
> 
> Tất cả đều status 'Up' và healthy."

---

### [03:00 - 05:00] PHẦN 3: KIỂM TRA DATABASE

**Nói:**
> "Tiếp theo, em kiểm tra database QuanLyNhanSu..."

---

**Chạy lệnh:**
```bash
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT 'NhanVien' AS TableName, COUNT(*) AS Total FROM NhanVien UNION ALL SELECT 'ChiNhanh', COUNT(*) FROM ChiNhanh UNION ALL SELECT 'PhongBan', COUNT(*) FROM PhongBan"
```

---

**[Point vào output]**

**Nói:**
> "Database có dữ liệu:
> - 40 nhân viên
> - 10 chi nhánh
> - 10 phòng ban
> 
> Tổng cộng 131 records sample data."

---

**Chạy thêm:**
```bash
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT TOP 5 HoTen, Email, TenChucVu=cv.TenChucVu FROM NhanVien nv JOIN ChucVu cv ON nv.ID_ChucVu=cv.ID_ChucVu"
```

**Nói:**
> "Đây là 5 nhân viên đầu tiên trong database."

---

### [05:00 - 07:00] PHẦN 4: DEMO LINKED SERVER

**[Slide 4: Linked Server]**

**Nói:**
> "Phần quan trọng của database phân tán là Linked Server.
> 
> Linked Server cho phép query dữ liệu từ site khác.
> Em đã cấu hình:
> - SITE_HANOI → SITE_DANANG
> - SITE_HANOI → SITE_SAIGON"

---

**[Chuyển Terminal]**

**Chạy lệnh:**
```bash
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT name FROM sys.servers WHERE server_id > 0"
```

**Nói:**
> "Đây là các linked servers đã config."

---

**Chạy query phân tán:**
```bash
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT 'HANOI' AS Site, COUNT(*) AS SoNhanVien FROM QuanLyNhanSu.dbo.NhanVien UNION ALL SELECT 'DANANG', COUNT(*) FROM SITE_DANANG.QuanLyNhanSu.dbo.NhanVien UNION ALL SELECT 'SAIGON', COUNT(*) FROM SITE_SAIGON.QuanLyNhanSu.dbo.NhanVien"
```

---

**[Point vào output]**

**Nói:**
> "Như thầy cô thấy, từ HANOI em query được:
> - Số nhân viên ở HANOI: 40
> - Số nhân viên ở DANANG: 40  
> - Số nhân viên ở SAIGON: 40
> 
> Đây chính là distributed query - 
> truy vấn phân tán giữa các sites."

---

### [07:00 - 09:00] PHẦN 5: DEMO VIEWS

**[Slide 5: Views]**

**Nói:**
> "Nhóm em đã implement 14 views:
> - 8 views phân mảnh (fragmentation)
> - 6 views báo cáo (reporting)"

---

**[Chạy query view phân mảnh]**
```bash
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT * FROM View_NhanVien_CN01"
```

**Nói:**
> "View này chỉ hiển thị nhân viên chi nhánh CN01.
> Đây là phân mảnh ngang - chia table theo điều kiện."

---

**[Show code view - mở editor]**

```sql
CREATE VIEW View_NhanVien_CN01 AS
SELECT * FROM NhanVien
WHERE ID_ChiNhanh = 'CN01';
```

**Nói:**
> "View rất đơn giản nhưng hiệu quả.
> Em có 5 views tương tự cho 5 chi nhánh."

---

**[Chạy view báo cáo]**
```bash
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT * FROM View_ThongKeNhanVienTheoPhongBan"
```

**Nói:**
> "View báo cáo này thống kê số nhân viên mỗi phòng ban,
> tính tổng lương, trung bình lương.
> Dùng để quản lý nhân sự."

---

### [09:00 - 11:00] PHẦN 6: DEMO PROCEDURES & FUNCTIONS

**[Slide 6: Stored Procedures]**

**Nói:**
> "Nhóm em có 6 stored procedures quản lý nghiệp vụ:
> - Thêm nhân viên
> - Sửa thông tin
> - Xóa nhân viên
> - Tính lương
> - Tìm kiếm
> - Báo cáo"

---

**[Show code procedure]**

```sql
CREATE PROCEDURE sp_ThemNhanVien
    @ID_NhanVien VARCHAR(10),
    @HoTen NVARCHAR(100),
    @NgaySinh DATE,
    -- ...more params
AS
BEGIN
    -- Validation
    IF @NgaySinh > GETDATE()
        THROW 50001, 'Ngày sinh không hợp lệ', 1;
    
    -- Insert
    INSERT INTO NhanVien VALUES (...)
END
```

**Nói:**
> "Procedure này thêm nhân viên mới với validation.
> Nếu ngày sinh không hợp lệ → Throw error."

---

**[Chạy procedure]**
```bash
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "EXEC QuanLyNhanSu.dbo.sp_ThongKeNhanVien"
```

**Nói:**
> "Procedure này trả về thống kê tổng quan:
> Tổng số nhân viên, số phòng ban, số dự án..."

---

**[Slide 7: Functions]**

**Nói:**
> "Nhóm em có 6 functions:
> - Tính tuổi
> - Tính thâm niên
> - Tính tổng lương phòng ban
> - Đếm nhân viên
> - Get thông tin
> - Tính trung bình"

---

**[Chạy function]**
```bash
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT dbo.fn_TinhTuoi('1990-05-15') AS Tuoi"
```

**Nói:**
> "Function này tính tuổi từ ngày sinh.
> Rất hữu ích cho báo cáo và validation."

---

### [11:00 - 12:30] PHẦN 7: DEMO TRIGGERS

**[Slide 8: Triggers]**

**Nói:**
> "Triggers tự động thực thi khi có event.
> Em có 4 triggers:
> 
> 1. Kiểm tra tuổi khi INSERT nhân viên
> 2. Log khi XÓA nhân viên
> 3. Kiểm tra mức lương hợp lệ
> 4. Audit log khi UPDATE lương"

---

**[Show code trigger]**

```sql
CREATE TRIGGER trg_KiemTraTuoiNhanVien
ON NhanVien
INSTEAD OF INSERT
AS
BEGIN
    IF EXISTS (SELECT 1 FROM inserted WHERE DATEDIFF(YEAR, NgaySinh, GETDATE()) < 18)
    BEGIN
        THROW 50002, 'Nhân viên phải đủ 18 tuổi', 1;
    END
    ELSE
    BEGIN
        INSERT INTO NhanVien SELECT * FROM inserted;
    END
END
```

**Nói:**
> "Trigger này chặn INSERT nếu nhân viên dưới 18 tuổi."

---

**[Test trigger - nếu có thời gian]**
```bash
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT * FROM AuditLog_Luong"
```

**Nói:**
> "Audit log ghi lại tất cả thay đổi lương.
> Đảm bảo transparency và traceability."

---

### [12:30 - 14:00] PHẦN 8: MONITORING

**Nói:**
> "Cuối cùng, em có monitoring script real-time..."

---

**[Chạy script]**
```bash
./docker-monitor.sh
```

**[Đợi 5 giây]**

---

**[Point vào output]**

**Nói:**
> "Script này hiển thị:
> - Status các containers
> - Memory usage
> - Database connections
> - Latest queries
> - Performance metrics
> 
> Cập nhật real-time mỗi 5 giây."

**[Nhấn Ctrl+C để dừng]**

---

### [14:00 - 15:00] PHẦN 9: KẾT LUẬN

**[Slide cuối: Tổng kết]**

**Nói:**
> "Tổng kết, nhóm em đã hoàn thành:
> 
> ✅ **Database:**
> - 8 tables + 2 audit logs
> - 131 sample records
> - Normalized design
> 
> ✅ **Business Logic:**
> - 14 views (phân mảnh + báo cáo)
> - 6 stored procedures
> - 6 functions
> - 4 triggers
> - 12+ indexes
> 
> ✅ **Distributed System:**
> - 3 SQL Server sites
> - Docker containerization
> - Linked Servers
> - Cross-site queries
> 
> ✅ **Automation:**
> - One-click deployment
> - Monitoring scripts
> - Backup scripts
> 
> ✅ **Documentation:**
> - 15 files (~150 pages)
> - Beginner guides
> - API references"

---

**[Pause]**

**Nói:**
> "**Hạn chế:**
> Do sử dụng Docker Linux nên không có full SQL Server Replication.
> Nhưng nhóm em đã implement workaround với Linked Server
> để thực hiện distributed queries.
> 
> Nếu triển khai production với Windows Server,
> sẽ có đầy đủ Replication features."

---

**[Slide cuối cùng: Thank you]**

**Nói:**
> "Em xin cảm ơn thầy/cô và các bạn đã lắng nghe!
> 
> Em sẵn sàng trả lời các câu hỏi!"

**[Cúi chào]**

---

## 🎯 BACKUP PLANS

### Nếu Docker lỗi:
- Show screenshots đã chuẩn bị
- Giải thích qua slides
- Show code trong text editor

### Nếu queries chậm:
- Đã copy output trước
- Paste từ file text

### Nếu hết thời gian:
- Skip phần monitoring
- Hoặc skip chi tiết functions

### Nếu máy chiếu lỗi:
- Demo trên laptop
- Mời giảng viên lại gần xem

---

## 📋 CHECKLIST TRƯỚC KHI DEMO

**30 phút trước:**
- [ ] Laptop pin đầy
- [ ] Docker running: `sudo docker ps`
- [ ] Database có data: Test query
- [ ] Linked servers OK
- [ ] Scripts có sẵn
- [ ] Slides mở sẵn

**10 phút trước:**
- [ ] Adapter HDMI connect
- [ ] Test màn hình chiếu
- [ ] Terminal sẵn sàng
- [ ] Browser tabs mở sẵn
- [ ] Volume đủ lớn

**Ngay trước demo:**
- [ ] Thở sâu 3 lần
- [ ] Uống nước
- [ ] Mỉm cười
- [ ] TỰ TIN!

---

## 💡 TIPS THUYẾT TRÌNH

1. **Nói chậm, rõ ràng**
   - Pause giữa các câu
   - Nhấn mạnh từ khóa
   
2. **Eye contact**
   - Nhìn giảng viên
   - Scan cả phòng
   
3. **Body language**
   - Đứng thẳng
   - Tay chỉ vào slides
   - Không khoanh tay
   
4. **Xử lý lỗi**
   - Bình tĩnh
   - "Em xin thử lại"
   - Chuyển sang backup plan
   
5. **Time management**
   - Nhìn đồng hồ
   - Có thể skip chi tiết
   - Để thời gian Q&A

---

**Chúc demo thành công! You got this! 🚀**
