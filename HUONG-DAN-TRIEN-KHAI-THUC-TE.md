# 🚀 HƯỚNG DẪN TRIỂN KHAI THỰC TẾ
## Phần 3: Cài Đặt Vật Lý - Hệ Thống Phân Tán

---

## 📋 YÊU CẦU CHUẨN BỊ

### Phần cứng tối thiểu
- **CPU:** Intel Core i5 hoặc tương đương (hỗ trợ Virtualization)
- **RAM:** 16GB (khuyến nghị 32GB)
- **Ổ cứng:** 100GB trống
- **Mạng:** Card mạng hoạt động tốt

### Phần mềm cần thiết
- [ ] VirtualBox 7.0+ hoặc VMware Workstation
- [ ] Windows Server 2019/2022 ISO (3 bản)
- [ ] SQL Server 2019 Developer Edition ISO
- [ ] SQL Server Management Studio (SSMS)
- [ ] Notepad++ hoặc VS Code
- [ ] Snipping Tool để chụp màn hình

---

## 🎯 MÔ HÌNH TRIỂN KHAI

```
┌─────────────────────────────────────────────────────────┐
│                   PHYSICAL HOST                         │
│                   (Máy thật của bạn)                    │
└─────────────────────────────────────────────────────────┘
                          │
        ┌─────────────────┼─────────────────┐
        │                 │                 │
┌───────▼───────┐  ┌──────▼──────┐  ┌──────▼──────┐
│   VM1         │  │   VM2       │  │   VM3       │
│ SITE_HANOI    │  │ SITE_DANANG │  │ SITE_SAIGON │
│               │  │             │  │             │
│ IP: 192.168.  │  │ IP: 192.168.│  │ IP: 192.168.│
│     56.101    │  │     56.102  │  │     56.103  │
│               │  │             │  │             │
│ SQL Server    │  │ SQL Server  │  │ SQL Server  │
│ (Publisher)   │  │ (Subscriber)│  │ (Subscriber)│
└───────────────┘  └─────────────┘  └─────────────┘
        │                 │                 │
        └─────────────────┼─────────────────┘
                          │
                    NAT Network
                (192.168.56.0/24)
```

---

## 📝 PHẦN 3.1: CÀI ĐẶT VPN (MẠNG ẢO)

### Bước 1: Tạo NAT Network trong VirtualBox

**1.1. Mở VirtualBox → File → Preferences**
```
Screenshot 01: VirtualBox_Preferences.png
```

**1.2. Chọn Network → NAT Networks → Add (+)**
```
Name: SQL_Distributed_Network
IPv4 Prefix: 192.168.56.0/24
Enable DHCP: ✅ (checked)

Screenshot 02: NAT_Network_Config.png
```

**1.3. Click OK để lưu**

### Bước 2: Tạo 3 Máy ảo

**Thông số mỗi VM:**
```
Name: 
  - VM1: SITE_HANOI
  - VM2: SITE_DANANG  
  - VM3: SITE_SAIGON

OS: Windows Server 2019/2022
RAM: 4GB (minimum)
CPU: 2 cores
Disk: 50GB (Dynamic)
Network: 
  - Adapter 1: NAT Network (SQL_Distributed_Network)
  - Adapter 2: NAT (để download)
```

**2.1. Tạo VM1 - SITE_HANOI**
```
VirtualBox → New → Expert Mode

Screenshot 03: Create_VM1_HANOI.png

Settings:
- Name: SITE_HANOI
- Type: Microsoft Windows
- Version: Windows 2019 (64-bit)
- Memory: 4096 MB
- Hard Disk: 50 GB (VDI, Dynamically allocated)
```

**2.2. Cấu hình Network cho VM1**
```
VM1 → Settings → Network

Adapter 1:
  Enable Network Adapter: ✅
  Attached to: NAT Network
  Name: SQL_Distributed_Network
  
Screenshot 04: VM1_Network_Adapter1.png

Adapter 2:
  Enable Network Adapter: ✅
  Attached to: NAT
  
Screenshot 05: VM1_Network_Adapter2.png
```

**2.3. Lặp lại cho VM2 và VM3**
```
Screenshot 06: Create_VM2_DANANG.png
Screenshot 07: VM2_Network_Config.png
Screenshot 08: Create_VM3_SAIGON.png
Screenshot 09: VM3_Network_Config.png
```

### Bước 3: Cài đặt Windows Server trên từng VM

**3.1. Mount ISO và Start VM1**
```
VM1 → Settings → Storage → Empty → 💿 Icon
→ Choose Windows Server ISO

Screenshot 10: Mount_Windows_ISO.png

Start VM1
```

**3.2. Cài đặt Windows Server**
```
Language: English (United States)
Time: (UTC+07:00) Bangkok, Hanoi, Jakarta
Keyboard: US

Screenshot 11: Windows_Setup_Language.png

Click "Install now"

Select: Windows Server 2019 Datacenter (Desktop Experience)

Screenshot 12: Windows_Version_Select.png

Accept License → Custom Install

Screenshot 13: Windows_Install_Type.png

Partition: Use entire disk → Next

Screenshot 14: Windows_Partition.png

Wait 10-15 minutes for installation...

Screenshot 15: Windows_Installing.png
```

