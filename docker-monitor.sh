#!/bin/bash
# ============================================================================
# DOCKER MONITORING SCRIPT
# ============================================================================
# Mục đích: Monitor containers và SQL Server status
# Tác giả: Nhóm 5 - CSDLPT - PTIT
# ============================================================================

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

SA_PASSWORD="Admin@123456"

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

print_error() {
    echo -e "${RED}✗ $1${NC}"
}

clear

while true; do
    clear
    print_header "DOCKER MONITORING - SQL SERVER CLUSTER"
    echo "Press Ctrl+C to exit"
    echo ""
    
    # Container Status
    print_header "CONTAINER STATUS"
    docker ps --format "table {{.Names}}\t{{.Status}}\t{{.Ports}}" --filter "name=SITE_"
    echo ""
    
    # Resource Usage
    print_header "RESOURCE USAGE"
    docker stats --no-stream --format "table {{.Container}}\t{{.CPUPerc}}\t{{.MemUsage}}\t{{.NetIO}}" \
        SITE_HANOI SITE_DANANG SITE_SAIGON 2>/dev/null || echo "Containers not running"
    echo ""
    
    # SQL Server Status
    print_header "SQL SERVER STATUS"
    
    for SITE in SITE_HANOI SITE_DANANG SITE_SAIGON; do
        if docker exec $SITE /opt/mssql-tools/bin/sqlcmd \
            -S localhost -U sa -P "$SA_PASSWORD" \
            -Q "SELECT @@SERVERNAME AS Server, DB_NAME() AS CurrentDB" -h -1 &> /dev/null; then
            
            # Get employee count
            COUNT=$(docker exec $SITE /opt/mssql-tools/bin/sqlcmd \
                -S localhost -U sa -P "$SA_PASSWORD" \
                -h -1 -Q "SET NOCOUNT ON; USE QuanLyNhanSu; SELECT COUNT(*) FROM NhanVien" 2>/dev/null | tr -d ' ')
            
            print_success "$SITE: Running | Employees: $COUNT"
        else
            print_error "$SITE: Not responding"
        fi
    done
    echo ""
    
    # Network Connectivity
    print_header "NETWORK CONNECTIVITY"
    
    if docker exec SITE_HANOI ping -c 1 -W 1 172.20.0.102 &> /dev/null; then
        print_success "HANOI → DANANG: OK"
    else
        print_error "HANOI → DANANG: FAILED"
    fi
    
    if docker exec SITE_HANOI ping -c 1 -W 1 172.20.0.103 &> /dev/null; then
        print_success "HANOI → SAIGON: OK"
    else
        print_error "HANOI → SAIGON: FAILED"
    fi
    echo ""
    
    # Linked Server Status
    print_header "LINKED SERVER STATUS"
    
    LINKED_SERVERS=$(docker exec SITE_HANOI /opt/mssql-tools/bin/sqlcmd \
        -S localhost -U sa -P "$SA_PASSWORD" \
        -h -1 -Q "SET NOCOUNT ON; SELECT COUNT(*) FROM sys.servers WHERE server_id > 0" 2>/dev/null | tr -d ' ')
    
    if [ "$LINKED_SERVERS" -ge 2 ]; then
        print_success "Linked Servers: $LINKED_SERVERS configured"
    else
        print_warning "Linked Servers: $LINKED_SERVERS configured (expected: 2+)"
    fi
    echo ""
    
    # Last updated
    echo "Last updated: $(date '+%Y-%m-%d %H:%M:%S')"
    echo "Refreshing in 5 seconds..."
    
    sleep 5
done
