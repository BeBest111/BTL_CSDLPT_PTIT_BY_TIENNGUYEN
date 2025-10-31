#!/bin/bash
# ============================================================================
# DOCKER BACKUP SCRIPT
# ============================================================================
# Mục đích: Backup toàn bộ databases từ 3 sites
# Tác giả: Nhóm 5 - CSDLPT - PTIT
# ============================================================================

set -e

# Colors
GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

SA_PASSWORD="Admin@123456"
BACKUP_DIR="./backups"
TIMESTAMP=$(date +%Y%m%d_%H%M%S)

print_header() {
    echo -e "${BLUE}========================================${NC}"
    echo -e "${BLUE}$1${NC}"
    echo -e "${BLUE}========================================${NC}"
}

print_success() {
    echo -e "${GREEN}✓ $1${NC}"
}

print_header "DOCKER BACKUP - SQL SERVER DATABASES"

# Create backup directory
mkdir -p $BACKUP_DIR
print_success "Created backup directory: $BACKUP_DIR"

# Backup SITE_HANOI
echo ""
echo "Backing up SITE_HANOI..."
docker exec SITE_HANOI /opt/mssql-tools/bin/sqlcmd \
    -S localhost -U sa -P "$SA_PASSWORD" \
    -Q "BACKUP DATABASE QuanLyNhanSu TO DISK='/var/opt/mssql/backup/QuanLyNhanSu_${TIMESTAMP}.bak' WITH FORMAT, COMPRESSION, STATS=10"

docker cp SITE_HANOI:/var/opt/mssql/backup/QuanLyNhanSu_${TIMESTAMP}.bak \
    ${BACKUP_DIR}/HANOI_${TIMESTAMP}.bak

print_success "SITE_HANOI backup completed"

# Backup SITE_DANANG
echo ""
echo "Backing up SITE_DANANG..."
docker exec SITE_DANANG /opt/mssql-tools/bin/sqlcmd \
    -S localhost -U sa -P "$SA_PASSWORD" \
    -Q "BACKUP DATABASE QuanLyNhanSu TO DISK='/var/opt/mssql/backup/QuanLyNhanSu_${TIMESTAMP}.bak' WITH FORMAT, COMPRESSION, STATS=10"

docker cp SITE_DANANG:/var/opt/mssql/backup/QuanLyNhanSu_${TIMESTAMP}.bak \
    ${BACKUP_DIR}/DANANG_${TIMESTAMP}.bak

print_success "SITE_DANANG backup completed"

# Backup SITE_SAIGON
echo ""
echo "Backing up SITE_SAIGON..."
docker exec SITE_SAIGON /opt/mssql-tools/bin/sqlcmd \
    -S localhost -U sa -P "$SA_PASSWORD" \
    -Q "BACKUP DATABASE QuanLyNhanSu TO DISK='/var/opt/mssql/backup/QuanLyNhanSu_${TIMESTAMP}.bak' WITH FORMAT, COMPRESSION, STATS=10"

docker cp SITE_SAIGON:/var/opt/mssql/backup/QuanLyNhanSu_${TIMESTAMP}.bak \
    ${BACKUP_DIR}/SAIGON_${TIMESTAMP}.bak

print_success "SITE_SAIGON backup completed"

# Summary
echo ""
print_header "BACKUP COMPLETED"
echo "Backup files saved to: $BACKUP_DIR"
ls -lh ${BACKUP_DIR}/*_${TIMESTAMP}.bak
echo ""
print_success "All backups completed successfully! 💾"