**3.3. Setup Administrator Password**
```
Password: Admin@123456
Confirm: Admin@123456

Screenshot 16: Windows_Admin_Password.png

Press Ctrl+Alt+Del → Login

Screenshot 17: Windows_First_Login.png
```

**3.4. Lặp lại cho VM2 và VM3**
```
Screenshot 18-24: Repeat for SITE_DANANG
Screenshot 25-31: Repeat for SITE_SAIGON
```

### Bước 4: Cấu hình Static IP cho từng VM

**4.1. Trên VM1 (SITE_HANOI)**
```
Server Manager → Local Server → Ethernet (Adapter 1)

Screenshot 32: VM1_Network_Config_Open.png

Right-click "Ethernet" → Properties → IPv4

IP Address: 192.168.56.101
Subnet Mask: 255.255.255.0
Default Gateway: 192.168.56.1
Preferred DNS: 8.8.8.8
Alternate DNS: 8.8.4.4

Screenshot 33: VM1_Static_IP_Config.png

Click OK
```

**4.2. Đặt tên máy tính**
```
Server Manager → Local Server → Computer Name → Change

Computer name: SITE-HANOI
Workgroup: SQLCLUSTER

Screenshot 34: VM1_Computer_Name.png

Restart Required → Restart Now

Screenshot 35: VM1_Restart.png
```

**4.3. Lặp lại cho VM2 và VM3**
```
VM2 (SITE_DANANG):
  IP: 192.168.56.102
  Name: SITE-DANANG
  Screenshot 36-38: VM2_IP_and_Name.png

VM3 (SITE_SAIGON):
  IP: 192.168.56.103
  Name: SITE-SAIGON
  Screenshot 39-41: VM3_IP_and_Name.png
```

### Bước 5: Kiểm tra kết nối mạng

**5.1. Test ping giữa các VM**

```powershell
# Trên VM1 (SITE_HANOI) - Open PowerShell
ping 192.168.56.102  # VM2
ping 192.168.56.103  # VM3

Screenshot 42: VM1_Ping_Test.png

# Trên VM2 (SITE_DANANG)
ping 192.168.56.101  # VM1
ping 192.168.56.103  # VM3

Screenshot 43: VM2_Ping_Test.png

# Trên VM3 (SITE_SAIGON)
ping 192.168.56.101  # VM1
ping 192.168.56.102  # VM2

Screenshot 44: VM3_Ping_Test.png
```

**Kết quả mong đợi:**
```
Reply from 192.168.56.102: bytes=32 time<1ms TTL=128
Reply from 192.168.56.103: bytes=32 time<1ms TTL=128
Packets: Sent = 4, Received = 4, Lost = 0 (0% loss)
```

**5.2. Test DNS Resolution**
```powershell
# Thêm hosts file trên cả 3 VMs
notepad C:\Windows\System32\drivers\etc\hosts

# Thêm vào cuối file:
192.168.56.101    SITE-HANOI
192.168.56.102    SITE-DANANG
192.168.56.103    SITE-SAIGON

Screenshot 45: Edit_Hosts_File.png

# Save and test
ping SITE-DANANG
ping SITE-SAIGON

Screenshot 46: Ping_By_Hostname.png
```

---

## 📝 PHẦN 3.2: TẠO ĐƯỜNG LINK KẾT NỐI MẠNG

### Đã hoàn thành ở Phần 3.1!

✅ NAT Network đã tạo kết nối giữa các VM
✅ Static IP đã được cấu hình
✅ Ping test thành công
✅ DNS resolution hoạt động

---

## 📝 PHẦN 3.3: CÀI ĐẶT SQL SERVER

### Bước 1: Chuẩn bị cài đặt

**1.1. Download SQL Server 2019 Developer**
```
Trên VM1, mở browser → Download:
https://www.microsoft.com/en-us/sql-server/sql-server-downloads

Click "Download now" under Developer edition

Screenshot 47: SQL_Download_Page.png

Save to: C:\Temp\SQLServer2019-x64-ENU-Dev.iso
```

**1.2. Mount ISO**
```
Right-click ISO → Mount

Screenshot 48: Mount_SQL_ISO.png

Open mounted drive → Run setup.exe

Screenshot 49: SQL_Setup_Start.png
```

### Bước 2: Cài đặt SQL Server trên VM1

**2.1. SQL Server Installation Center**
```
Click: Installation → New SQL Server standalone installation

Screenshot 50: SQL_Installation_Type.png
```

**2.2. Product Key**
```
Select: Developer (Free)
Next

Screenshot 51: SQL_Product_Key.png
```

**2.3. License Terms**
```
✅ I accept the license terms
Next

Screenshot 52: SQL_License_Terms.png
```

**2.4. Microsoft Update**
```
☐ Use Microsoft Update (uncheck for faster install)
Next

Screenshot 53: SQL_Microsoft_Update.png
```

**2.5. Install Rules**
```
Wait for check...
Next

Screenshot 54: SQL_Install_Rules.png
```

**2.6. Feature Selection**
```
✅ Database Engine Services
✅ SQL Server Replication
✅ Client Tools Connectivity
✅ Management Tools - Basic
✅ Management Tools - Complete

Instance Root Directory: C:\Program Files\Microsoft SQL Server\

Screenshot 55: SQL_Feature_Selection.png

Next
```

