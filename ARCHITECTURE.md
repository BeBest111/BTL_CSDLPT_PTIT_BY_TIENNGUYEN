# 🏗️ KIẾN TRÚC HỆ THỐNG
## Sơ Đồ Chi Tiết - Hệ Thống Quản Lý Nhân Viên Phân Tán

---

## 📐 SƠ ĐỒ TỔNG QUAN

```
┌─────────────────────────────────────────────────────────────────┐
│                    HỆ THỐNG QUẢN LÝ NHÂN VIÊN                   │
│                         (Phân Tán)                               │
└─────────────────────────────────────────────────────────────────┘
                                 │
                    ┌────────────┴────────────┐
                    │                         │
         ┌──────────▼─────────┐    ┌─────────▼────────┐
         │   APPLICATION      │    │   REPORTING      │
         │      LAYER         │    │     LAYER        │
         └──────────┬─────────┘    └─────────┬────────┘
                    │                         │
                    └────────────┬────────────┘
                                 │
              ┌──────────────────▼──────────────────┐
              │        DATABASE LAYER                │
              │    (SQL Server - QuanLyNhanSu)      │
              └──────────────────┬──────────────────┘
                                 │
        ┌────────────────────────┼────────────────────────┐
        │                        │                        │
   ┌────▼─────┐          ┌──────▼──────┐         ┌──────▼──────┐
   │ SITE 1   │          │   SITE 2    │         │   SITE 3    │
   │  (Huế)   │          │ (Nam Định)  │         │   (Vinh)    │
   └──────────┘          └─────────────┘         └─────────────┘
```

---

## 🗄️ SƠ ĐỒ CƠ SỞ DỮ LIỆU CHI TIẾT

### Quan hệ giữa các bảng

```
                    ┌─────────────────┐
                    │  TruSoChinh     │
                    │  PK: ID_TSC     │
                    └────────┬────────┘
                             │ 1
                             │
                             │ *
                    ┌────────▼────────┐
                    │   ChiNhanh      │
                    │  PK: ID_CN      │◄────┐
                    │  FK: ID_TSC     │     │
                    └────────┬────────┘     │
                       │     │              │
                    ┌──┘     └──┐           │
                  1 │           │ 1         │
                    │           │           │
              ┌─────▼────┐  ┌──▼──────┐    │
            * │PhongBan  │  │ChinhSach│    │
              │PK: ID_PB │  │PK: ID_CS│    │
              │FK: ID_CN │  │FK: ID_CN│    │
              └─────┬────┘  └─────────┘    │
                  1 │                      │
                    │                      │
              ┌─────▼────┐                 │
            * │  DuAn    │                 │
              │PK: ID_DA │                 │
              │FK: ID_PB │                 │
              └─────┬────┘                 │
                  * │                      │
                    │                      │
              ┌─────▼──────────────────┐   │
              │     NhanVien           │   │
              │  PK: ID_NV             │   │
              │  FK: ID_DA             │   │
      ┌───────┤  FK: ID_CV             │   │
      │       │  FK: ID_CN    ─────────┘   │
      │       │  FK: ID_PB                 │
      │       └─────┬──────────────────────┘
      │ *         1 │
      │             │
      │     ┌───────▼────────┐
      │     │    Luong       │
      │     │  PK: ID_Luong  │
      │     │  FK: ID_NV     │
      │     └────────────────┘
      │
    1 │
┌─────▼────┐
│ ChucVu   │
│PK: ID_CV │
└──────────┘
```

---

## 🔧 KIẾN TRÚC PHÂN TẦNG

### 1. Physical Layer (Tầng Vật lý)

```
┌──────────────────────────────────────────────────┐
│            PHYSICAL LAYER                        │
├──────────────────────────────────────────────────┤
│                                                  │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐│
│  │  Tables    │  │  Indexes   │  │  Logs      ││
│  │            │  │            │  │            ││
│  │ • 8 bảng   │  │ • 12+ IX   │  │ • 2 bảng   ││
│  │   chính    │  │ • Tối ưu   │  │   audit    ││
│  │ • 131      │  │   query    │  │            ││
│  │   records  │  │            │  │            ││
│  └────────────┘  └────────────┘  └────────────┘│
│                                                  │
└──────────────────────────────────────────────────┘
```

### 2. Logic Layer (Tầng Logic)

