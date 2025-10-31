-- =============================================
-- PHẦN 3: CÀI ĐẶT VẬT LÝ THỰC TẾ
-- Hệ Thống Quản Lý Nhân Viên Phân Tán
-- =============================================

USE QuanLyNhanSu;
GO

-- =============================================
-- 3.1. PHÂN MẢNH DỮ LIỆU (DATA FRAGMENTATION)
-- =============================================

-- Phân mảnh bảng NhanVien theo Chi nhánh (Horizontal Fragmentation)
-- Tạo view cho từng chi nhánh

-- View nhân viên chi nhánh Hue (CN01)
CREATE VIEW View_NhanVien_CN01 AS
SELECT * FROM NhanVien
WHERE ID_ChiNhanh = 'CN01';
GO

-- View nhân viên chi nhánh Nam Định (CN02)
CREATE VIEW View_NhanVien_CN02 AS
SELECT * FROM NhanVien
WHERE ID_ChiNhanh = 'CN02';
GO

-- View nhân viên chi nhánh Vinh (CN03)
CREATE VIEW View_NhanVien_CN03 AS
SELECT * FROM NhanVien
WHERE ID_ChiNhanh = 'CN03';
GO

-- View nhân viên chi nhánh Nha Trang (CN04)
CREATE VIEW View_NhanVien_CN04 AS
SELECT * FROM NhanVien
WHERE ID_ChiNhanh = 'CN04';
GO

-- View nhân viên chi nhánh Thái Bình (CN05)
CREATE VIEW View_NhanVien_CN05 AS
SELECT * FROM NhanVien
WHERE ID_ChiNhanh = 'CN05';
GO

-- Phân mảnh bảng Lương theo mức lương (Horizontal Fragmentation)
CREATE VIEW View_Luong_CaoCap AS
SELECT * FROM Luong
WHERE MucLuong >= 50000000;
GO

CREATE VIEW View_Luong_TrungCap AS
SELECT * FROM Luong
WHERE MucLuong >= 30000000 AND MucLuong < 50000000;
GO

CREATE VIEW View_Luong_CoBan AS
SELECT * FROM Luong
WHERE MucLuong < 30000000;
GO

-- =============================================
-- 3.2. STORED PROCEDURES
-- =============================================

-- Procedure: Thêm nhân viên mới
CREATE PROCEDURE sp_ThemNhanVien
    @ID_NhanVien VARCHAR(255),
    @ID_DuAn VARCHAR(255),
    @ID_ChucVu VARCHAR(255),
    @ID_ChiNhanh VARCHAR(255),
    @ID_PhongBan VARCHAR(255),
    @HoTen VARCHAR(255),
    @NgaySinh DATE,
    @GioiTinh VARCHAR(255),
    @DanToc VARCHAR(255),
    @CCCD VARCHAR(255),
    @SoDienThoai VARCHAR(255),
    @Email VARCHAR(255),
    @DiaChi VARCHAR(255)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        
        -- Kiểm tra ID nhân viên đã tồn tại chưa
        IF EXISTS (SELECT 1 FROM NhanVien WHERE ID_NhanVien = @ID_NhanVien)
        BEGIN
            RAISERROR('Mã nhân viên đã tồn tại!', 16, 1);
            RETURN;
        END
        
        -- Kiểm tra CCCD đã tồn tại chưa
        IF EXISTS (SELECT 1 FROM NhanVien WHERE CCCD = @CCCD)
        BEGIN
            RAISERROR('Số CCCD đã tồn tại!', 16, 1);
            RETURN;
        END
        
        -- Thêm nhân viên
        INSERT INTO NhanVien (ID_NhanVien, ID_DuAn, ID_ChucVu, ID_ChiNhanh, 
                             ID_PhongBan, HoTen, NgaySinh, GioiTinh, 
                             DanToc, CCCD, SoDienThoai, Email, DiaChi)
        VALUES (@ID_NhanVien, @ID_DuAn, @ID_ChucVu, @ID_ChiNhanh, 
                @ID_PhongBan, @HoTen, @NgaySinh, @GioiTinh, 
                @DanToc, @CCCD, @SoDienThoai, @Email, @DiaChi);
        
        COMMIT TRANSACTION
        PRINT 'Thêm nhân viên thành công!';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO

