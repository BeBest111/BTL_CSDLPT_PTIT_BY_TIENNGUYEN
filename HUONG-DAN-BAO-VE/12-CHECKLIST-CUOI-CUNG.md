# ✅ CHECKLIST CUỐI CÙNG TRƯỚC BẢO VỆ
## Kiểm tra từng bước - Không bỏ sót!

---

## 🎯 MỤC ĐÍCH

File này giúp bạn:
- Kiểm tra đầy đủ trước ngày bảo vệ
- Không quên gì
- Tự tin 100%

---

## 📅 TIMELINE CHECKLIST

### ⏰ 1 TUẦN TRƯỚC

**Kiến thức:**
- [ ] Đọc hết 12 files hướng dẫn
- [ ] Hiểu rõ database phân tán là gì
- [ ] Hiểu Docker containers
- [ ] Biết Linked Server hoạt động như thế nào
- [ ] Nắm 8 tables + relationships

**Kỹ thuật:**
- [ ] Docker đã cài và chạy được
- [ ] Test script `docker-complete-setup.sh`
- [ ] Verify 3 containers UP
- [ ] Test queries thành công
- [ ] Linked Servers working

**Slides:**
- [ ] Tạo PowerPoint (~15-20 slides)
- [ ] Sơ đồ kiến trúc
- [ ] Screenshots
- [ ] Code examples

---

### ⏰ 3 NGÀY TRƯỚC

**Demo:**
- [ ] Tập demo lần 1 (record video)
- [ ] Xem lại video, note lỗi
- [ ] Tập demo lần 2 (cải thiện)
- [ ] Tập demo lần 3 (hoàn thiện)
- [ ] Timing: 12-15 phút

**Script:**
- [ ] Viết demo script chi tiết
- [ ] Prepare commands file
- [ ] Backup screenshots
- [ ] Test trên máy khác (nếu có)

**Q&A:**
- [ ] Đọc 50 câu hỏi trong file 11
- [ ] Tự hỏi tự trả lời
- [ ] Nhờ bạn hỏi thử
- [ ] Note câu khó

---

### ⏰ 1 NGÀY TRƯỚC

**Technical:**
- [ ] Backup database (docker-backup.sh)
- [ ] Test lại tất cả commands
- [ ] Verify ports: 1433, 1434, 1435
- [ ] Check disk space (>10GB free)
- [ ] Docker auto-start enabled

**Laptop:**
- [ ] Laptop pin đầy
- [ ] Charger có sẵn
- [ ] Adapter HDMI/VGA ready
- [ ] Mouse (optional)
- [ ] Backup USB với:
  - [ ] Project folder
  - [ ] Slides PDF
  - [ ] Screenshots
  - [ ] Demo video backup

**Slides:**
- [ ] Review lần cuối
- [ ] Spelling/grammar
- [ ] Transitions smooth
- [ ] Timing OK
- [ ] Export to PDF (backup)

**Personal:**
- [ ] Ngủ đủ giấc (7-8 tiếng)
- [ ] Quần áo lịch sự sẵn sàng
- [ ] Đồ ăn nhẹ (nếu cần)

---

### ⏰ SÁNG NGÀY BẢO VỆ

**1 giờ trước:**
- [ ] Laptop pin 100%
- [ ] Ăn sáng đủ
- [ ] Uống nước
- [ ] Đi vệ sinh
- [ ] Thư giãn 10 phút

**30 phút trước:**
- [ ] Đến phòng sớm
- [ ] Test máy chiếu
- [ ] Test HDMI/VGA connection
- [ ] Test volume
- [ ] Mở slides sẵn
- [ ] Mở terminal sẵn

**10 phút trước:**
- [ ] Start Docker
- [ ] Verify containers: `sudo docker ps`
- [ ] Test 1 query
- [ ] Thở sâu 5 lần
- [ ] Tự nhủ: "Mình đã sẵn sàng!"

---

## 🔧 TECHNICAL CHECKLIST

### Docker:
```bash
# 1. Docker running?
sudo systemctl status docker
→ Should be "active (running)"

# 2. Containers UP?
sudo docker ps
→ Should see 3 containers: SITE_HANOI, SITE_DANANG, SITE_SAIGON

# 3. Containers healthy?
sudo docker ps | grep Up
→ All should have "Up" status

# 4. Memory OK?
sudo docker stats --no-stream
→ Check memory usage < 80%
```

---

