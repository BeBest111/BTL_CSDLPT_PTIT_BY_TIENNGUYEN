-- =============================================
-- SCRIPT DEPLOYMENT TỰ ĐỘNG
-- Hệ Thống Quản Lý Nhân Viên Phân Tán
-- =============================================

-- Chế độ SQLCMD để chạy nhiều file
:setvar DatabaseName "QuanLyNhanSu"
:setvar BackupPath "D:\Backup\"

PRINT '==============================================';
PRINT 'BẮT ĐẦU TRIỂN KHAI HỆ THỐNG';
PRINT 'Database: $(DatabaseName)';
PRINT '==============================================';
GO

-- =============================================
-- BƯỚC 1: TẠO DATABASE (NẾU CHƯA TỒN TẠI)
-- =============================================

PRINT '';
PRINT 'BƯỚC 1: Kiểm tra và tạo Database...';

IF NOT EXISTS (SELECT name FROM sys.databases WHERE name = N'QuanLyNhanSu')
BEGIN
    PRINT 'Đang tạo database QuanLyNhanSu...';
    CREATE DATABASE QuanLyNhanSu;
    PRINT '✓ Tạo database thành công!';
END
ELSE
BEGIN
    PRINT '✓ Database đã tồn tại!';
END
GO

USE QuanLyNhanSu;
GO

-- Thiết lập collation
ALTER DATABASE QuanLyNhanSu
COLLATE Latin1_General_CI_AS;
GO

-- =============================================
-- BƯỚC 2: XÓA CÁC OBJECT CŨ (NẾU TỒN TẠI)
-- =============================================

PRINT '';
PRINT 'BƯỚC 2: Dọn dẹp các object cũ...';

-- Xóa Views
DECLARE @DropViewsSQL NVARCHAR(MAX) = N'';
SELECT @DropViewsSQL = @DropViewsSQL + 'DROP VIEW IF EXISTS ' + QUOTENAME(name) + '; '
FROM sys.views
WHERE name LIKE 'View_%';
IF LEN(@DropViewsSQL) > 0 EXEC sp_executesql @DropViewsSQL;
PRINT '✓ Đã xóa các Views cũ';

-- Xóa Stored Procedures
DECLARE @DropProcsSQL NVARCHAR(MAX) = N'';
SELECT @DropProcsSQL = @DropProcsSQL + 'DROP PROCEDURE IF EXISTS ' + QUOTENAME(name) + '; '
FROM sys.procedures
WHERE name LIKE 'sp_%';
IF LEN(@DropProcsSQL) > 0 EXEC sp_executesql @DropProcsSQL;
PRINT '✓ Đã xóa các Stored Procedures cũ';

-- Xóa Functions
DECLARE @DropFuncsSQL NVARCHAR(MAX) = N'';
SELECT @DropFuncsSQL = @DropFuncsSQL + 'DROP FUNCTION IF EXISTS ' + QUOTENAME(name) + '; '
FROM sys.objects
WHERE type IN ('FN', 'IF', 'TF') AND name LIKE 'fn_%';
IF LEN(@DropFuncsSQL) > 0 EXEC sp_executesql @DropFuncsSQL;
PRINT '✓ Đã xóa các Functions cũ';

-- Xóa Triggers
DECLARE @DropTriggersSQL NVARCHAR(MAX) = N'';
SELECT @DropTriggersSQL = @DropTriggersSQL + 'DROP TRIGGER IF EXISTS ' + QUOTENAME(name) + '; '
FROM sys.triggers
WHERE name LIKE 'trg_%';
IF LEN(@DropTriggersSQL) > 0 EXEC sp_executesql @DropTriggersSQL;
PRINT '✓ Đã xóa các Triggers cũ';

-- Xóa Indexes (trừ PRIMARY KEY và UNIQUE)
DECLARE @table_name NVARCHAR(255);
DECLARE @index_name NVARCHAR(255);
DECLARE @drop_statement NVARCHAR(500);
DECLARE index_cursor CURSOR FOR
SELECT t.name, i.name
FROM sys.indexes i
INNER JOIN sys.tables t ON i.object_id = t.object_id
WHERE i.name LIKE 'IX_%' AND i.is_primary_key = 0 AND i.is_unique_constraint = 0;

OPEN index_cursor;
FETCH NEXT FROM index_cursor INTO @table_name, @index_name;

WHILE @@FETCH_STATUS = 0
BEGIN
    SET @drop_statement = N'DROP INDEX ' + QUOTENAME(@index_name) + ' ON ' + QUOTENAME(@table_name);
    EXEC sp_executesql @drop_statement;
    FETCH NEXT FROM index_cursor INTO @table_name, @index_name;
END

CLOSE index_cursor;
DEALLOCATE index_cursor;
PRINT '✓ Đã xóa các Indexes cũ';

-- Xóa các bảng log
DROP TABLE IF EXISTS LogCapNhatLuong;
DROP TABLE IF EXISTS LogXoaNhanVien;
PRINT '✓ Đã xóa các bảng log cũ';

GO

-- =============================================
-- BƯỚC 3: TẠO CẤU TRÚC BẢNG
-- =============================================

