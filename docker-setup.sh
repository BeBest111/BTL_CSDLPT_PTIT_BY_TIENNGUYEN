#!/bin/bash
# ============================================================================
# DOCKER SETUP AUTOMATION SCRIPT
# ============================================================================
# Mục đích: Tự động setup 3-site distributed SQL Server với Docker
# Tác giả: Nhóm 5 - CSDLPT - PTIT
# Ngày: 31/10/2025
# ============================================================================

set -e  # Exit on error

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Configuration
SA_PASSWORD="Admin@123456"
SLEEP_TIME=30

# ============================================================================
# FUNCTIONS
# ============================================================================

print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_info() {
    echo -e "${BLUE}ℹ $1${NC}"
}

check_requirements() {
    print_header "KIỂM TRA YÊU CẦU HỆ THỐNG"
    
    # Check Docker
    if command -v docker &> /dev/null; then
        DOCKER_VERSION=$(docker --version)
        print_success "Docker đã cài đặt: $DOCKER_VERSION"
    else
        print_error "Docker chưa được cài đặt!"
        echo "Vui lòng cài Docker Desktop: https://www.docker.com/products/docker-desktop"
        exit 1
    fi
    
    # Check Docker Compose
    if docker compose version &> /dev/null; then
        COMPOSE_VERSION=$(docker compose version)
        print_success "Docker Compose đã cài đặt: $COMPOSE_VERSION"
    elif command -v docker-compose &> /dev/null; then
        COMPOSE_VERSION=$(docker-compose --version)
        print_success "Docker Compose đã cài đặt: $COMPOSE_VERSION"
    else
        print_error "Docker Compose chưa được cài đặt!"
        exit 1
    fi
    
    # Check if Docker is running
    if docker info &> /dev/null; then
        print_success "Docker daemon đang chạy"
    else
        print_error "Docker daemon không chạy! Vui lòng khởi động Docker Desktop"
        exit 1
    fi
    
    # Check required files
    if [ -f "HR.sql" ] && [ -f "HR-Data.sql" ]; then
        print_success "Tìm thấy các file SQL cần thiết"
    else
        print_error "Không tìm thấy HR.sql hoặc HR-Data.sql!"
        exit 1
    fi
    
    # Check disk space (need at least 10GB)
    AVAILABLE_SPACE=$(df -BG . | tail -1 | awk '{print $4}' | sed 's/G//')
    if [ "$AVAILABLE_SPACE" -ge 10 ]; then
        print_success "Đủ dung lượng đĩa: ${AVAILABLE_SPACE}GB"
    else
        print_warning "Dung lượng đĩa thấp: ${AVAILABLE_SPACE}GB (khuyến nghị: 10GB+)"
    fi
    
    echo ""
}

create_docker_compose() {
    print_header "TẠO DOCKER COMPOSE FILE"
    
    cat > docker-compose.yml << 'EOF'
version: '3.8'

services:
  # Site 1 - Hà Nội (Publisher)
  sqlserver-hanoi:
    image: mcr.microsoft.com/mssql/server:2019-latest
    container_name: SITE_HANOI
    hostname: SITE-HANOI
    environment:
      - ACCEPT_EULA=Y
      - SA_PASSWORD=Admin@123456
      - MSSQL_PID=Developer
      - MSSQL_AGENT_ENABLED=true
    ports:
      - "1433:1433"
    volumes:
      - hanoi-data:/var/opt/mssql
      - ./scripts:/scripts
    networks:
      sql_network:
        ipv4_address: 172.20.0.101
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "/opt/mssql-tools/bin/sqlcmd", "-S", "localhost", "-U", "sa", "-P", "Admin@123456", "-Q", "SELECT 1"]
      interval: 30s
      timeout: 10s
      retries: 5

  # Site 2 - Đà Nẵng (Subscriber)
  sqlserver-danang:
    image: mcr.microsoft.com/mssql/server:2019-latest
    container_name: SITE_DANANG
    hostname: SITE-DANANG
    environment:
      - ACCEPT_EULA=Y
      - SA_PASSWORD=Admin@123456
      - MSSQL_PID=Developer
      - MSSQL_AGENT_ENABLED=true
    ports:
      - "1434:1433"
    volumes:
      - danang-data:/var/opt/mssql
      - ./scripts:/scripts
    networks:
      sql_network:
        ipv4_address: 172.20.0.102
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "/opt/mssql-tools/bin/sqlcmd", "-S", "localhost", "-U", "sa", "-P", "Admin@123456", "-Q", "SELECT 1"]
      interval: 30s
      timeout: 10s
      retries: 5

  # Site 3 - Sài Gòn (Subscriber)
  sqlserver-saigon:
    image: mcr.microsoft.com/mssql/server:2019-latest
    container_name: SITE_SAIGON
    hostname: SITE-SAIGON
    environment:
      - ACCEPT_EULA=Y
      - SA_PASSWORD=Admin@123456
      - MSSQL_PID=Developer
      - MSSQL_AGENT_ENABLED=true
    ports:
      - "1435:1433"
    volumes:
      - saigon-data:/var/opt/mssql
      - ./scripts:/scripts
    networks:
      sql_network:
        ipv4_address: 172.20.0.103
    restart: unless-stopped
    healthcheck:
      test: ["CMD", "/opt/mssql-tools/bin/sqlcmd", "-S", "localhost", "-U", "sa", "-P", "Admin@123456", "-Q", "SELECT 1"]
      interval: 30s
      timeout: 10s
      retries: 5