-- Procedure: Cập nhật thông tin nhân viên
CREATE PROCEDURE sp_CapNhatNhanVien
    @ID_NhanVien VARCHAR(255),
    @SoDienThoai VARCHAR(255) = NULL,
    @Email VARCHAR(255) = NULL,
    @DiaChi VARCHAR(255) = NULL
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        
        -- Kiểm tra nhân viên có tồn tại không
        IF NOT EXISTS (SELECT 1 FROM NhanVien WHERE ID_NhanVien = @ID_NhanVien)
        BEGIN
            RAISERROR('Không tìm thấy nhân viên!', 16, 1);
            RETURN;
        END
        
        -- Cập nhật thông tin
        UPDATE NhanVien
        SET SoDienThoai = ISNULL(@SoDienThoai, SoDienThoai),
            Email = ISNULL(@Email, Email),
            DiaChi = ISNULL(@DiaChi, DiaChi)
        WHERE ID_NhanVien = @ID_NhanVien;
        
        COMMIT TRANSACTION
        PRINT 'Cập nhật thông tin nhân viên thành công!';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO

-- Procedure: Xóa nhân viên
CREATE PROCEDURE sp_XoaNhanVien
    @ID_NhanVien VARCHAR(255)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        
        -- Kiểm tra nhân viên có tồn tại không
        IF NOT EXISTS (SELECT 1 FROM NhanVien WHERE ID_NhanVien = @ID_NhanVien)
        BEGIN
            RAISERROR('Không tìm thấy nhân viên!', 16, 1);
            RETURN;
        END
        
        -- Xóa lương của nhân viên trước
        DELETE FROM Luong WHERE ID_NhanVien = @ID_NhanVien;
        
        -- Xóa nhân viên
        DELETE FROM NhanVien WHERE ID_NhanVien = @ID_NhanVien;
        
        COMMIT TRANSACTION
        PRINT 'Xóa nhân viên thành công!';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO

-- Procedure: Thêm lương cho nhân viên
CREATE PROCEDURE sp_ThemLuong
    @ID_Luong VARCHAR(255),
    @ID_NhanVien VARCHAR(255),
    @MucLuong INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        
        -- Kiểm tra nhân viên có tồn tại không
        IF NOT EXISTS (SELECT 1 FROM NhanVien WHERE ID_NhanVien = @ID_NhanVien)
        BEGIN
            RAISERROR('Không tìm thấy nhân viên!', 16, 1);
            RETURN;
        END
        
        -- Kiểm tra ID lương đã tồn tại chưa
        IF EXISTS (SELECT 1 FROM Luong WHERE ID_Luong = @ID_Luong)
        BEGIN
            RAISERROR('Mã lương đã tồn tại!', 16, 1);
            RETURN;
        END
        
        -- Kiểm tra nhân viên đã có lương chưa
        IF EXISTS (SELECT 1 FROM Luong WHERE ID_NhanVien = @ID_NhanVien)
        BEGIN
            RAISERROR('Nhân viên đã có thông tin lương!', 16, 1);
            RETURN;
        END
        
        -- Thêm lương
        INSERT INTO Luong (ID_Luong, ID_NhanVien, MucLuong)
        VALUES (@ID_Luong, @ID_NhanVien, @MucLuong);
        
        COMMIT TRANSACTION
        PRINT 'Thêm lương thành công!';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO

-- Procedure: Cập nhật lương
CREATE PROCEDURE sp_CapNhatLuong
    @ID_NhanVien VARCHAR(255),
    @MucLuong INT
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        
        -- Kiểm tra nhân viên có tồn tại không
        IF NOT EXISTS (SELECT 1 FROM NhanVien WHERE ID_NhanVien = @ID_NhanVien)
        BEGIN
            RAISERROR('Không tìm thấy nhân viên!', 16, 1);
            RETURN;
        END
        
        -- Cập nhật lương
        UPDATE Luong
        SET MucLuong = @MucLuong
        WHERE ID_NhanVien = @ID_NhanVien;
        
        COMMIT TRANSACTION
        PRINT 'Cập nhật lương thành công!';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO

-- Procedure: Chuyển nhân viên sang phòng ban khác
CREATE PROCEDURE sp_ChuyenPhongBan
    @ID_NhanVien VARCHAR(255),
    @ID_PhongBan_Moi VARCHAR(255)
AS
BEGIN
    BEGIN TRY
        BEGIN TRANSACTION
        
        -- Kiểm tra nhân viên có tồn tại không
        IF NOT EXISTS (SELECT 1 FROM NhanVien WHERE ID_NhanVien = @ID_NhanVien)
        BEGIN
            RAISERROR('Không tìm thấy nhân viên!', 16, 1);
            RETURN;
        END
        
        -- Kiểm tra phòng ban có tồn tại không
        IF NOT EXISTS (SELECT 1 FROM PhongBan WHERE ID_PhongBan = @ID_PhongBan_Moi)
        BEGIN
            RAISERROR('Không tìm thấy phòng ban!', 16, 1);
            RETURN;
        END
        
        -- Cập nhật phòng ban
        UPDATE NhanVien
        SET ID_PhongBan = @ID_PhongBan_Moi
        WHERE ID_NhanVien = @ID_NhanVien;
        
        COMMIT TRANSACTION
        PRINT 'Chuyển phòng ban thành công!';
    END TRY
    BEGIN CATCH
        ROLLBACK TRANSACTION
        DECLARE @ErrorMessage NVARCHAR(4000) = ERROR_MESSAGE();
        RAISERROR(@ErrorMessage, 16, 1);
    END CATCH
END
GO

-- =============================================
-- 3.3. FUNCTIONS
-- =============================================

-- Function: Tính tổng số nhân viên theo chi nhánh
CREATE FUNCTION fn_TongNhanVienTheoChiNhanh(@ID_ChiNhanh VARCHAR(255))
RETURNS INT
AS
BEGIN
    DECLARE @TongNV INT;
    SELECT @TongNV = COUNT(*)
    FROM NhanVien
    WHERE ID_ChiNhanh = @ID_ChiNhanh;
    RETURN @TongNV;
END
GO

-- Function: Tính tổng số nhân viên theo phòng ban
CREATE FUNCTION fn_TongNhanVienTheoPhongBan(@ID_PhongBan VARCHAR(255))
RETURNS INT
AS
BEGIN
    DECLARE @TongNV INT;
    SELECT @TongNV = COUNT(*)
    FROM NhanVien
    WHERE ID_PhongBan = @ID_PhongBan;
    RETURN @TongNV;
END
GO

-- Function: Lấy tên chức vụ theo ID
CREATE FUNCTION fn_LayTenChucVu(@ID_ChucVu VARCHAR(255))
RETURNS VARCHAR(255)
AS
BEGIN
    DECLARE @TenChucVu VARCHAR(255);
    SELECT @TenChucVu = TenChucVu
    FROM ChucVu
    WHERE ID_ChucVu = @ID_ChucVu;
    RETURN @TenChucVu;
END
GO

-- Function: Tính tuổi của nhân viên
CREATE FUNCTION fn_TinhTuoi(@NgaySinh DATE)
RETURNS INT
AS
BEGIN
    RETURN DATEDIFF(YEAR, @NgaySinh, GETDATE()) - 
           CASE WHEN DATEADD(YEAR, DATEDIFF(YEAR, @NgaySinh, GETDATE()), @NgaySinh) > GETDATE() 
           THEN 1 ELSE 0 END;
