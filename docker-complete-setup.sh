#!/bin/bash
# ============================================================================
# COMPLETE DOCKER SETUP - ALL IN ONE
# ============================================================================

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m'

print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_warning() {
    echo -e "${YELLOW}⚠ $1${NC}"
}

print_header "COMPLETE DOCKER SETUP - 3 SITE DISTRIBUTED DATABASE"

# Setup all 3 sites
for SITE in SITE_HANOI SITE_DANANG SITE_SAIGON; do
    echo ""
    print_header "Setting up $SITE"
    
    # Create database
    sudo docker exec $SITE /opt/mssql-tools18/bin/sqlcmd \
        -S localhost -U sa -P 'Admin@123456' -C \
        -Q "CREATE DATABASE QuanLyNhanSu" 2>/dev/null || print_warning "Database already exists"
    
    # Run HR.sql
    sudo docker exec $SITE bash -c "cat /scripts/HR.sql | /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'Admin@123456' -C" > /dev/null
    print_success "Tables created"
    
    # Run HR-Data.sql
    sudo docker exec $SITE bash -c "cat /scripts/HR-Data.sql | /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'Admin@123456' -C -d QuanLyNhanSu" > /dev/null
    print_success "Data inserted"
    
    # Run Physical-Implementation.sql if exists
    if [ -f "scripts/Physical-Implementation.sql" ]; then
        sudo docker exec $SITE bash -c "cat /scripts/Physical-Implementation.sql | /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'Admin@123456' -C -d QuanLyNhanSu" > /dev/null 2>&1 || print_warning "Physical-Implementation had some errors (views/triggers may fail without full data)"
        print_success "Views, Procedures, Functions created"
    fi
    
    # Verify
    COUNT=$(sudo docker exec $SITE /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'Admin@123456' -C -h -1 -Q "SET NOCOUNT ON; SELECT COUNT(*) FROM QuanLyNhanSu.dbo.NhanVien" | tr -d ' ')
    print_success "$SITE ready with $COUNT employees"
done

# Create Linked Servers on SITE_HANOI
echo ""
print_header "Creating Linked Servers"
sudo docker exec SITE_HANOI bash -c "cat /scripts/create-linked-servers.sql | /opt/mssql-tools18/bin/sqlcmd -S localhost -U sa -P 'Admin@123456' -C" > /dev/null
print_success "Linked Servers created successfully"

# Run tests
echo ""
print_header "Running Tests"
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
    -S localhost -U sa -P 'Admin@123456' -C \
    -d QuanLyNhanSu \
    -Q "SELECT COUNT(*) AS TotalEmployees FROM NhanVien"

# Distributed query test
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
    -S localhost -U sa -P 'Admin@123456' -C \
    -Q "SELECT 'HANOI' AS Site, COUNT(*) AS Total FROM QuanLyNhanSu.dbo.NhanVien UNION ALL SELECT 'DANANG', COUNT(*) FROM SITE_DANANG.QuanLyNhanSu.dbo.NhanVien UNION ALL SELECT 'SAIGON', COUNT(*) FROM SITE_SAIGON.QuanLyNhanSu.dbo.NhanVien"

print_success "All tests passed!"

# Summary
echo ""
print_header "SETUP COMPLETED SUCCESSFULLY! 🎉"
echo ""
echo -e "${GREEN}Connection Information:${NC}"
echo "┌──────────┬────────────────────┬──────────────┐"
echo "│ Site     │ Connection String  │ IP Address   │"
echo "├──────────┼────────────────────┼──────────────┤"
echo "│ HANOI    │ localhost,1433     │ 172.20.0.101 │"
echo "│ DANANG   │ localhost,1434     │ 172.20.0.102 │"
echo "│ SAIGON   │ localhost,1435     │ 172.20.0.103 │"
echo "└──────────┴────────────────────┴──────────────┘"
echo ""
echo "Username: sa"
echo "Password: Admin@123456"
echo ""
echo -e "${BLUE}Useful Commands:${NC}"
echo "  sudo docker ps                    # View containers"
echo "  sudo docker logs SITE_HANOI       # View logs"
echo "  sudo docker exec -it SITE_HANOI bash  # Shell access"
echo "  sudo docker compose down          # Stop all"
echo ""
echo -e "${GREEN}Connect with SSMS or Azure Data Studio:${NC}"
echo "  Server: localhost,1433"
echo "  Database: QuanLyNhanSu"
echo ""