**2.7. Instance Configuration**
```
○ Default instance
Instance ID: MSSQLSERVER

Screenshot 56: SQL_Instance_Config.png

Next
```

**2.8. Server Configuration**
```
Service Accounts:
  SQL Server Database Engine:
    Account Name: NT AUTHORITY\SYSTEM
    Startup Type: Automatic
    
  SQL Server Agent:
    Account Name: NT AUTHORITY\SYSTEM
    Startup Type: Automatic

Screenshot 57: SQL_Service_Accounts.png

Collation Tab:
  Keep default: SQL_Latin1_General_CP1_CI_AS
  
Screenshot 58: SQL_Collation.png

Next
```

**2.9. Database Engine Configuration**
```
Authentication Mode:
  ○ Mixed Mode (Windows + SQL)
  
Password for 'sa': Admin@123456
Confirm: Admin@123456

Add Current User: Click "Add Current User"

Screenshot 59: SQL_Authentication_Mode.png

Data Directories:
  Keep defaults
  
TempDB:
  Keep defaults

Screenshot 60: SQL_Data_Directories.png

Next
```

**2.10. Ready to Install**
```
Review configuration
Click: Install

Screenshot 61: SQL_Ready_To_Install.png

Wait 15-20 minutes...

Screenshot 62: SQL_Installing_Progress.png
```

**2.11. Installation Complete**
```
All features: Succeeded ✅

Screenshot 63: SQL_Installation_Complete.png

Close
```

### Bước 3: Cài đặt SSMS (SQL Server Management Studio)

**3.1. Download SSMS**
```
Browser → https://aka.ms/ssmsfullsetup

Screenshot 64: SSMS_Download.png

Run: SSMS-Setup-ENU.exe
```

**3.2. Install SSMS**
```
Click: Install

Screenshot 65: SSMS_Install_Start.png

Wait 10 minutes...

Screenshot 66: SSMS_Installing.png

Restart Required → Restart Now

Screenshot 67: SSMS_Restart_Required.png
```

### Bước 4: Cấu hình SQL Server cho Remote Access

**4.1. Enable TCP/IP**
```
Start → SQL Server Configuration Manager

Screenshot 68: Open_SQL_Config_Manager.png

SQL Server Network Configuration → Protocols for MSSQLSERVER

Right-click TCP/IP → Enable

Screenshot 69: Enable_TCPIP.png

Right-click TCP/IP → Properties → IP Addresses

IPALL:
  TCP Dynamic Ports: (empty)
  TCP Port: 1433
  
Screenshot 70: TCPIP_Port_1433.png

Click OK
```

**4.2. Restart SQL Server Service**
```
SQL Server Services → SQL Server (MSSQLSERVER)

Right-click → Restart

Screenshot 71: Restart_SQL_Service.png

Status: Running ✅
```

**4.3. Configure Windows Firewall**
```powershell
# Open PowerShell as Administrator
New-NetFirewallRule -DisplayName "SQL Server" -Direction Inbound -Protocol TCP -LocalPort 1433 -Action Allow

Screenshot 72: Firewall_Rule_SQL.png

New-NetFirewallRule -DisplayName "SQL Browser" -Direction Inbound -Protocol UDP -LocalPort 1434 -Action Allow

Screenshot 73: Firewall_Rule_Browser.png
```

**4.4. Test Connection Locally**
```
Start → SSMS

Connect:
  Server type: Database Engine
  Server name: SITE-HANOI
  Authentication: Windows Authentication
  
Click: Connect

Screenshot 74: SSMS_First_Connection.png

Success! ✅

Screenshot 75: SSMS_Object_Explorer.png
```

### Bước 5: Lặp lại cài đặt cho VM2 và VM3

**5.1. Cài SQL Server trên VM2 (SITE-DANANG)**
```
Lặp lại Bước 2 → Bước 4

Screenshot 76-90: VM2_SQL_Installation.png
```

**5.2. Cài SQL Server trên VM3 (SITE-SAIGON)**
```
Lặp lại Bước 2 → Bước 4

Screenshot 91-105: VM3_SQL_Installation.png
```

### Bước 6: Test Remote Connection giữa các SQL Server

**6.1. Từ VM1 connect đến VM2**
```
SSMS on VM1

New Query → Connect to Server:
  Server name: 192.168.56.102
  Authentication: SQL Server Authentication
  Login: sa
  Password: Admin@123456
  
Screenshot 106: VM1_Connect_To_VM2.png

Success! ✅

Test query:
SELECT @@SERVERNAME, @@VERSION;

Screenshot 107: VM1_Query_VM2.png
```

**6.2. Từ VM1 connect đến VM3**
```
Server name: 192.168.56.103
Authentication: SQL Server Authentication
Login: sa
Password: Admin@123456

Screenshot 108: VM1_Connect_To_VM3.png

Success! ✅
```

---

## 📝 PHẦN 3.4: KIỂM TRA DỊCH VỤ SQL SERVER AGENT

### Bước 1: Kiểm tra SQL Server Agent Status

**1.1. Trên VM1 - SQL Server Configuration Manager**
```
SQL Server Services → SQL Server Agent (MSSQLSERVER)

Status: Running ✅

Screenshot 109: SQL_Agent_Status_VM1.png

If Stopped:
  Right-click → Properties
  Start Mode: Automatic
  Click: Start
  
Screenshot 110: SQL_Agent_Start.png
```