PRINT '';
PRINT 'BƯỚC 3: Tạo cấu trúc bảng...';

-- Kiểm tra và tạo bảng nếu chưa tồn tại
IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'TruSoChinh')
BEGIN
    PRINT 'Tạo bảng TruSoChinh...';
    CREATE TABLE TruSoChinh(
        ID_TruSoChinh VARCHAR(255),
        TenTruSoChinh VARCHAR(255),
        DiaChi VARCHAR(255),
        Email VARCHAR(255),	
        SoDienThoai VARCHAR(255),
        PRIMARY KEY(ID_TruSoChinh)
    );
    PRINT '✓ Đã tạo bảng TruSoChinh';
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ChiNhanh')
BEGIN
    PRINT 'Tạo bảng ChiNhanh...';
    CREATE TABLE ChiNhanh(
        ID_ChiNhanh VARCHAR(255),
        ID_TruSoChinh VARCHAR(255),
        TenChiNhanh VARCHAR(255),
        DiaChi VARCHAR(255),
        Email VARCHAR(255),	
        SoDienThoai VARCHAR(255),
        PRIMARY KEY(ID_ChiNhanh),
        FOREIGN KEY(ID_TruSoChinh) REFERENCES TruSoChinh(ID_TruSoChinh)
    );
    PRINT '✓ Đã tạo bảng ChiNhanh';
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ChinhSach')
BEGIN
    PRINT 'Tạo bảng ChinhSach...';
    CREATE TABLE ChinhSach(
        ID_ChinhSach VARCHAR(255),
        ID_ChiNhanh VARCHAR(255),
        TenChinhSach VARCHAR(255),
        MoTa VARCHAR(255),
        PRIMARY KEY(ID_ChinhSach),
        FOREIGN KEY(ID_ChiNhanh) REFERENCES ChiNhanh(ID_ChiNhanh)
    );
    PRINT '✓ Đã tạo bảng ChinhSach';
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'PhongBan')
BEGIN
    PRINT 'Tạo bảng PhongBan...';
    CREATE TABLE PhongBan(
        ID_PhongBan VARCHAR(255),
        ID_ChiNhanh VARCHAR(255),
        TenPhongBan VARCHAR(255),
        Email VARCHAR(255),
        SoDienThoai VARCHAR(255),
        PRIMARY KEY(ID_PhongBan),
        FOREIGN KEY(ID_ChiNhanh) REFERENCES ChiNhanh(ID_ChiNhanh)
    );
    PRINT '✓ Đã tạo bảng PhongBan';
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'DuAn')
BEGIN
    PRINT 'Tạo bảng DuAn...';
    CREATE TABLE DuAn(
        ID_DuAn VARCHAR(255),
        ID_PhongBan VARCHAR(255),
        TenDuAn VARCHAR(255),
        NgayBatDau DATE,
        ThoiHan INT,
        MoTa VARCHAR(255),
        PRIMARY KEY(ID_DuAn),
        FOREIGN KEY(ID_PhongBan) REFERENCES PhongBan(ID_PhongBan)
    );
    PRINT '✓ Đã tạo bảng DuAn';
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'ChucVu')
BEGIN
    PRINT 'Tạo bảng ChucVu...';
    CREATE TABLE ChucVu(
        ID_ChucVu VARCHAR(255),
        TenChucVu VARCHAR(255),
        BacLuong INT,
        PRIMARY KEY(ID_ChucVu)
    );
    PRINT '✓ Đã tạo bảng ChucVu';
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'NhanVien')
BEGIN
    PRINT 'Tạo bảng NhanVien...';
    CREATE TABLE NhanVien(
        ID_NhanVien VARCHAR(255),
        ID_DuAn VARCHAR(255),
        ID_ChucVu VARCHAR(255),
        ID_ChiNhanh VARCHAR(255),
        ID_PhongBan VARCHAR(255),
        HoTen VARCHAR(255),
        NgaySinh DATE,
        GioiTinh VARCHAR(255),
        DanToc VARCHAR(255),
        CCCD VARCHAR(255),
        SoDienThoai VARCHAR(255),
        Email VARCHAR(255),	
        DiaChi VARCHAR(255),
        PRIMARY KEY(ID_NhanVien),
        FOREIGN KEY(ID_DuAn) REFERENCES DuAn(ID_DuAn),
        FOREIGN KEY(ID_ChucVu) REFERENCES ChucVu(ID_ChucVu),
        FOREIGN KEY(ID_ChiNhanh) REFERENCES ChiNhanh(ID_ChiNhanh),
        FOREIGN KEY(ID_PhongBan) REFERENCES PhongBan(ID_PhongBan)
    );
    PRINT '✓ Đã tạo bảng NhanVien';
END

IF NOT EXISTS (SELECT * FROM sys.tables WHERE name = 'Luong')
BEGIN
    PRINT 'Tạo bảng Luong...';
    CREATE TABLE Luong(
        ID_Luong VARCHAR(255),
        ID_NhanVien VARCHAR(255),
        MucLuong INT,
        PRIMARY KEY(ID_Luong),
        FOREIGN KEY(ID_NhanVien) REFERENCES NhanVien(ID_NhanVien)
    );
    PRINT '✓ Đã tạo bảng Luong';
