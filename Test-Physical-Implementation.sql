-- =============================================
-- FILE TEST CÀI ĐẶT VẬT LÝ
-- Hệ Thống Quản Lý Nhân Viên Phân Tán
-- =============================================

USE QuanLyNhanSu;
GO

PRINT '==============================================';
PRINT 'BẮT ĐẦU TEST CÁC CHỨC NĂNG';
PRINT '==============================================';
GO

-- =============================================
-- 1. TEST CÁC VIEW PHÂN MẢNH DỮ LIỆU
-- =============================================

PRINT '';
PRINT '1. TEST VIEW PHÂN MẢNH DỮ LIỆU';
PRINT '------------------------------';

-- Test view nhân viên chi nhánh CN04 (Nha Trang)
PRINT 'Danh sách nhân viên chi nhánh Nha Trang (CN04):';
SELECT ID_NhanVien, HoTen, ID_ChiNhanh
FROM View_NhanVien_CN04;
GO

-- Test view lương cao cấp
PRINT '';
PRINT 'Danh sách nhân viên có lương cao cấp (>= 50 triệu):';
SELECT L.ID_Luong, L.ID_NhanVien, L.MucLuong
FROM View_Luong_CaoCap L;
GO

-- =============================================
-- 2. TEST CÁC STORED PROCEDURES
-- =============================================

PRINT '';
PRINT '2. TEST STORED PROCEDURES';
PRINT '-------------------------';

-- Test thêm nhân viên mới
PRINT '';
PRINT 'Test thêm nhân viên mới:';
EXEC sp_ThemNhanVien 
    @ID_NhanVien = 'NTNV41',
    @ID_DuAn = 'NTDA01',
    @ID_ChucVu = 'NTCV07',
    @ID_ChiNhanh = 'CN04',
    @ID_PhongBan = 'NTPB01',
    @HoTen = 'Test Nguyen Van A',
    @NgaySinh = '1995-05-15',
    @GioiTinh = 'Nam',
    @DanToc = 'Kinh',
    @CCCD = '001234567890',
    @SoDienThoai = '0987654321',
    @Email = 'test@gmail.com',
    @DiaChi = 'Nha Trang';
GO

-- Kiểm tra nhân viên vừa thêm
SELECT * FROM NhanVien WHERE ID_NhanVien = 'NTNV41';
GO

-- Test thêm lương cho nhân viên mới
PRINT '';
PRINT 'Test thêm lương cho nhân viên:';
EXEC sp_ThemLuong
    @ID_Luong = 'NTL41',
    @ID_NhanVien = 'NTNV41',
    @MucLuong = 35000000;
GO

-- Kiểm tra lương vừa thêm
SELECT * FROM Luong WHERE ID_NhanVien = 'NTNV41';
GO

-- Test cập nhật thông tin nhân viên
PRINT '';
PRINT 'Test cập nhật thông tin nhân viên:';
EXEC sp_CapNhatNhanVien
    @ID_NhanVien = 'NTNV41',
    @SoDienThoai = '0999888777',
    @Email = 'updated@gmail.com',
    @DiaChi = 'Khanh Hoa';
GO

-- Kiểm tra sau khi cập nhật
SELECT ID_NhanVien, HoTen, SoDienThoai, Email, DiaChi 
FROM NhanVien WHERE ID_NhanVien = 'NTNV41';
GO

-- Test cập nhật lương
PRINT '';
PRINT 'Test cập nhật lương:';
EXEC sp_CapNhatLuong
    @ID_NhanVien = 'NTNV41',
    @MucLuong = 40000000;
GO

-- Kiểm tra lương sau khi cập nhật
SELECT * FROM Luong WHERE ID_NhanVien = 'NTNV41';
GO

-- Kiểm tra log cập nhật lương
PRINT '';
PRINT 'Log cập nhật lương:';
SELECT * FROM LogCapNhatLuong ORDER BY NgayCapNhat DESC;
GO

-- Test chuyển phòng ban
PRINT '';
PRINT 'Test chuyển nhân viên sang phòng ban khác:';
EXEC sp_ChuyenPhongBan
    @ID_NhanVien = 'NTNV41',
    @ID_PhongBan_Moi = 'NTPB02';
GO