**1.2. Kiểm tra trong SSMS**
```
SSMS → Object Explorer → SQL Server Agent

If stopped (red icon):
  Right-click → Start
  
Screenshot 111: SSMS_SQL_Agent.png

Expand:
  ✅ Jobs
  ✅ Alerts
  ✅ Operators
  ✅ Proxies
  
Screenshot 112: SQL_Agent_Expanded.png
```

**1.3. Test tạo Job**
```
SQL Server Agent → Right-click Jobs → New Job

Name: Test_Agent_Job
Steps → New:
  Step name: Test Step
  Type: Transact-SQL script (T-SQL)
  Command: SELECT GETDATE()
  
Screenshot 113: Create_Test_Job.png

OK → Execute Job

Screenshot 114: Execute_Test_Job.png

View History → Success ✅

Screenshot 115: Job_History_Success.png
```

### Bước 2: Lặp lại cho VM2 và VM3

```
Screenshot 116-120: VM2_SQL_Agent_Check.png
Screenshot 121-125: VM3_SQL_Agent_Check.png
```

---

## 📝 PHẦN 3.5: TẠO LINKED SERVER

### Bước 1: Tạo Linked Server từ VM1 → VM2

**1.1. SSMS trên VM1**
```
Object Explorer → Server Objects → Linked Servers

Right-click Linked Servers → New Linked Server

Screenshot 126: Create_Linked_Server_Menu.png
```

**1.2. Cấu hình General**
```
General Page:

Linked server: SITE_DANANG
Server type: ○ SQL Server

Screenshot 127: Linked_Server_General.png
```

**1.3. Cấu hình Security**
```
Security Page:

For a login not defined in the list above:
  ○ Be made using this security context:
  
Remote login: sa
With password: Admin@123456

Screenshot 128: Linked_Server_Security.png
```

**1.4. Cấu hình Server Options**
```
Server Options Page:

Collation Compatible: True
Data Access: True
RPC: True
RPC Out: True
Use Remote Collation: True

Screenshot 129: Linked_Server_Options.png

Click: OK
```

**1.5. Test Linked Server**
```
Right-click SITE_DANANG → Test Connection

Screenshot 130: Test_Linked_Server.png

Result: "The test connection to the linked server succeeded."

Screenshot 131: Linked_Server_Success.png
```

### Bước 2: Tạo Linked Server từ VM1 → VM3

```
Lặp lại Bước 1

Linked server: SITE_SAIGON
Server: 192.168.56.103

Screenshot 132-136: Linked_Server_VM1_To_VM3.png

Test Connection: Success ✅

Screenshot 137: Linked_Server_VM3_Success.png
```

### Bước 3: Query test qua Linked Server

**3.1. Test query đến SITE_DANANG**
```sql
-- Trên VM1 SSMS
SELECT * FROM SITE_DANANG.master.sys.databases;

Screenshot 138: Query_Linked_Server_VM2.png

SELECT @@SERVERNAME AS RemoteServer;

Screenshot 139: Query_Result_VM2.png
```

**3.2. Test 4-part name query**
```sql
-- Syntax: [LinkedServer].[Database].[Schema].[Object]
SELECT * FROM SITE_DANANG.master.dbo.sysdatabases;

Screenshot 140: Four_Part_Name_Query.png
```

### Bước 4: Tạo Linked Server ngược lại (Optional)

**4.1. Từ VM2 → VM1**
```
Trên VM2 SSMS:

Create Linked Server:
  Name: SITE_HANOI
  Server: 192.168.56.101
  
Screenshot 141-145: VM2_To_VM1_Linked_Server.png
```

**4.2. Từ VM3 → VM1**
```
Trên VM3 SSMS:

Create Linked Server:
  Name: SITE_HANOI
  Server: 192.168.56.101
  
Screenshot 146-150: VM3_To_VM1_Linked_Server.png
```

---

## 📝 PHẦN 3.6: TẠO PUBLICATION (REPLICATION)

### Bước 1: Chuẩn bị cho Replication

**1.1. Tạo shared folder cho Snapshot**
```
Trên VM1:

C:\ → New Folder → ReplData

Screenshot 151: Create_ReplData_Folder.png

Right-click ReplData → Properties → Sharing → Advanced Sharing

✅ Share this folder
Share name: ReplData
Permissions → Everyone → Full Control

Screenshot 152: Share_ReplData_Folder.png

Network Path: \\SITE-HANOI\ReplData

Screenshot 153: ReplData_Network_Path.png
```

**1.2. Tạo database mẫu với dữ liệu**
```sql
-- Trên VM1 SSMS
CREATE DATABASE QuanLyNhanSu;
GO

USE QuanLyNhanSu;
GO

-- Run HR.sql script
-- Run HR-Data.sql script

Screenshot 154: Create_Sample_Database.png

-- Verify data
SELECT COUNT(*) FROM NhanVien;
-- Should return 40

Screenshot 155: Verify_Sample_Data.png
```

### Bước 2: Configure Distributor (VM1)

**2.1. Start Configure Distribution**
```
SSMS VM1 → Object Explorer → Replication

Right-click Replication → Configure Distribution

Screenshot 156: Configure_Distribution_Menu.png

Next
```