### Database:
```bash
# 1. Database exists?
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT name FROM sys.databases WHERE name='QuanLyNhanSu'"
→ Should return "QuanLyNhanSu"

# 2. Has data?
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT COUNT(*) FROM NhanVien"
→ Should return 40

# 3. Views exist?
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "USE QuanLyNhanSu; SELECT COUNT(*) FROM sys.views WHERE name LIKE 'View_%'"
→ Should return 14
```

---

### Linked Servers:
```bash
# 1. Linked servers configured?
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT name FROM sys.servers WHERE server_id > 0"
→ Should show SITE_DANANG, SITE_SAIGON

# 2. Can query remote site?
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
  -S localhost -U sa -P 'Admin@123456' -C \
  -Q "SELECT COUNT(*) FROM SITE_DANANG.QuanLyNhanSu.dbo.ChiNhanh"
→ Should return 10
```

---

### Network:
```bash
# 1. Network exists?
sudo docker network ls | grep distributed
→ Should see "distributed_db_network"

# 2. IPs assigned?
sudo docker inspect SITE_HANOI | grep IPAddress
→ Should show 172.20.0.11

# 3. Ports listening?
sudo netstat -tulpn | grep -E "1433|1434|1435"
→ Should see all 3 ports
```

---

## 📊 SLIDES CHECKLIST

### Cấu trúc:
- [ ] Slide 1: Title (Tên đề tài, nhóm, thành viên)
- [ ] Slide 2-3: Giới thiệu (Bài toán, mục tiêu)
- [ ] Slide 4-5: Kiến trúc (Sơ đồ 3 sites, Docker)
- [ ] Slide 6-8: Database (Tables, relationships, data)
- [ ] Slide 9-12: Features (Views, SPs, Functions, Triggers)
- [ ] Slide 13-14: Demo (Screenshots, results)
- [ ] Slide 15: Kết quả (Achievements, limitations)
- [ ] Slide 16: Q&A

### Nội dung:
- [ ] Font size >= 24pt (đọc được từ xa)
- [ ] Ít text, nhiều hình
- [ ] Màu sắc professional
- [ ] No typos
- [ ] Consistent style

### Technical:
- [ ] Save as .pptx và .pdf
- [ ] Test trên máy khác
- [ ] Animations không quá nhiều
- [ ] Videos embedded (nếu có)

---

## 💼 VẬT DỤNG CHECKLIST

### Bắt buộc:
- [ ] Laptop (pin đầy)
- [ ] Charger laptop
- [ ] Adapter HDMI
- [ ] Adapter VGA (phòng hờ)
- [ ] USB backup

### Khuyên dùng:
- [ ] Mouse
- [ ] Nước uống
- [ ] Giấy nháp + bút
- [ ] Kẹo ngậm (giúp giọng rõ)

### Documents:
- [ ] Slides (laptop + USB + cloud)
- [ ] Demo script in ra giấy
- [ ] Contact info (mentor, team)

---

## 🎤 DEMO CHECKLIST

### Preparation:
- [ ] Terminal mở sẵn
- [ ] Font size terminal lớn (đọc được từ xa)
- [ ] Commands copy sẵn file text
- [ ] Screenshots backup
- [ ] Browser tabs cần thiết mở sẵn

### Demo flow:
- [ ] Part 1: Intro (2 phút)
- [ ] Part 2: Show containers (1 phút)
- [ ] Part 3: Database check (2 phút)
- [ ] Part 4: Linked Server (2 phút)
- [ ] Part 5: Views (2 phút)
- [ ] Part 6: Procedures/Functions (2 phút)
- [ ] Part 7: Triggers (1.5 phút)
- [ ] Part 8: Monitoring (1.5 phút)
- [ ] Part 9: Conclusion (1 phút)

**Total: 15 phút**

---

## 🧠 KIẾN THỨC CHECKLIST

### Phải trả lời được:

**Cơ bản:**
- [ ] Database là gì?
- [ ] Primary Key vs Foreign Key?
- [ ] Index là gì?
- [ ] View là gì?
- [ ] Stored Procedure vs Function?
- [ ] Trigger là gì?
- [ ] Transaction là gì?

**Database phân tán:**
- [ ] Database phân tán khác gì database thường?
- [ ] Phân mảnh (fragmentation) là gì?
- [ ] Linked Server là gì?
- [ ] Replication là gì? (và tại sao em không có)
- [ ] Tại sao cần database phân tán?

**Docker:**
- [ ] Docker là gì?
- [ ] Container vs VM?
- [ ] Tại sao chọn Docker?
- [ ] Docker Compose là gì?

**SQL Server:**
- [ ] Tại sao chọn SQL Server?
- [ ] T-SQL là gì?
- [ ] System databases?