-- Kiểm tra sau khi chuyển phòng ban
SELECT ID_NhanVien, HoTen, ID_PhongBan
FROM NhanVien WHERE ID_NhanVien = 'NTNV41';
GO

-- =============================================
-- 3. TEST CÁC FUNCTIONS
-- =============================================

PRINT '';
PRINT '3. TEST FUNCTIONS';
PRINT '-----------------';

-- Test tính tổng nhân viên theo chi nhánh
PRINT '';
PRINT 'Tổng số nhân viên chi nhánh CN04:';
SELECT dbo.fn_TongNhanVienTheoChiNhanh('CN04') AS TongNhanVien;
GO

-- Test tính tổng nhân viên theo phòng ban
PRINT '';
PRINT 'Tổng số nhân viên phòng ban NTPB01:';
SELECT dbo.fn_TongNhanVienTheoPhongBan('NTPB01') AS TongNhanVien;
GO

-- Test lấy tên chức vụ
PRINT '';
PRINT 'Tên chức vụ NTCV01:';
SELECT dbo.fn_LayTenChucVu('NTCV01') AS TenChucVu;
GO

-- Test tính tuổi
PRINT '';
PRINT 'Tính tuổi của nhân viên sinh năm 1990:';
SELECT dbo.fn_TinhTuoi('1990-01-01') AS Tuoi;
GO

-- Test tính tổng lương theo phòng ban
PRINT '';
PRINT 'Tổng lương phòng ban NTPB01:';
SELECT dbo.fn_TongLuongTheoPhongBan('NTPB01') AS TongLuong;
GO

-- Test tính lương trung bình theo chi nhánh
PRINT '';
PRINT 'Lương trung bình chi nhánh CN04:';
SELECT dbo.fn_LuongTrungBinhTheoChiNhanh('CN04') AS LuongTrungBinh;
GO

-- =============================================
-- 4. TEST CÁC VIEW BÁO CÁO
-- =============================================

PRINT '';
PRINT '4. TEST CÁC VIEW BÁO CÁO';
PRINT '------------------------';

-- Test view thông tin nhân viên chi tiết
PRINT '';
PRINT 'Top 5 nhân viên với thông tin chi tiết:';
SELECT TOP 5 * FROM View_ThongTinNhanVienChiTiet;
GO

-- Test view thống kê theo phòng ban
PRINT '';
PRINT 'Thống kê nhân viên theo phòng ban:';
SELECT * FROM View_ThongKeTheoPhongBan;
GO

-- Test view thống kê theo chi nhánh
PRINT '';
PRINT 'Thống kê nhân viên theo chi nhánh:';
SELECT * FROM View_ThongKeTheoChiNhanh;
GO

-- Test view thống kê theo chức vụ
PRINT '';
PRINT 'Thống kê nhân viên theo chức vụ:';
SELECT * FROM View_ThongKeTheoChucVu;
GO

-- Test view dự án và nhân viên
PRINT '';
PRINT 'Thống kê dự án và nhân viên tham gia:';
SELECT ID_DuAn, TenDuAn, TenPhongBan, SoLuongNhanVien
FROM View_DuAnVaNhanVien;
GO

-- Test view nhân viên lương cao nhất theo phòng ban
PRINT '';
PRINT 'Nhân viên có lương cao nhất mỗi phòng ban:';
SELECT * FROM View_NhanVienLuongCaoNhatTheoPhongBan;
GO

-- =============================================
-- 5. TEST TRIGGERS
-- =============================================

PRINT '';
PRINT '5. TEST TRIGGERS';
PRINT '----------------';

-- Test trigger kiểm tra tuổi (phải fail)
PRINT '';
PRINT 'Test trigger kiểm tra tuổi (thêm nhân viên dưới 18 tuổi - phải lỗi):';
BEGIN TRY
    EXEC sp_ThemNhanVien 
        @ID_NhanVien = 'NTNV42',
        @ID_DuAn = 'NTDA01',
        @ID_ChucVu = 'NTCV07',
        @ID_ChiNhanh = 'CN04',
        @ID_PhongBan = 'NTPB01',
        @HoTen = 'Test Nguyen Van B',
        @NgaySinh = '2015-05-15',
        @GioiTinh = 'Nam',
        @DanToc = 'Kinh',
        @CCCD = '001234567891',
        @SoDienThoai = '0987654322',
        @Email = 'testb@gmail.com',
        @DiaChi = 'Nha Trang';
    PRINT 'CẢNH BÁO: Trigger không hoạt động đúng!';