**2.2. Distributor**
```
○ 'SITE-HANOI' will act as its own Distributor

Screenshot 157: Distributor_Selection.png

Next
```

**2.3. Snapshot Folder**
```
Snapshot folder: \\SITE-HANOI\ReplData

Screenshot 158: Snapshot_Folder_Path.png

Next
```

**2.4. Distribution Database**
```
Distribution database name: distribution
Keep defaults

Screenshot 159: Distribution_Database.png

Next
```

**2.5. Publishers**
```
✅ SITE-HANOI

Screenshot 160: Enable_Publishers.png

Next
```

**2.6. Distributor Password**
```
Password: Admin@123456
Confirm: Admin@123456

Screenshot 161: Distributor_Password.png

Next
```

**2.7. Complete Configuration**
```
✅ Configure distribution

Screenshot 162: Configure_Distribution_Summary.png

Next → Finish

Wait for configuration...

Screenshot 163: Configuring_Distribution.png

Success! All actions completed successfully ✅

Screenshot 164: Distribution_Configured_Success.png

Close
```

### Bước 3: Create Publication (VM1)

**3.1. New Publication Wizard**
```
SSMS VM1 → Databases → QuanLyNhanSu

Right-click → Replication → New Publication

Screenshot 165: New_Publication_Menu.png

Next
```

**3.2. Publication Database**
```
Select: QuanLyNhanSu

Screenshot 166: Publication_Database.png

Next
```

**3.3. Publication Type**
```
○ Transactional publication

Screenshot 167: Publication_Type.png

Next
```

**3.4. Articles (Tables to replicate)**
```
✅ Tables:
  ✅ dbo.TruSoChinh
  ✅ dbo.ChiNhanh
  ✅ dbo.PhongBan
  ✅ dbo.DuAn
  ✅ dbo.ChucVu
  ✅ dbo.ChinhSach
  ✅ dbo.NhanVien
  ✅ dbo.Luong

Screenshot 168: Select_Articles.png

Next
```

**3.5. Article Issues**
```
If warnings appear:
  Review and continue

Screenshot 169: Article_Issues.png

Next
```

**3.6. Filter Table Rows**
```
☐ No filter (replicate all rows)

Screenshot 170: Filter_Rows.png

Next
```

**3.7. Snapshot Agent**
```
✅ Create a snapshot immediately
✅ Schedule: Daily at 12:00 AM

Screenshot 171: Snapshot_Agent_Schedule.png

Next
```

**3.8. Agent Security**
```
Snapshot Agent:
  Click: Security Settings
  
  ○ Run under the SQL Server Agent service account
  Connect to Publisher: Using Windows Authentication
  
Screenshot 172: Agent_Security.png

OK → Next
```

**3.9. Wizard Actions**
```
✅ Create the publication

Screenshot 173: Wizard_Actions.png

Next
```

**3.10. Publication Name**
```
Publication name: QuanLyNhanSu_Publication

Screenshot 174: Publication_Name.png

Next → Finish
```

**3.11. Create Publication**
```
Creating publication...

Screenshot 175: Creating_Publication.png

Success! All actions completed successfully ✅

Screenshot 176: Publication_Created_Success.png

Close
```

### Bước 4: Create Subscription (VM2 - SITE_DANANG)

**4.1. New Subscription Wizard**
```
SSMS VM1 → Replication → Local Publications

Right-click QuanLyNhanSu_Publication → New Subscriptions

Screenshot 177: New_Subscription_Menu.png

Next
```

**4.2. Publication**
```
Publisher: SITE-HANOI
Publication: QuanLyNhanSu_Publication

Screenshot 178: Select_Publication.png

Next
```

**4.3. Distribution Agent Location**
```
○ Run all agents at the Distributor (push subscriptions)

Screenshot 179: Agent_Location.png

Next
```

**4.4. Subscribers**
```
Click: Add SQL Server Subscriber

Server: 192.168.56.102
Authentication: SQL Server Authentication
Login: sa
Password: Admin@123456

Screenshot 180: Add_Subscriber_VM2.png

Connect → ✅ SITE-DANANG

Subscription Database: <New database>
  Name: QuanLyNhanSu

Screenshot 181: Subscriber_Database.png

OK
```

**4.5. Distribution Agent Security**
```
Click: ...

○ Run under the SQL Server Agent service account
Connect to Subscriber: SQL Server Authentication
  Login: sa
  Password: Admin@123456

Screenshot 182: Subscriber_Agent_Security.png

OK → Next
```

**4.6. Synchronization Schedule**
```
Agent Schedule: Run continuously

Screenshot 183: Sync_Schedule.png

Next
```

**4.7. Initialize Subscriptions**
```
Initialize When: Immediately

Screenshot 184: Initialize_Subscriptions.png

Next
```

**4.8. Subscription Type**
```
○ Push (Server-side replication)

Next
```

**4.9. Complete Subscription**
```
✅ Create the subscription(s)

Screenshot 185: Wizard_Actions_Subscription.png

Next → Finish

Creating subscriptions...

Screenshot 186: Creating_Subscriptions.png

Success! ✅

Screenshot 187: Subscription_Created_Success.png

Close
```

### Bước 5: Lặp lại cho VM3 (SITE_SAIGON)