END

GO

-- =============================================
-- BƯỚC 4: IMPORT DỮ LIỆU MẪU (NẾU BẢNG TRỐNG)
-- =============================================

PRINT '';
PRINT 'BƯỚC 4: Kiểm tra và import dữ liệu mẫu...';

-- Kiểm tra xem đã có dữ liệu chưa
IF (SELECT COUNT(*) FROM NhanVien) = 0
BEGIN
    PRINT 'Đang import dữ liệu mẫu...';
    PRINT 'LƯU Ý: Bạn cần chạy file HR-Data.sql để import dữ liệu';
    PRINT '✓ Sẵn sàng import dữ liệu';
END
ELSE
BEGIN
    DECLARE @RecordCount INT = (SELECT COUNT(*) FROM NhanVien);
    PRINT '✓ Đã có ' + CAST(@RecordCount AS VARCHAR) + ' bản ghi nhân viên';
END

GO

-- =============================================
-- BƯỚC 5: TẠO CÁC VIEWS
-- =============================================

PRINT '';
PRINT 'BƯỚC 5: Tạo các Views...';
PRINT 'Chạy script từ Physical-Implementation.sql...';

-- LƯU Ý: Thực tế bạn cần include nội dung từ Physical-Implementation.sql
-- Ở đây chỉ là template, bạn có thể copy các CREATE VIEW từ file đó

PRINT '✓ Sẵn sàng tạo Views (chạy Physical-Implementation.sql)';

GO

-- =============================================
-- BƯỚC 6: KIỂM TRA SAU TRIỂN KHAI
-- =============================================

PRINT '';
PRINT 'BƯỚC 6: Kiểm tra hệ thống sau triển khai...';

-- Kiểm tra bảng
DECLARE @TableCount INT = (SELECT COUNT(*) FROM sys.tables WHERE type = 'U');
PRINT 'Tổng số bảng: ' + CAST(@TableCount AS VARCHAR);

-- Kiểm tra views
DECLARE @ViewCount INT = (SELECT COUNT(*) FROM sys.views WHERE name LIKE 'View_%');
PRINT 'Tổng số Views: ' + CAST(@ViewCount AS VARCHAR);

-- Kiểm tra procedures
DECLARE @ProcCount INT = (SELECT COUNT(*) FROM sys.procedures WHERE name LIKE 'sp_%');
PRINT 'Tổng số Procedures: ' + CAST(@ProcCount AS VARCHAR);

-- Kiểm tra functions
DECLARE @FuncCount INT = (SELECT COUNT(*) FROM sys.objects WHERE type IN ('FN', 'IF', 'TF') AND name LIKE 'fn_%');
PRINT 'Tổng số Functions: ' + CAST(@FuncCount AS VARCHAR);

-- Kiểm tra triggers
DECLARE @TriggerCount INT = (SELECT COUNT(*) FROM sys.triggers WHERE name LIKE 'trg_%');
PRINT 'Tổng số Triggers: ' + CAST(@TriggerCount AS VARCHAR);

-- Kiểm tra indexes
DECLARE @IndexCount INT = (SELECT COUNT(*) FROM sys.indexes WHERE name LIKE 'IX_%');
PRINT 'Tổng số Indexes: ' + CAST(@IndexCount AS VARCHAR);

GO

-- =============================================
-- BƯỚC 7: TẠO BACKUP
-- =============================================

PRINT '';
PRINT 'BƯỚC 7: Tạo backup sau triển khai...';

/*
-- Uncomment để tạo backup
DECLARE @BackupFile NVARCHAR(500);
SET @BackupFile = N'$(BackupPath)QuanLyNhanSu_After_Deploy_' + 
                  CONVERT(VARCHAR, GETDATE(), 112) + '_' + 
                  REPLACE(CONVERT(VARCHAR, GETDATE(), 108), ':', '') + '.bak';

BACKUP DATABASE $(DatabaseName)
TO DISK = @BackupFile
WITH FORMAT, 
     NAME = 'Full Backup After Deployment',
     COMPRESSION;

PRINT '✓ Đã tạo backup tại: ' + @BackupFile;
*/

PRINT 'ℹ Uncomment code trong script để tạo backup tự động';

GO

-- =============================================
-- KẾT THÚC DEPLOYMENT
-- =============================================

PRINT '';
PRINT '==============================================';
PRINT 'HOÀN THÀNH TRIỂN KHAI HỆ THỐNG';
PRINT '==============================================';
PRINT '';
PRINT 'CÁC BƯỚC TIẾP THEO:';
PRINT '1. Chạy file Physical-Implementation.sql để tạo Views, Procedures, Functions, Triggers, Indexes';
PRINT '2. Chạy file Test-Physical-Implementation.sql để kiểm tra hệ thống';
PRINT '3. Cấu hình phân quyền người dùng';
PRINT '4. Thiết lập backup schedule';
PRINT '';
PRINT 'Xem chi tiết trong file README-Physical-Implementation.md';
PRINT '';
PRINT 'Chúc bạn triển khai thành công!';
GO