```
┌──────────────────────────────────────────────────┐
│             LOGIC LAYER                          │
├──────────────────────────────────────────────────┤
│                                                  │
│  ┌───────────────┐  ┌───────────────┐           │
│  │ Procedures    │  │  Functions    │           │
│  │               │  │               │           │
│  │ • 6 SPs       │  │ • 6 Functions │           │
│  │ • CRUD ops    │  │ • Calculations│           │
│  │ • Validation  │  │ • Aggregates  │           │
│  │ • Transaction │  │               │           │
│  └───────────────┘  └───────────────┘           │
│                                                  │
│  ┌───────────────┐  ┌───────────────┐           │
│  │  Triggers     │  │  Constraints  │           │
│  │               │  │               │           │
│  │ • 4 Triggers  │  │ • PK/FK       │           │
│  │ • Validation  │  │ • CHECK       │           │
│  │ • Audit log   │  │ • UNIQUE      │           │
│  └───────────────┘  └───────────────┘           │
│                                                  │
└──────────────────────────────────────────────────┘
```

### 3. Presentation Layer (Tầng Trình bày)

```
┌──────────────────────────────────────────────────┐
│          PRESENTATION LAYER                      │
├──────────────────────────────────────────────────┤
│                                                  │
│  ┌───────────────┐  ┌───────────────┐           │
│  │    Views      │  │   Reports     │           │
│  │               │  │               │           │
│  │ • 11+ Views   │  │ • Thống kê    │           │
│  │ • Phân mảnh   │  │ • Dashboard   │           │
│  │ • Báo cáo     │  │ • Export      │           │
│  │ • Join nhiều  │  │               │           │
│  │   bảng        │  │               │           │
│  └───────────────┘  └───────────────┘           │
│                                                  │
└──────────────────────────────────────────────────┘
```

### 4. Security Layer (Tầng Bảo mật)

```
┌──────────────────────────────────────────────────┐
│           SECURITY LAYER                         │
├──────────────────────────────────────────────────┤
│                                                  │
│  ┌────────────┐  ┌────────────┐  ┌────────────┐│
│  │   Roles    │  │   Users    │  │  Audit     ││
│  │            │  │            │  │            ││
│  │ • Admin    │  │ • Login    │  │ • Logs     ││
│  │ • Manager  │  │ • User     │  │ • Track    ││
│  │ • Staff    │  │ • Mapping  │  │ • History  ││
│  └────────────┘  └────────────┘  └────────────┘│
│                                                  │
└──────────────────────────────────────────────────┘
```

---

## 🔀 LUỒNG DỮ LIỆU (DATA FLOW)

### Thêm nhân viên mới

```
┌──────────────┐
│ Client/User  │
└──────┬───────┘
       │ 1. Call sp_ThemNhanVien
       ▼
┌──────────────────────────┐
│  Stored Procedure        │
│  sp_ThemNhanVien         │
├──────────────────────────┤
│ • Validate input         │
│ • Check duplicates       │
│ • BEGIN TRANSACTION      │
└──────┬───────────────────┘
       │ 2. Insert if valid
       ▼
┌──────────────────────────┐
│  Table: NhanVien         │
├──────────────────────────┤
│ • PK check               │
│ • FK check               │
└──────┬───────────────────┘
       │ 3. Before Insert
       ▼
┌──────────────────────────┐
│  Trigger Check           │
│  trg_KiemTraTuoiNhanVien │
├──────────────────────────┤
│ • Age >= 18?             │
│ • If No → ROLLBACK       │
│ • If Yes → Continue      │
└──────┬───────────────────┘
       │ 4. After validation
       ▼
┌──────────────────────────┐
│  Data Inserted           │
│  COMMIT TRANSACTION      │
└──────┬───────────────────┘
       │ 5. Return success
       ▼
┌──────────────────────────┐
│  Client receives result  │
└──────────────────────────┘
```

### Cập nhật lương

```
┌──────────────┐
│ Client/User  │
└──────┬───────┘
       │ 1. Call sp_CapNhatLuong
       ▼
┌──────────────────────────┐
│  Stored Procedure        │
│  sp_CapNhatLuong         │
├──────────────────────────┤
│ • Validate input         │
│ • Check employee exists  │
└──────┬───────────────────┘
       │ 2. Update salary
       ▼
┌──────────────────────────┐
│  Table: Luong            │
│  UPDATE MucLuong         │
└──────┬───────────────────┘
       │ 3. Trigger fires
       ▼
┌──────────────────────────┐
│  Trigger                 │
│  trg_LogCapNhatLuong     │
├──────────────────────────┤
│ • Log old salary         │
│ • Log new salary         │
│ • Save to audit table    │
└──────┬───────────────────┘
       │ 4. Insert log
       ▼
┌──────────────────────────┐
│  Table: LogCapNhatLuong  │
│  Audit record saved      │
└──────┬───────────────────┘
       │ 5. Return success
       ▼
┌──────────────────────────┐
│  Client receives result  │
│  History tracked         │
└──────────────────────────┘
```