```
Repeat Bước 4 cho VM3:
  Subscriber: 192.168.56.103
  Name: SITE-SAIGON

Screenshot 188-195: Create_Subscription_VM3.png
```

### Bước 6: Monitor Replication

**6.1. Launch Replication Monitor**
```
SSMS VM1 → Replication → Launch Replication Monitor

Screenshot 196: Launch_Replication_Monitor.png

Add Publisher: SITE-HANOI

Screenshot 197: Add_Publisher_Monitor.png
```

**6.2. Check Subscription Status**
```
Expand: SITE-HANOI → QuanLyNhanSu_Publication

Subscriptions:
  SITE-DANANG: QuanLyNhanSu → Running ✅
  SITE-SAIGON: QuanLyNhanSu → Running ✅
  
Screenshot 198: Replication_Monitor_Status.png

Right-click subscription → View Details

Screenshot 199: Subscription_Details.png

All commands replicated successfully ✅
```

---

## 📝 PHẦN 3.7: KIỂM TRA GIAO DỊCH VÀ ĐỒNG BỘ

### A. TEST NHẬP DỮ LIỆU (INSERT)

**Test 1: Insert trên Publisher (VM1)**
```sql
-- Trên VM1 SSMS
USE QuanLyNhanSu;
GO

-- Insert nhân viên mới
EXEC sp_ThemNhanVien 
    @ID_NhanVien = 'NTNV99',
    @ID_DuAn = 'NTDA01',
    @ID_ChucVu = 'NTCV07',
    @ID_ChiNhanh = 'CN04',
    @ID_PhongBan = 'NTPB01',
    @HoTen = N'Nguyen Van Test',
    @NgaySinh = '1995-05-15',
    @GioiTinh = N'Nam',
    @DanToc = N'Kinh',
    @CCCD = '099999999999',
    @SoDienThoai = '0999999999',
    @Email = 'test@email.com',
    @DiaChi = N'Test Address';

Screenshot 200: Insert_Data_Publisher.png

-- Verify on Publisher
SELECT * FROM NhanVien WHERE ID_NhanVien = 'NTNV99';

Screenshot 201: Verify_Insert_Publisher.png
```

**Test 2: Check Replication trên Subscriber (VM2)**
```sql
-- Đợi 5-10 giây cho replication

-- Trên VM2 SSMS
USE QuanLyNhanSu;
GO

SELECT * FROM NhanVien WHERE ID_NhanVien = 'NTNV99';

Screenshot 202: Verify_Replicated_VM2.png

-- Should show same record! ✅
```

**Test 3: Check trên VM3**
```sql
-- Trên VM3 SSMS
USE QuanLyNhanSu;
GO

SELECT * FROM NhanVien WHERE ID_NhanVien = 'NTNV99';

Screenshot 203: Verify_Replicated_VM3.png

-- Should show same record! ✅
```

### B. TEST CẬP NHẬT DỮ LIỆU (UPDATE)

**Test 4: Update trên Publisher**
```sql
-- Trên VM1
USE QuanLyNhanSu;
GO

EXEC sp_CapNhatNhanVien
    @ID_NhanVien = 'NTNV99',
    @SoDienThoai = '0888888888',
    @Email = 'updated@email.com';

Screenshot 204: Update_Data_Publisher.png

-- Verify
SELECT ID_NhanVien, SoDienThoai, Email 
FROM NhanVien 
WHERE ID_NhanVien = 'NTNV99';

Screenshot 205: Verify_Update_Publisher.png
```

**Test 5: Check Update trên Subscribers**
```sql
-- Đợi 5-10 giây

-- Trên VM2
SELECT ID_NhanVien, SoDienThoai, Email 
FROM QuanLyNhanSu.dbo.NhanVien 
WHERE ID_NhanVien = 'NTNV99';

Screenshot 206: Verify_Update_VM2.png

-- Trên VM3
SELECT ID_NhanVien, SoDienThoai, Email 
FROM QuanLyNhanSu.dbo.NhanVien 
WHERE ID_NhanVien = 'NTNV99';

Screenshot 207: Verify_Update_VM3.png

-- Both should show updated values! ✅
```

### C. TEST HIỂN THỊ DỮ LIỆU (VIEWS)

**Test 6: Query Views trên Publisher**
```sql
-- Trên VM1
USE QuanLyNhanSu;
GO

-- Test View thống kê
SELECT * FROM View_ThongKeTheoPhongBan;

Screenshot 208: Query_View_Publisher.png

-- Test View chi tiết
SELECT TOP 10 * FROM View_ThongTinNhanVienChiTiet
ORDER BY MucLuong DESC;

Screenshot 209: Query_View_Detail_Publisher.png
```

**Test 7: Query Views trên Subscribers**
```sql
-- Trên VM2
USE QuanLyNhanSu;
GO

SELECT * FROM View_ThongKeTheoPhongBan;

Screenshot 210: Query_View_VM2.png

-- Trên VM3
SELECT * FROM View_ThongKeTheoPhongBan;

Screenshot 211: Query_View_VM3.png

-- Results should match! ✅
```

### D. TEST LINKED SERVER QUERY

