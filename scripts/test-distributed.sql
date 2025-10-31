-- ============================================================================
-- TEST DISTRIBUTED DATABASE
-- ============================================================================
USE QuanLyNhanSu;
GO

PRINT '========================================';
PRINT 'TEST 1: Local Query';
PRINT '========================================';
SELECT COUNT(*) AS TotalEmployees FROM NhanVien;
GO

PRINT '========================================';
PRINT 'TEST 2: Distributed Query via Linked Server';
PRINT '========================================';
SELECT 
    'HANOI' AS Site, 
    COUNT(*) AS Total
FROM QuanLyNhanSu.dbo.NhanVien

UNION ALL

SELECT 
    'DANANG' AS Site, 
    COUNT(*) AS Total
FROM SITE_DANANG.QuanLyNhanSu.dbo.NhanVien

UNION ALL

SELECT 
    'SAIGON' AS Site, 
    COUNT(*) AS Total
FROM SITE_SAIGON.QuanLyNhanSu.dbo.NhanVien;
GO

PRINT '========================================';
PRINT 'TEST 3: Query Remote Data';
PRINT '========================================';
SELECT TOP 5 * FROM SITE_DANANG.QuanLyNhanSu.dbo.ChiNhanh;
SELECT TOP 5 * FROM SITE_SAIGON.QuanLyNhanSu.dbo.PhongBan;
GO

PRINT 'All tests completed successfully!';
GO