**Project:**
- [ ] Có bao nhiêu tables?
- [ ] Có bao nhiêu views/procedures/functions/triggers?
- [ ] Kiến trúc 3 sites như thế nào?
- [ ] Limitations của project?

---

## ⚠️ TROUBLESHOOTING CHECKLIST

### Nếu Docker không chạy:
```bash
sudo systemctl start docker
sudo systemctl status docker
```

### Nếu container không start:
```bash
sudo docker logs SITE_HANOI
sudo docker restart SITE_HANOI
```

### Nếu query lỗi:
- [ ] Có backup screenshots
- [ ] Có backup output text
- [ ] Có slides giải thích

### Nếu máy chiếu lỗi:
- [ ] Demo trên laptop
- [ ] Mời giảng viên lại gần

### Nếu quên password:
- [ ] Password: `Admin@123456`
- [ ] Username: `sa`

### Nếu quên command:
- [ ] Có file `demo-commands.txt`
- [ ] Có trong file hướng dẫn

---

## 🎯 SUCCESS CRITERIA

Sau khi bảo vệ, bạn đã:

**Technical:**
- [ ] Demo thành công (hoặc show backup)
- [ ] Containers đang chạy
- [ ] Queries trả về kết quả đúng
- [ ] Linked Server hoạt động

**Presentation:**
- [ ] Trình bày rõ ràng, tự tin
- [ ] Time management tốt (không quá 20 phút)
- [ ] Slides professional
- [ ] Giọng nói đủ lớn

**Q&A:**
- [ ] Trả lời được >= 80% câu hỏi
- [ ] Không hiểu thì nói "Em xin suy nghĩ"
- [ ] Honest về limitations

**Attitude:**
- [ ] Tự tin, không lo lắng
- [ ] Tôn trọng giảng viên
- [ ] Team work (nếu nhóm)

---

## 📝 FINAL PRE-DEFENSE RITUAL

**30 phút trước:**
1. Kiểm tra toàn bộ technical checklist
2. Test demo 1 lần nữa
3. Thở sâu 10 lần
4. Uống nước
5. Tự nhủ: "Mình đã chuẩn bị tốt!"

**10 phút trước:**
1. Đến phòng
2. Test máy chiếu
3. Open slides
4. Start Docker
5. Smile :)

**Ngay trước lúc bắt đầu:**
1. Thở sâu 3 lần
2. Uống một ngụm nước
3. Nhìn giảng viên, mỉm cười
4. Bắt đầu với tự tin!

---

## 💪 TỰ NHỦ CUỐI CÙNG

> "Tôi đã làm tốt đồ án này.
> Tôi đã chuẩn bị kỹ lưỡng.
> Tôi hiểu rõ những gì tôi làm.
> Tôi sẵn sàng trả lời câu hỏi.
> Tôi sẽ demo thành công.
> Tôi tự tin!
> 
> Let's do this! 🚀"

---

## 🎉 SAU KHI BẢO VỆ XONG

- [ ] Cảm ơn giảng viên
- [ ] Note feedback
- [ ] Celebrate với team! 🎊
- [ ] Backup code lên GitHub
- [ ] Rest & relax

---

## 📞 EMERGENCY CONTACTS

**Mentor:** [Tên mentor]  
**Phone:** [Số điện thoại]

**Team members:**
- [Tên 1]: [Số ĐT]
- [Tên 2]: [Số ĐT]

**IT Support:** [Nếu có]

---

## 📖 QUICK LINKS

Nếu cần xem lại:
- `00-BAT-DAU-O-DAY.md` - Overview
- `09-CHUAN-BI-BAO-VE.md` - Defense prep
- `10-KICH-BAN-DEMO.md` - Demo script
- `11-CAU-HOI-THUONG-GAP.md` - FAQ

---

## ✅ FINAL SIGN-OFF

**Tôi đã kiểm tra:**
- [ ] Technical setup hoàn hảo
- [ ] Slides ready
- [ ] Demo script prepared
- [ ] Q&A studied
- [ ] Backup plans ready
- [ ] Mentally prepared

**Signature:** _______________  
**Date:** _______________

---

# 🎯 YOU ARE READY!

Bạn đã chuẩn bị kỹ lưỡng.  
Bạn hiểu rõ project.  
Bạn đã test nhiều lần.  

**TỰ TIN VÀ BẢO VỆ THÀNH CÔNG! 🏆**

---

**Good luck! Break a leg! Chúc bạn đạt điểm cao! 🌟**