---

## 🔍 KIẾN TRÚC PHÂN MẢNH

### Horizontal Fragmentation

```
                    ┌──────────────────────────┐
                    │   Bảng NhanVien (Toàn bộ)│
                    │      40 records          │
                    └────────────┬─────────────┘
                                 │
              ┌──────────────────┼──────────────────┐
              │                  │                  │
    ┌─────────▼────────┐ ┌──────▼───────┐ ┌───────▼────────┐
    │ View_NhanVien    │ │View_NhanVien │ │View_NhanVien   │
    │     _CN01        │ │    _CN02     │ │    _CN03       │
    │   (Huế)          │ │(Nam Định)    │ │  (Vinh)        │
    │   WHERE CN='01'  │ │WHERE CN='02' │ │WHERE CN='03'   │
    └──────────────────┘ └──────────────┘ └────────────────┘

                    Site 1           Site 2          Site 3
```

### Vertical Fragmentation (Concept)

```
┌────────────────────────────────────────────────┐
│         Bảng NhanVien (Full)                   │
│  ID | HoTen | NgaySinh | ... | CCCD | Luong   │
└────────────────────────────────────────────────┘
                    │
        ┌───────────┴───────────┐
        │                       │
┌───────▼──────────┐    ┌──────▼────────────┐
│ Public Info      │    │ Sensitive Info    │
│ • ID             │    │ • CCCD            │
│ • HoTen          │    │ • Luong           │
│ • NgaySinh       │    │ • (encrypted)     │
└──────────────────┘    └───────────────────┘
```

---

## ⚡ PERFORMANCE ARCHITECTURE

### Index Strategy

```
┌────────────────────────────────────────────────────┐
│              QUERY OPTIMIZATION                    │
└────────────────────────────────────────────────────┘
                      │
        ┌─────────────┼─────────────┐
        │             │             │
   ┌────▼────┐   ┌────▼────┐  ┌────▼────┐
   │Clustered│   │Non-     │  │Filtered │
   │Index    │   │Clustered│  │Index    │
   │(PK)     │   │Index    │  │         │
   │         │   │• Foreign│  │• WHERE  │
   │• Unique │   │  Keys   │  │  clause │
   │• Sorted │   │• Search │  │         │
   └─────────┘   │  Columns│  └─────────┘
                 └─────────┘

Performance Improvement: 10-100x faster
```

### Caching Strategy

```
┌─────────────────────────────────────┐
│        CACHING LAYERS               │
└─────────────────────────────────────┘
            │
   ┌────────┼────────┐
   │        │        │
┌──▼──┐  ┌──▼──┐  ┌─▼──┐
│View │  │Plan │  │Data│
│Cache│  │Cache│  │Page│
│     │  │     │  │    │
└─────┘  └─────┘  └────┘

Reduces I/O and CPU usage
```

---

## 🔒 SECURITY ARCHITECTURE

### Role-Based Access Control (RBAC)

```
┌──────────────────────────────────────────────┐
│             USERS                            │
└──────────────────────────────────────────────┘
                    │
        ┌───────────┼───────────┐
        │           │           │
   ┌────▼───┐  ┌────▼───┐  ┌───▼────┐
   │ Admin  │  │Manager │  │ Staff  │
   │ User   │  │ User   │  │ User   │
   └────┬───┘  └────┬───┘  └───┬────┘
        │           │           │
        │           │           │
   ┌────▼───┐  ┌────▼───┐  ┌───▼────┐
   │ Role_  │  │ Role_  │  │ Role_  │
   │ Admin  │  │ QuanLy │  │NhanVien│
   └────┬───┘  └────┬───┘  └───┬────┘
        │           │           │
        └───────────┼───────────┘
                    │
        ┌───────────▼───────────┐
        │    PERMISSIONS        │
        │                       │
        │ • SELECT              │
        │ • INSERT              │
        │ • UPDATE              │
        │ • DELETE              │
        │ • EXECUTE             │
        └───────────────────────┘
```