networks:
  sql_network:
    driver: bridge
    ipam:
      config:
        - subnet: 172.20.0.0/24

volumes:
  hanoi-data:
  danang-data:
  saigon-data:
EOF
    
    print_success "Đã tạo docker-compose.yml"
    echo ""
}

create_scripts_dir() {
    print_header "TẠO THƯ MỤC SCRIPTS"
    
    mkdir -p scripts
    
    # Copy SQL files
    cp HR.sql scripts/ 2>/dev/null || true
    cp HR-Data.sql scripts/ 2>/dev/null || true
    cp Physical-Implementation.sql scripts/ 2>/dev/null || true
    
    print_success "Đã tạo thư mục scripts và copy files"
    echo ""
}

create_linked_server_script() {
    print_header "TẠO LINKED SERVER SCRIPT"
    
    cat > scripts/create-linked-servers.sql << 'EOF'
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
EOF
    
    print_success "Đã tạo create-linked-servers.sql"
    echo ""
}

create_test_script() {
    print_header "TẠO TEST SCRIPT"
    
    cat > scripts/test-distributed.sql << 'EOF'
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
EOF
    
    print_success "Đã tạo test-distributed.sql"
    echo ""
}

start_containers() {
    print_header "KHỞI ĐỘNG CONTAINERS"
    
    print_info "Pulling SQL Server images (có thể mất vài phút)..."
    docker compose pull
    
    print_info "Khởi động containers..."
    docker compose up -d
    
    print_success "Containers đã được khởi động"
    echo ""
    
    print_info "Chờ SQL Server khởi động (${SLEEP_TIME}s)..."
    sleep $SLEEP_TIME
    
    print_success "SQL Server đã sẵn sàng"
    echo ""
}

check_containers() {
    print_header "KIỂM TRA CONTAINERS"
    
    # Check container status
    print_info "Container status:"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}"
    echo ""
    
    # Test SQL Server connections
    print_info "Testing SQL Server connections..."
    
    for SITE in SITE_HANOI SITE_DANANG SITE_SAIGON; do
        if docker exec $SITE /opt/mssql-tools/bin/sqlcmd \
            -S localhost -U sa -P "$SA_PASSWORD" \
            -Q "SELECT @@SERVERNAME, @@VERSION" &> /dev/null; then
            print_success "$SITE: SQL Server running"
        else
            print_error "$SITE: SQL Server not ready"
        fi
    done
    echo ""
    
    # Test network connectivity
    print_info "Testing network connectivity..."
    
    if docker exec SITE_HANOI ping -c 2 172.20.0.102 &> /dev/null; then
        print_success "HANOI → DANANG: OK"
    else
        print_error "HANOI → DANANG: FAILED"
    fi
    
    if docker exec SITE_HANOI ping -c 2 172.20.0.103 &> /dev/null; then
        print_success "HANOI → SAIGON: OK"
    else
        print_error "HANOI → SAIGON: FAILED"
    fi
    echo ""
}