**Test 8: Distributed Query từ VM1**
```sql
-- Trên VM1 - Query across all sites
USE QuanLyNhanSu;
GO

-- So sánh số nhân viên ở 3 sites
SELECT 
    'HANOI' AS Site,
    COUNT(*) AS TotalEmployees
FROM NhanVien

UNION ALL

SELECT 
    'DANANG' AS Site,
    COUNT(*) AS TotalEmployees
FROM SITE_DANANG.QuanLyNhanSu.dbo.NhanVien

UNION ALL

SELECT 
    'SAIGON' AS Site,
    COUNT(*) AS TotalEmployees
FROM SITE_SAIGON.QuanLyNhanSu.dbo.NhanVien;

Screenshot 212: Distributed_Query_Linked_Server.png

-- All should show 41 (40 + 1 test record) ✅
```

### E. TEST PHÂN MẢNH NGANG (Horizontal Fragmentation)

**Test 9: Query View phân mảnh theo chi nhánh**
```sql
-- Trên VM1
USE QuanLyNhanSu;
GO

-- Test phân mảnh chi nhánh CN04
SELECT COUNT(*) AS Total_CN04
FROM View_NhanVien_CN04;

Screenshot 213: Query_Fragment_CN04.png

-- Test với UNION để tái tạo bảng gốc
SELECT * FROM View_NhanVien_CN01
UNION ALL
SELECT * FROM View_NhanVien_CN02
UNION ALL
SELECT * FROM View_NhanVien_CN03
UNION ALL
SELECT * FROM View_NhanVien_CN04
UNION ALL
SELECT * FROM View_NhanVien_CN05;

Screenshot 214: Union_All_Fragments.png

-- Total should equal SELECT COUNT(*) FROM NhanVien
```

**Test 10: Verify trên Subscribers**
```sql
-- Trên VM2
USE QuanLyNhanSu;
GO

SELECT COUNT(*) FROM View_NhanVien_CN04;

Screenshot 215: Fragment_VM2.png

-- Trên VM3
SELECT COUNT(*) FROM View_NhanVien_CN04;

Screenshot 216: Fragment_VM3.png

-- All counts should match! ✅
```

### F. TEST THỐNG KÊ VÀ BÁO CÁO

**Test 11: Thống kê phức tạp**
```sql
-- Trên VM1
USE QuanLyNhanSu;
GO

-- Thống kê lương theo chi nhánh
SELECT 
    CN.TenChiNhanh,
    COUNT(NV.ID_NhanVien) AS SoNhanVien,
    AVG(L.MucLuong) AS LuongTrungBinh,
    SUM(L.MucLuong) AS TongQuiLuong
FROM ChiNhanh CN
LEFT JOIN NhanVien NV ON CN.ID_ChiNhanh = NV.ID_ChiNhanh
LEFT JOIN Luong L ON NV.ID_NhanVien = L.ID_NhanVien
GROUP BY CN.TenChiNhanh
ORDER BY TongQuiLuong DESC;

Screenshot 217: Statistics_Query.png
```

**Test 12: Verify Statistics trên Subscribers**
```sql
-- Run same query on VM2 and VM3
-- Results should match!

Screenshot 218: Statistics_VM2.png
Screenshot 219: Statistics_VM3.png
```

### G. TEST TRANSACTION PHÂN TÁN

**Test 13: Distributed Transaction**
```sql
-- Trên VM1
USE QuanLyNhanSu;
GO

BEGIN DISTRIBUTED TRANSACTION;

-- Insert on local server
INSERT INTO ChinhSach (ID_ChinhSach, ID_ChiNhanh, TenChinhSach, MoTa)
VALUES ('NTCS99', 'CN04', N'Test Policy', N'Test Description');

-- Insert on remote server via Linked Server
INSERT INTO SITE_DANANG.QuanLyNhanSu.dbo.ChinhSach 
    (ID_ChinhSach, ID_ChiNhanh, TenChinhSach, MoTa)
VALUES ('NTCS98', 'CN04', N'Remote Test', N'Remote Description');

COMMIT TRANSACTION;

Screenshot 220: Distributed_Transaction.png

-- Verify on both servers
SELECT * FROM ChinhSach WHERE ID_ChinhSach IN ('NTCS99', 'NTCS98');

Screenshot 221: Verify_Distributed_Trans.png
```

### H. TEST TRIGGER VÀ AUDIT LOG

**Test 14: Test Trigger validation**
```sql
-- Trên VM1
USE QuanLyNhanSu;
GO

-- Try to insert employee < 18 years old (should FAIL)
BEGIN TRY
    INSERT INTO NhanVien (ID_NhanVien, ID_DuAn, ID_ChucVu, ID_ChiNhanh, 
        ID_PhongBan, HoTen, NgaySinh, GioiTinh, DanToc, CCCD, 
        SoDienThoai, Email, DiaChi)
    VALUES ('NTNV00', 'NTDA01', 'NTCV07', 'CN04', 'NTPB01',
        N'Under 18', '2015-01-01', N'Nam', N'Kinh', '000000000000',
        '0000000000', 'under18@test.com', N'Test');
    
    PRINT 'ERROR: Trigger did not fire!';
END TRY
BEGIN CATCH
    PRINT 'SUCCESS: Trigger blocked invalid age!';
    PRINT ERROR_MESSAGE();
END CATCH;

Screenshot 222: Test_Trigger_Age.png
```