---

## 📊 MONITORING ARCHITECTURE

### Audit Trail

```
┌──────────────────────────────────────────┐
│        DATABASE OPERATIONS               │
└──────────────────────────────────────────┘
            │
    ┌───────┼───────┐
    │       │       │
┌───▼──┐ ┌──▼──┐ ┌──▼───┐
│INSERT│ │UPDATE│ │DELETE│
└───┬──┘ └──┬──┘ └──┬───┘
    │       │       │
    │       │       │
┌───▼───────▼───────▼───┐
│      TRIGGERS         │
│                       │
│ • trg_LogXoa...       │
│ • trg_LogCapNhat...   │
└───────────┬───────────┘
            │
    ┌───────▼───────┐
    │  LOG TABLES   │
    │               │
    │ • Who         │
    │ • What        │
    │ • When        │
    │ • Before/After│
    └───────────────┘
```

---

## 🎯 DEPLOYMENT ARCHITECTURE

### Multi-Site Deployment

```
┌─────────────────────────────────────────────────┐
│            CENTRAL MANAGEMENT                    │
│              (Trụ sở chính)                     │
└────────────────────┬────────────────────────────┘
                     │
        ┌────────────┼────────────┐
        │            │            │
   ┌────▼────┐  ┌────▼────┐  ┌───▼─────┐
   │ Site 1  │  │ Site 2  │  │ Site 3  │
   │ (Huế)   │  │(NĐịnh)  │  │ (Vinh)  │
   │         │  │         │  │         │
   │ ┌─────┐ │  │ ┌─────┐ │  │ ┌─────┐ │
   │ │ DB  │ │  │ │ DB  │ │  │ │ DB  │ │
   │ │Local│ │  │ │Local│ │  │ │Local│ │
   │ └─────┘ │  │ └─────┘ │  │ └─────┘ │
   └─────────┘  └─────────┘  └─────────┘
        │            │            │
        └────────────┼────────────┘
                     │
              ┌──────▼──────┐
              │REPLICATION  │
              │(Future)     │
              └─────────────┘
```

---

## 📈 SCALABILITY

### Horizontal Scaling

```
                ┌─────────┐
                │Load     │
                │Balancer │
                └────┬────┘
                     │
        ┌────────────┼────────────┐
        │            │            │
   ┌────▼────┐  ┌────▼────┐  ┌───▼─────┐
   │Server 1 │  │Server 2 │  │Server 3 │
   │Read     │  │Read     │  │Read     │
   │Replica  │  │Replica  │  │Replica  │
   └────┬────┘  └────┬────┘  └───┬─────┘
        │            │            │
        └────────────┼────────────┘
                     │
              ┌──────▼──────┐
              │   Master    │
              │   Server    │
              │   (Write)   │
              └─────────────┘
```

---

## 🎨 VISUAL SUMMARY

```
┌───────────────────────────────────────────────────────┐
│         COMPLETE SYSTEM ARCHITECTURE                  │
├───────────────────────────────────────────────────────┤
│                                                       │
│  Users → Security → Logic → Data → Storage           │
│                                                       │
│  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐  ┌──────┐  │
│  │Login │→│Roles │→│Stored│→│Views │→│Tables│  │
│  │Auth  │  │Perms │  │Procs │  │      │  │Data  │  │
│  └──────┘  └──────┘  └──────┘  └──────┘  └──────┘  │
│                                                       │
│  ↓         ↓         ↓         ↓         ↓          │
│  • MFA    • RBAC    • Logic   • Report  • Persist   │
│  • Audit  • Encrypt • Valid   • Filter  • Backup    │
│                                                       │
└───────────────────────────────────────────────────────┘
```

---

## 📋 COMPONENT SUMMARY

| Layer | Components | Count |
|-------|-----------|-------|
| **Storage** | Tables, Indexes | 10 + 12+ |
| **Logic** | Procedures, Functions, Triggers | 6 + 6 + 4 |
| **Presentation** | Views | 11+ |
| **Security** | Roles, Users | 5 + N |
| **Audit** | Log Tables | 2 |

**Total Objects:** 54+

---

*Tài liệu này cung cấp cái nhìn tổng quan về kiến trúc hệ thống*

*Xem chi tiết trong README-Physical-Implementation.md*

---

**Tạo bởi:** Nhóm 5 - CSDLPT - PTIT

**Ngày:** 31/10/2025
