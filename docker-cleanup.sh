#!/bin/bash
# ============================================================================
# DOCKER CLEANUP SCRIPT
# ============================================================================
# Mục đích: Xóa toàn bộ containers, volumes, networks
# Tác giả: Nhóm 5 - CSDLPT - PTIT
# ============================================================================

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
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

print_header "DOCKER CLEANUP"

# Ask for confirmation
echo -e "${YELLOW}WARNING: This will delete:${NC}"
echo "  - All SQL Server containers (SITE_HANOI, SITE_DANANG, SITE_SAIGON)"
echo "  - All database data"
echo "  - All volumes and networks"
echo ""
read -p "Are you sure? (yes/no): " CONFIRM

if [ "$CONFIRM" != "yes" ]; then
    echo "Cleanup cancelled."
    exit 0
fi

echo ""
print_header "STOPPING CONTAINERS"

if [ -f "docker-compose.yml" ]; then
    docker-compose down
    print_success "Containers stopped"
else
    print_warning "docker-compose.yml not found, skipping..."
fi

echo ""
print_header "REMOVING VOLUMES"

for VOLUME in btl-csdlpt-ptit_hanoi-data btl-csdlpt-ptit_danang-data btl-csdlpt-ptit_saigon-data; do
    if docker volume inspect $VOLUME &> /dev/null; then
        docker volume rm $VOLUME
        print_success "Removed volume: $VOLUME"
    fi
done

echo ""
print_header "REMOVING NETWORKS"

if docker network inspect btl-csdlpt-ptit_sql_network &> /dev/null; then
    docker network rm btl-csdlpt-ptit_sql_network
    print_success "Removed network: btl-csdlpt-ptit_sql_network"
fi

echo ""
print_header "CLEANUP COMPLETED"
print_success "All resources have been cleaned up! ✨"
echo ""
echo "To setup again, run: ./docker-setup.sh"