**Test 15: Test Audit Log**
```sql
-- Update salary to trigger log
UPDATE Luong
SET MucLuong = 50000000
WHERE ID_NhanVien = 'NTNV01';

Screenshot 223: Trigger_Update_Salary.png

-- Check audit log
SELECT TOP 5 * 
FROM LogCapNhatLuong
ORDER BY NgayCapNhat DESC;

Screenshot 224: View_Audit_Log.png

-- Should show the change! ✅
```

**Test 16: Delete and check log**
```sql
-- Delete a record
DELETE FROM NhanVien WHERE ID_NhanVien = 'NTNV99';

Screenshot 225: Delete_Employee.png

-- Check delete log
SELECT * FROM LogXoaNhanVien
ORDER BY NgayXoa DESC;

Screenshot 226: View_Delete_Log.png

-- Should show deleted employee! ✅
```

### I. TEST REPLICATION MONITOR

**Test 17: Check Replication Performance**
```
SSMS VM1 → Replication Monitor

Right-click Publisher → Refresh

Screenshot 227: Replication_Monitor_Refresh.png

Check metrics:
  - Delivery Rate
  - Latency
  - Undelivered Commands
  
Screenshot 228: Replication_Performance.png

All should be healthy! ✅
```

### J. FINAL VERIFICATION

**Test 18: Complete Data Consistency Check**
```sql
-- Trên VM1
USE QuanLyNhanSu;
GO

-- Count all records
SELECT 
    'NhanVien' AS TableName, COUNT(*) AS Records FROM NhanVien
UNION ALL
SELECT 'Luong', COUNT(*) FROM Luong
UNION ALL
SELECT 'PhongBan', COUNT(*) FROM PhongBan
UNION ALL
SELECT 'ChiNhanh', COUNT(*) FROM ChiNhanh;

Screenshot 229: Count_All_Tables_VM1.png

-- Run same query on VM2
Screenshot 230: Count_All_Tables_VM2.png

-- Run same query on VM3
Screenshot 231: Count_All_Tables_VM3.png

-- All counts should MATCH! ✅
```

---

## 📊 BẢNG TỔNG HỢP SCREENSHOTS

| # | Tên File | Mô tả | Bước |
|---|----------|-------|------|
| 01 | VirtualBox_Preferences.png | Mở Preferences | 3.1.1 |
| 02 | NAT_Network_Config.png | Cấu hình NAT Network | 3.1.2 |
| 03 | Create_VM1_HANOI.png | Tạo VM1 | 3.1.2 |
| ... | ... | ... | ... |
| 231 | Count_All_Tables_VM3.png | Verify data VM3 | 3.7.J |

**Tổng số screenshots cần: ~230 hình**

---

## ✅ CHECKLIST HOÀN THÀNH

### Phần 3.1: VPN/Mạng ảo
- [ ] Tạo NAT Network
- [ ] Tạo 3 VMs
- [ ] Cài Windows Server (3 VMs)
- [ ] Cấu hình Static IP
- [ ] Test ping giữa các VM
- [ ] Screenshots: 1-46

### Phần 3.2: Link mạng
- [ ] ✅ Đã hoàn thành trong 3.1

### Phần 3.3: SQL Server
- [ ] Cài SQL Server VM1
- [ ] Cài SSMS VM1
- [ ] Cấu hình Remote Access
- [ ] Cài SQL Server VM2
- [ ] Cài SQL Server VM3
- [ ] Test remote connection
- [ ] Screenshots: 47-108

### Phần 3.4: SQL Agent
- [ ] Check Agent VM1
- [ ] Check Agent VM2
- [ ] Check Agent VM3
- [ ] Test Job execution
- [ ] Screenshots: 109-125

### Phần 3.5: Linked Server
- [ ] Tạo Linked Server VM1→VM2
- [ ] Tạo Linked Server VM1→VM3
- [ ] Test queries
- [ ] Screenshots: 126-150

### Phần 3.6: Replication
- [ ] Configure Distributor
- [ ] Create Publication
- [ ] Create Subscription VM2
- [ ] Create Subscription VM3
- [ ] Monitor Replication
- [ ] Screenshots: 151-199

### Phần 3.7: Testing
- [ ] Test INSERT (replication)
- [ ] Test UPDATE (replication)
- [ ] Test SELECT (views)
- [ ] Test Linked Server query
- [ ] Test phân mảnh ngang
- [ ] Test thống kê
- [ ] Test distributed transaction
- [ ] Test triggers
- [ ] Test audit logs
- [ ] Final verification
- [ ] Screenshots: 200-231

---

## 🎯 KẾT LUẬN

Sau khi hoàn thành tất cả các bước trên, bạn sẽ có:

✅ Môi trường phân tán hoàn chỉnh (3 sites)
✅ SQL Server Replication hoạt động
✅ Linked Server kết nối các site
✅ Phân mảnh ngang được triển khai
✅ Đồng bộ dữ liệu tự động
✅ ~230 screenshots minh chứng
✅ Tất cả test cases PASS

**Thời gian ước tính:** 8-10 giờ

**Độ khó:** ⭐⭐⭐⭐☆

---

*Tài liệu này hướng dẫn chi tiết từng bước để bạn có thể tự thực hiện*

*Nhớ chụp screenshot từng bước theo đúng yêu cầu!*

**Chúc bạn thành công!** 🚀