END TRY
BEGIN CATCH
    PRINT 'OK: Trigger đã chặn nhân viên dưới 18 tuổi';
    PRINT ERROR_MESSAGE();
END CATCH
GO

-- Test trigger kiểm tra mức lương (phải fail)
PRINT '';
PRINT 'Test trigger kiểm tra mức lương âm (phải lỗi):';
BEGIN TRY
    INSERT INTO Luong (ID_Luong, ID_NhanVien, MucLuong)
    VALUES ('NTL99', 'NTNV01', -1000000);
    PRINT 'CẢNH BÁO: Trigger không hoạt động đúng!';
END TRY
BEGIN CATCH
    PRINT 'OK: Trigger đã chặn mức lương âm';
    PRINT ERROR_MESSAGE();
END CATCH
GO

-- Test xóa nhân viên và kiểm tra log
PRINT '';
PRINT 'Test xóa nhân viên và kiểm tra log:';
EXEC sp_XoaNhanVien @ID_NhanVien = 'NTNV41';
GO

-- Kiểm tra log xóa nhân viên
PRINT '';
PRINT 'Log xóa nhân viên:';
SELECT * FROM LogXoaNhanVien ORDER BY NgayXoa DESC;
GO

-- =============================================
-- 6. TEST CÁC TRUY VẤN PHỨC TẠP
-- =============================================

PRINT '';
PRINT '6. TEST CÁC TRUY VẤN PHỨC TẠP';
PRINT '-----------------------------';

-- Truy vấn 1: Tìm nhân viên có lương cao nhất
PRINT '';
PRINT 'Top 5 nhân viên có lương cao nhất:';
SELECT TOP 5 
    NV.ID_NhanVien,
    NV.HoTen,
    CV.TenChucVu,
    PB.TenPhongBan,
    CN.TenChiNhanh,
    L.MucLuong
FROM NhanVien NV
INNER JOIN Luong L ON NV.ID_NhanVien = L.ID_NhanVien
INNER JOIN ChucVu CV ON NV.ID_ChucVu = CV.ID_ChucVu
INNER JOIN PhongBan PB ON NV.ID_PhongBan = PB.ID_PhongBan
INNER JOIN ChiNhanh CN ON NV.ID_ChiNhanh = CN.ID_ChiNhanh
ORDER BY L.MucLuong DESC;
GO

-- Truy vấn 2: Thống kê nhân viên theo độ tuổi
PRINT '';
PRINT 'Thống kê nhân viên theo nhóm tuổi:';
SELECT 
    CASE 
        WHEN dbo.fn_TinhTuoi(NgaySinh) < 30 THEN 'Duoi 30 tuoi'
        WHEN dbo.fn_TinhTuoi(NgaySinh) BETWEEN 30 AND 40 THEN '30-40 tuoi'
        ELSE 'Tren 40 tuoi'
    END AS NhomTuoi,
    COUNT(*) AS SoLuong,
    AVG(L.MucLuong) AS LuongTrungBinh
FROM NhanVien NV
LEFT JOIN Luong L ON NV.ID_NhanVien = L.ID_NhanVien
GROUP BY 
    CASE 
        WHEN dbo.fn_TinhTuoi(NgaySinh) < 30 THEN 'Duoi 30 tuoi'
        WHEN dbo.fn_TinhTuoi(NgaySinh) BETWEEN 30 AND 40 THEN '30-40 tuoi'
        ELSE 'Tren 40 tuoi'
    END;
GO

-- Truy vấn 3: Thống kê theo giới tính
PRINT '';
PRINT 'Thống kê nhân viên theo giới tính:';
SELECT 
    GioiTinh,
    COUNT(*) AS SoLuong,
    AVG(L.MucLuong) AS LuongTrungBinh,
    MAX(L.MucLuong) AS LuongCaoNhat,
    MIN(L.MucLuong) AS LuongThapNhat