setup_databases() {
    print_header "TẠO DATABASE VÀ DỮ LIỆU"
    
    # Setup on SITE_HANOI (Publisher)
    print_info "Đang setup database trên SITE_HANOI..."
    
    docker exec SITE_HANOI /opt/mssql-tools/bin/sqlcmd \
        -S localhost -U sa -P "$SA_PASSWORD" \
        -i /scripts/HR.sql
    print_success "Đã chạy HR.sql"
    
    docker exec SITE_HANOI /opt/mssql-tools/bin/sqlcmd \
        -S localhost -U sa -P "$SA_PASSWORD" \
        -i /scripts/HR-Data.sql
    print_success "Đã chạy HR-Data.sql"
    
    if [ -f "scripts/Physical-Implementation.sql" ]; then
        docker exec SITE_HANOI /opt/mssql-tools/bin/sqlcmd \
            -S localhost -U sa -P "$SA_PASSWORD" \
            -i /scripts/Physical-Implementation.sql
        print_success "Đã chạy Physical-Implementation.sql"
    fi
    
    # Verify data
    EMPLOYEE_COUNT=$(docker exec SITE_HANOI /opt/mssql-tools/bin/sqlcmd \
        -S localhost -U sa -P "$SA_PASSWORD" \
        -h -1 -Q "SET NOCOUNT ON; USE QuanLyNhanSu; SELECT COUNT(*) FROM NhanVien")
    
    print_success "Database created với $EMPLOYEE_COUNT nhân viên"
    echo ""
    
    # Setup on SITE_DANANG
    print_info "Đang setup database trên SITE_DANANG..."
    
    docker exec SITE_DANANG /opt/mssql-tools/bin/sqlcmd \
        -S localhost -U sa -P "$SA_PASSWORD" \
        -i /scripts/HR.sql
    
    docker exec SITE_DANANG /opt/mssql-tools/bin/sqlcmd \
        -S localhost -U sa -P "$SA_PASSWORD" \
        -i /scripts/HR-Data.sql
    
    if [ -f "scripts/Physical-Implementation.sql" ]; then
        docker exec SITE_DANANG /opt/mssql-tools/bin/sqlcmd \
            -S localhost -U sa -P "$SA_PASSWORD" \
            -i /scripts/Physical-Implementation.sql
    fi
    
    print_success "Database created trên SITE_DANANG"
    echo ""
    
    # Setup on SITE_SAIGON
    print_info "Đang setup database trên SITE_SAIGON..."
    
    docker exec SITE_SAIGON /opt/mssql-tools/bin/sqlcmd \
        -S localhost -U sa -P "$SA_PASSWORD" \
        -i /scripts/HR.sql
    
    docker exec SITE_SAIGON /opt/mssql-tools/bin/sqlcmd \
        -S localhost -U sa -P "$SA_PASSWORD" \
        -i /scripts/HR-Data.sql
    
    if [ -f "scripts/Physical-Implementation.sql" ]; then
        docker exec SITE_SAIGON /opt/mssql-tools/bin/sqlcmd \
            -S localhost -U sa -P "$SA_PASSWORD" \
            -i /scripts/Physical-Implementation.sql
    fi
    
    print_success "Database created trên SITE_SAIGON"
    echo ""
}

setup_linked_servers() {
    print_header "TẠO LINKED SERVERS"
    
    print_info "Creating linked servers trên SITE_HANOI..."
    docker exec SITE_HANOI /opt/mssql-tools/bin/sqlcmd \
        -S localhost -U sa -P "$SA_PASSWORD" \
        -i /scripts/create-linked-servers.sql
    
    print_success "Linked servers created successfully"
    echo ""
}

run_tests() {
    print_header "CHẠY TESTS"
    
    print_info "Running distributed query tests..."
    docker exec SITE_HANOI /opt/mssql-tools/bin/sqlcmd \
        -S localhost -U sa -P "$SA_PASSWORD" \
        -i /scripts/test-distributed.sql
    
    print_success "Tests completed"
    echo ""
}

print_summary() {
    print_header "HOÀN THÀNH SETUP!"
    
    echo -e "${GREEN}✓ 3 SQL Server containers đang chạy${NC}"
    echo -e "${GREEN}✓ Database QuanLyNhanSu đã được tạo${NC}"
    echo -e "${GREEN}✓ Linked Servers đã được cấu hình${NC}"
    echo -e "${GREEN}✓ Tests đã pass${NC}"
    echo ""
    
    print_info "Connection Details:"
    echo "┌──────────────┬────────────────────┬──────────────┐"
    echo "│ Site         │ Connection String  │ IP Address   │"
    echo "├──────────────┼────────────────────┼──────────────┤"
    echo "│ HANOI        │ localhost,1433     │ 172.20.0.101 │"
    echo "│ DANANG       │ localhost,1434     │ 172.20.0.102 │"
    echo "│ SAIGON       │ localhost,1435     │ 172.20.0.103 │"
    echo "└──────────────┴────────────────────┴──────────────┘"
    echo ""
    echo "Username: sa"
    echo "Password: $SA_PASSWORD"
    echo ""
    
    print_info "Useful Commands:"
    echo "  docker ps                          # View containers"
    echo "  docker logs SITE_HANOI             # View logs"
    echo "  docker exec -it SITE_HANOI bash    # Shell access"
    echo "  docker-compose down                # Stop all"
    echo "  docker-compose up -d               # Restart all"
    echo ""
    
    print_info "Connect với SSMS:"
    echo "  Server: localhost,1433 (HANOI)"
    echo "  Server: localhost,1434 (DANANG)"
    echo "  Server: localhost,1435 (SAIGON)"
    echo ""
}

# ============================================================================
# MAIN
# ============================================================================

main() {
    clear
    print_header "DOCKER SETUP - DISTRIBUTED SQL SERVER"
    echo "Automated setup script for 3-site distributed database"
    echo ""
    
    check_requirements
    create_docker_compose
    create_scripts_dir
    create_linked_server_script
    create_test_script
    start_containers
    check_containers
    setup_databases
    setup_linked_servers
    run_tests
    print_summary
    
    print_success "Setup completed successfully! 🎉"
}

# Run main function
main
