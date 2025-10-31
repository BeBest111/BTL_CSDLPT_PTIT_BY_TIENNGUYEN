-- ============================================================================
-- CREATE LINKED SERVERS
-- ============================================================================
USE master;
GO

-- Drop existing linked servers if any
IF EXISTS (SELECT * FROM sys.servers WHERE name = 'SITE_DANANG')
    EXEC sp_dropserver 'SITE_DANANG', 'droplogins';
    
IF EXISTS (SELECT * FROM sys.servers WHERE name = 'SITE_SAIGON')
    EXEC sp_dropserver 'SITE_SAIGON', 'droplogins';
GO

-- Create linked server to SITE_DANANG
EXEC sp_addlinkedserver 
    @server = 'SITE_DANANG',
    @srvproduct = '',
    @provider = 'SQLNCLI',
    @datasrc = '172.20.0.102';

EXEC sp_addlinkedsrvlogin 
    @rmtsrvname = 'SITE_DANANG',
    @useself = 'FALSE',
    @rmtuser = 'sa',
    @rmtpassword = 'Admin@123456';
    
EXEC sp_serveroption 'SITE_DANANG', 'rpc out', 'true';
EXEC sp_serveroption 'SITE_DANANG', 'data access', 'true';
GO

-- Create linked server to SITE_SAIGON
EXEC sp_addlinkedserver 
    @server = 'SITE_SAIGON',
    @srvproduct = '',
    @provider = 'SQLNCLI',
    @datasrc = '172.20.0.103';

EXEC sp_addlinkedsrvlogin 
    @rmtsrvname = 'SITE_SAIGON',
    @useself = 'FALSE',
    @rmtuser = 'sa',
    @rmtpassword = 'Admin@123456';
    
EXEC sp_serveroption 'SITE_SAIGON', 'rpc out', 'true';
EXEC sp_serveroption 'SITE_SAIGON', 'data access', 'true';
GO

-- Test connections
PRINT 'Testing connection to SITE_DANANG...';
SELECT @@SERVERNAME AS LocalServer, 'Connected to SITE_DANANG' AS Status;
EXEC ('SELECT @@SERVERNAME') AT SITE_DANANG;

PRINT 'Testing connection to SITE_SAIGON...';
SELECT @@SERVERNAME AS LocalServer, 'Connected to SITE_SAIGON' AS Status;
EXEC ('SELECT @@SERVERNAME') AT SITE_SAIGON;

PRINT 'Linked servers created successfully!';
GO