FROM NhanVien NV
LEFT JOIN Luong L ON NV.ID_NhanVien = L.ID_NhanVien
GROUP BY GioiTinh;
GO

-- Truy vấn 4: Chi nhánh có tổng lương cao nhất
PRINT '';
PRINT 'Chi nhánh có tổng quỹ lương cao nhất:';
SELECT TOP 1
    CN.TenChiNhanh,
    COUNT(NV.ID_NhanVien) AS SoLuongNhanVien,
    SUM(L.MucLuong) AS TongQuyLuong,
    AVG(L.MucLuong) AS LuongTrungBinh
FROM ChiNhanh CN
INNER JOIN NhanVien NV ON CN.ID_ChiNhanh = NV.ID_ChiNhanh
INNER JOIN Luong L ON NV.ID_NhanVien = L.ID_NhanVien
GROUP BY CN.ID_ChiNhanh, CN.TenChiNhanh
ORDER BY TongQuyLuong DESC;
GO

-- Truy vấn 5: Phòng ban có lương trung bình cao nhất
PRINT '';
PRINT 'Phòng ban có lương trung bình cao nhất:';
SELECT TOP 1
    PB.TenPhongBan,
    CN.TenChiNhanh,
    COUNT(NV.ID_NhanVien) AS SoLuongNhanVien,
    AVG(L.MucLuong) AS LuongTrungBinh
FROM PhongBan PB
INNER JOIN ChiNhanh CN ON PB.ID_ChiNhanh = CN.ID_ChiNhanh
INNER JOIN NhanVien NV ON PB.ID_PhongBan = NV.ID_PhongBan
INNER JOIN Luong L ON NV.ID_NhanVien = L.ID_NhanVien
GROUP BY PB.ID_PhongBan, PB.TenPhongBan, CN.TenChiNhanh
ORDER BY LuongTrungBinh DESC;
GO

-- Truy vấn 6: Danh sách dự án và tổng lương nhân viên tham gia
PRINT '';
PRINT 'Dự án và tổng lương nhân viên tham gia:';
SELECT 
    DA.TenDuAn,
    DA.NgayBatDau,
    DA.ThoiHan,
    PB.TenPhongBan,
    COUNT(NV.ID_NhanVien) AS SoLuongNhanVien,
    SUM(L.MucLuong) AS TongLuong
FROM DuAn DA
LEFT JOIN PhongBan PB ON DA.ID_PhongBan = PB.ID_PhongBan
LEFT JOIN NhanVien NV ON DA.ID_DuAn = NV.ID_DuAn
LEFT JOIN Luong L ON NV.ID_NhanVien = L.ID_NhanVien
GROUP BY DA.ID_DuAn, DA.TenDuAn, DA.NgayBatDau, DA.ThoiHan, PB.TenPhongBan
ORDER BY TongLuong DESC;
GO

-- =============================================
-- 7. TEST HIỆU SUẤT VỚI INDEX
-- =============================================

PRINT '';
PRINT '7. TEST HIỆU SUẤT';
PRINT '-----------------';

-- Kiểm tra các index đã tạo
PRINT '';
PRINT 'Danh sách indexes trên bảng NhanVien:';
SELECT 
    i.name AS IndexName,
    i.type_desc AS IndexType,
    c.name AS ColumnName
FROM sys.indexes i
INNER JOIN sys.index_columns ic ON i.object_id = ic.object_id AND i.index_id = ic.index_id
INNER JOIN sys.columns c ON ic.object_id = c.object_id AND ic.column_id = c.column_id
WHERE i.object_id = OBJECT_ID('NhanVien')
ORDER BY i.name, ic.key_ordinal;
GO

-- Test truy vấn sử dụng index
PRINT '';
PRINT 'Test truy vấn với index (tìm nhân viên theo chi nhánh):';
SET STATISTICS TIME ON;
SET STATISTICS IO ON;

SELECT * FROM NhanVien WHERE ID_ChiNhanh = 'CN04';

SET STATISTICS TIME OFF;
SET STATISTICS IO OFF;
GO

-- =============================================
-- KẾT THÚC TEST
-- =============================================

PRINT '';
PRINT '==============================================';
PRINT 'HOÀN THÀNH TEST CÁC CHỨC NĂNG';
PRINT '==============================================';
GO