END
GO

-- Function: Tính tổng lương theo phòng ban
CREATE FUNCTION fn_TongLuongTheoPhongBan(@ID_PhongBan VARCHAR(255))
RETURNS INT
AS
BEGIN
    DECLARE @TongLuong INT;
    SELECT @TongLuong = SUM(L.MucLuong)
    FROM NhanVien NV
    INNER JOIN Luong L ON NV.ID_NhanVien = L.ID_NhanVien
    WHERE NV.ID_PhongBan = @ID_PhongBan;
    RETURN ISNULL(@TongLuong, 0);
END
GO

-- Function: Tính lương trung bình theo chi nhánh
CREATE FUNCTION fn_LuongTrungBinhTheoChiNhanh(@ID_ChiNhanh VARCHAR(255))
RETURNS INT
AS
BEGIN
    DECLARE @LuongTB INT;
    SELECT @LuongTB = AVG(L.MucLuong)
    FROM NhanVien NV
    INNER JOIN Luong L ON NV.ID_NhanVien = L.ID_NhanVien
    WHERE NV.ID_ChiNhanh = @ID_ChiNhanh;
    RETURN ISNULL(@LuongTB, 0);
END
GO

-- =============================================
-- 3.4. TRIGGERS
-- =============================================

-- Trigger: Kiểm tra tuổi nhân viên khi thêm/cập nhật (>= 18 tuổi)
CREATE TRIGGER trg_KiemTraTuoiNhanVien
ON NhanVien
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted
        WHERE DATEDIFF(YEAR, NgaySinh, GETDATE()) < 18
    )
    BEGIN
        RAISERROR('Nhân viên phải đủ 18 tuổi trở lên!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END
GO

-- Trigger: Tự động ghi log khi xóa nhân viên
CREATE TABLE LogXoaNhanVien (
    ID_Log INT IDENTITY(1,1) PRIMARY KEY,
    ID_NhanVien VARCHAR(255),
    HoTen VARCHAR(255),
    NgayXoa DATETIME DEFAULT GETDATE(),
    NguoiXoa VARCHAR(255) DEFAULT SUSER_SNAME()
);
GO

CREATE TRIGGER trg_LogXoaNhanVien
ON NhanVien
FOR DELETE
AS
BEGIN
    INSERT INTO LogXoaNhanVien (ID_NhanVien, HoTen)
    SELECT ID_NhanVien, HoTen
    FROM deleted;
END
GO

-- Trigger: Kiểm tra mức lương hợp lệ (>= 0)
CREATE TRIGGER trg_KiemTraMucLuong
ON Luong
FOR INSERT, UPDATE
AS
BEGIN
    IF EXISTS (
        SELECT 1 FROM inserted
        WHERE MucLuong < 0
    )
    BEGIN
        RAISERROR('Mức lương phải lớn hơn hoặc bằng 0!', 16, 1);
        ROLLBACK TRANSACTION;
    END
END
GO

-- Trigger: Ghi log khi cập nhật lương
CREATE TABLE LogCapNhatLuong (
    ID_Log INT IDENTITY(1,1) PRIMARY KEY,
    ID_NhanVien VARCHAR(255),
    MucLuongCu INT,
    MucLuongMoi INT,
    NgayCapNhat DATETIME DEFAULT GETDATE(),
    NguoiCapNhat VARCHAR(255) DEFAULT SUSER_SNAME()
);
GO

CREATE TRIGGER trg_LogCapNhatLuong
ON Luong
FOR UPDATE
AS
BEGIN
    INSERT INTO LogCapNhatLuong (ID_NhanVien, MucLuongCu, MucLuongMoi)
    SELECT d.ID_NhanVien, d.MucLuong, i.MucLuong
    FROM deleted d
    INNER JOIN inserted i ON d.ID_Luong = i.ID_Luong
    WHERE d.MucLuong <> i.MucLuong;
END
GO

-- =============================================
-- 3.5. VIEWS - BÁO CÁO VÀ TRUY VẤN
-- =============================================

-- View: Thông tin nhân viên chi tiết
CREATE VIEW View_ThongTinNhanVienChiTiet AS
SELECT 
    NV.ID_NhanVien,
    NV.HoTen,
    NV.NgaySinh,
    dbo.fn_TinhTuoi(NV.NgaySinh) AS Tuoi,
    NV.GioiTinh,
    NV.DanToc,
    NV.CCCD,
    NV.SoDienThoai,
    NV.Email,
    NV.DiaChi,
    CV.TenChucVu,
    CV.BacLuong,
    PB.TenPhongBan,
    CN.TenChiNhanh,
    DA.TenDuAn,
    L.MucLuong
FROM NhanVien NV
LEFT JOIN ChucVu CV ON NV.ID_ChucVu = CV.ID_ChucVu
LEFT JOIN PhongBan PB ON NV.ID_PhongBan = PB.ID_PhongBan
LEFT JOIN ChiNhanh CN ON NV.ID_ChiNhanh = CN.ID_ChiNhanh
LEFT JOIN DuAn DA ON NV.ID_DuAn = DA.ID_DuAn
LEFT JOIN Luong L ON NV.ID_NhanVien = L.ID_NhanVien;
GO

-- View: Thống kê nhân viên theo phòng ban
CREATE VIEW View_ThongKeTheoPhongBan AS
SELECT 
    PB.ID_PhongBan,
    PB.TenPhongBan,
    CN.TenChiNhanh,
    COUNT(NV.ID_NhanVien) AS SoLuongNhanVien,
    AVG(L.MucLuong) AS LuongTrungBinh,
    SUM(L.MucLuong) AS TongLuong,
    MAX(L.MucLuong) AS LuongCaoNhat,
    MIN(L.MucLuong) AS LuongThapNhat
FROM PhongBan PB
LEFT JOIN ChiNhanh CN ON PB.ID_ChiNhanh = CN.ID_ChiNhanh
LEFT JOIN NhanVien NV ON PB.ID_PhongBan = NV.ID_PhongBan
LEFT JOIN Luong L ON NV.ID_NhanVien = L.ID_NhanVien
GROUP BY PB.ID_PhongBan, PB.TenPhongBan, CN.TenChiNhanh;
GO

-- View: Thống kê nhân viên theo chi nhánh
CREATE VIEW View_ThongKeTheoChiNhanh AS
SELECT 
    CN.ID_ChiNhanh,
    CN.TenChiNhanh,
    CN.DiaChi,
    COUNT(NV.ID_NhanVien) AS SoLuongNhanVien,
    AVG(L.MucLuong) AS LuongTrungBinh,
    SUM(L.MucLuong) AS TongLuong
FROM ChiNhanh CN
LEFT JOIN NhanVien NV ON CN.ID_ChiNhanh = NV.ID_ChiNhanh
LEFT JOIN Luong L ON NV.ID_NhanVien = L.ID_NhanVien
GROUP BY CN.ID_ChiNhanh, CN.TenChiNhanh, CN.DiaChi;
GO

-- View: Thống kê nhân viên theo chức vụ
CREATE VIEW View_ThongKeTheoChucVu AS
SELECT 
    CV.ID_ChucVu,
    CV.TenChucVu,
    CV.BacLuong,
    COUNT(NV.ID_NhanVien) AS SoLuongNhanVien,
    AVG(L.MucLuong) AS LuongTrungBinh
FROM ChucVu CV
LEFT JOIN NhanVien NV ON CV.ID_ChucVu = NV.ID_ChucVu
LEFT JOIN Luong L ON NV.ID_NhanVien = L.ID_NhanVien
GROUP BY CV.ID_ChucVu, CV.TenChucVu, CV.BacLuong;
GO

-- View: Danh sách dự án và nhân viên tham gia
CREATE VIEW View_DuAnVaNhanVien AS
SELECT 
    DA.ID_DuAn,
    DA.TenDuAn,
    DA.NgayBatDau,
    DA.ThoiHan,
    DA.MoTa,
    PB.TenPhongBan,
    COUNT(NV.ID_NhanVien) AS SoLuongNhanVien,
    STRING_AGG(NV.HoTen, ', ') AS DanhSachNhanVien
FROM DuAn DA
LEFT JOIN PhongBan PB ON DA.ID_PhongBan = PB.ID_PhongBan
LEFT JOIN NhanVien NV ON DA.ID_DuAn = NV.ID_DuAn
GROUP BY DA.ID_DuAn, DA.TenDuAn, DA.NgayBatDau, DA.ThoiHan, DA.MoTa, PB.TenPhongBan;
GO

-- View: Nhân viên có lương cao nhất mỗi phòng ban
CREATE VIEW View_NhanVienLuongCaoNhatTheoPhongBan AS
SELECT 
    NV.ID_PhongBan,
    PB.TenPhongBan,
    NV.ID_NhanVien,
    NV.HoTen,
    CV.TenChucVu,
    L.MucLuong
FROM NhanVien NV
INNER JOIN Luong L ON NV.ID_NhanVien = L.ID_NhanVien
INNER JOIN PhongBan PB ON NV.ID_PhongBan = PB.ID_PhongBan
INNER JOIN ChucVu CV ON NV.ID_ChucVu = CV.ID_ChucVu
WHERE L.MucLuong = (
    SELECT MAX(L2.MucLuong)
    FROM NhanVien NV2
    INNER JOIN Luong L2 ON NV2.ID_NhanVien = L2.ID_NhanVien
    WHERE NV2.ID_PhongBan = NV.ID_PhongBan
);
GO

-- =============================================
-- 3.6. INDEXES - TỐI ƯU HÓA TRUY VẤN
-- =============================================

-- Index cho bảng NhanVien
CREATE NONCLUSTERED INDEX IX_NhanVien_ChiNhanh ON NhanVien(ID_ChiNhanh);
CREATE NONCLUSTERED INDEX IX_NhanVien_PhongBan ON NhanVien(ID_PhongBan);
CREATE NONCLUSTERED INDEX IX_NhanVien_ChucVu ON NhanVien(ID_ChucVu);
CREATE NONCLUSTERED INDEX IX_NhanVien_DuAn ON NhanVien(ID_DuAn);
CREATE NONCLUSTERED INDEX IX_NhanVien_CCCD ON NhanVien(CCCD);
CREATE NONCLUSTERED INDEX IX_NhanVien_Email ON NhanVien(Email);

-- Index cho bảng Luong
CREATE NONCLUSTERED INDEX IX_Luong_NhanVien ON Luong(ID_NhanVien);
CREATE NONCLUSTERED INDEX IX_Luong_MucLuong ON Luong(MucLuong);

-- Index cho bảng PhongBan
CREATE NONCLUSTERED INDEX IX_PhongBan_ChiNhanh ON PhongBan(ID_ChiNhanh);

-- Index cho bảng DuAn
CREATE NONCLUSTERED INDEX IX_DuAn_PhongBan ON DuAn(ID_PhongBan);
CREATE NONCLUSTERED INDEX IX_DuAn_NgayBatDau ON DuAn(NgayBatDau);

-- Index cho bảng ChinhSach
CREATE NONCLUSTERED INDEX IX_ChinhSach_ChiNhanh ON ChinhSach(ID_ChiNhanh);

-- =============================================
-- 3.7. PHÂN QUYỀN NGƯỜI DÙNG
-- =============================================

-- Tạo role cho các cấp độ người dùng

-- Role: Admin (Quản trị viên) - Toàn quyền
CREATE ROLE Role_Admin;
GRANT ALL PRIVILEGES ON DATABASE::QuanLyNhanSu TO Role_Admin;
GO

-- Role: Quản lý chi nhánh - Quyền quản lý nhân viên trong chi nhánh
CREATE ROLE Role_QuanLyChiNhanh;
GRANT SELECT, INSERT, UPDATE ON NhanVien TO Role_QuanLyChiNhanh;
GRANT SELECT, INSERT, UPDATE ON Luong TO Role_QuanLyChiNhanh;
GRANT SELECT ON ChiNhanh TO Role_QuanLyChiNhanh;
GRANT SELECT ON PhongBan TO Role_QuanLyChiNhanh;
GRANT SELECT ON ChucVu TO Role_QuanLyChiNhanh;
GRANT SELECT ON DuAn TO Role_QuanLyChiNhanh;
GRANT EXECUTE ON sp_ThemNhanVien TO Role_QuanLyChiNhanh;
GRANT EXECUTE ON sp_CapNhatNhanVien TO Role_QuanLyChiNhanh;
GRANT EXECUTE ON sp_ThemLuong TO Role_QuanLyChiNhanh;
GRANT EXECUTE ON sp_CapNhatLuong TO Role_QuanLyChiNhanh;
GO

-- Role: Quản lý phòng ban - Quyền xem và cập nhật nhân viên trong phòng ban
CREATE ROLE Role_QuanLyPhongBan;
GRANT SELECT, UPDATE ON NhanVien TO Role_QuanLyPhongBan;
GRANT SELECT ON Luong TO Role_QuanLyPhongBan;
GRANT SELECT ON PhongBan TO Role_QuanLyPhongBan;
GRANT SELECT ON ChucVu TO Role_QuanLyPhongBan;
GRANT SELECT ON DuAn TO Role_QuanLyPhongBan;
GRANT EXECUTE ON sp_CapNhatNhanVien TO Role_QuanLyPhongBan;
GO

-- Role: Nhân viên - Chỉ xem thông tin
CREATE ROLE Role_NhanVien;
GRANT SELECT ON View_ThongTinNhanVienChiTiet TO Role_NhanVien;
GRANT SELECT ON PhongBan TO Role_NhanVien;
GRANT SELECT ON ChiNhanh TO Role_NhanVien;
GRANT SELECT ON DuAn TO Role_NhanVien;
GO

-- Role: Kế toán - Quản lý thông tin lương
CREATE ROLE Role_KeToan;
GRANT SELECT, INSERT, UPDATE ON Luong TO Role_KeToan;
GRANT SELECT ON NhanVien TO Role_KeToan;
GRANT SELECT ON ChucVu TO Role_KeToan;
GRANT EXECUTE ON sp_ThemLuong TO Role_KeToan;
GRANT EXECUTE ON sp_CapNhatLuong TO Role_KeToan;
GO

-- =============================================
-- 3.8. BACKUP VÀ KHÔI PHỤC DỮ LIỆU
-- =============================================

-- Tạo backup plan (script mẫu)
/*
-- Full Backup
BACKUP DATABASE QuanLyNhanSu
TO DISK = 'D:\Backup\QuanLyNhanSu_Full.bak'
WITH FORMAT, NAME = 'Full Backup of QuanLyNhanSu';

-- Differential Backup
BACKUP DATABASE QuanLyNhanSu
TO DISK = 'D:\Backup\QuanLyNhanSu_Diff.bak'
WITH DIFFERENTIAL, NAME = 'Differential Backup of QuanLyNhanSu';

-- Transaction Log Backup
BACKUP LOG QuanLyNhanSu
TO DISK = 'D:\Backup\QuanLyNhanSu_Log.trn'
WITH NAME = 'Transaction Log Backup of QuanLyNhanSu';
*/

-- =============================================
-- KẾT THÚC CÀI ĐẶT VẬT LÝ
-- =============================================

PRINT '==============================================';
PRINT 'Hoàn thành cài đặt vật lý cơ sở dữ liệu';
PRINT 'Hệ thống Quản lý Nhân viên Phân tán';
PRINT '==============================================';
GO
