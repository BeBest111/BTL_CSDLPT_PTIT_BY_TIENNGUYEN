#!/bin/bash
# Quick Docker Setup - Fixed for mssql-tools18

set -e

GREEN='\033[0;32m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}========================================${NC}"
echo -e "${BLUE}SETUP DATABASE - 3 SITES${NC}"
echo -e "${BLUE}========================================${NC}"

# Setup SITE_HANOI
echo -e "${BLUE}Setting up SITE_HANOI...${NC}"
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
    -S localhost -U sa -P 'Admin@123456' -C \
    -i /scripts/HR.sql

sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
    -S localhost -U sa -P 'Admin@123456' -C \
    -i /scripts/HR-Data.sql

if [ -f "scripts/Physical-Implementation.sql" ]; then
    sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
        -S localhost -U sa -P 'Admin@123456' -C \
        -i /scripts/Physical-Implementation.sql
fi

echo -e "${GREEN}✓ SITE_HANOI ready${NC}"

# Setup SITE_DANANG
echo -e "${BLUE}Setting up SITE_DANANG...${NC}"
sudo docker exec SITE_DANANG /opt/mssql-tools18/bin/sqlcmd \
    -S localhost -U sa -P 'Admin@123456' -C \
    -i /scripts/HR.sql

sudo docker exec SITE_DANANG /opt/mssql-tools18/bin/sqlcmd \
    -S localhost -U sa -P 'Admin@123456' -C \
    -i /scripts/HR-Data.sql

if [ -f "scripts/Physical-Implementation.sql" ]; then
    sudo docker exec SITE_DANANG /opt/mssql-tools18/bin/sqlcmd \
        -S localhost -U sa -P 'Admin@123456' -C \
        -i /scripts/Physical-Implementation.sql
fi

echo -e "${GREEN}✓ SITE_DANANG ready${NC}"

# Setup SITE_SAIGON
echo -e "${BLUE}Setting up SITE_SAIGON...${NC}"
sudo docker exec SITE_SAIGON /opt/mssql-tools18/bin/sqlcmd \
    -S localhost -U sa -P 'Admin@123456' -C \
    -i /scripts/HR.sql

sudo docker exec SITE_SAIGON /opt/mssql-tools18/bin/sqlcmd \
    -S localhost -U sa -P 'Admin@123456' -C \
    -i /scripts/HR-Data.sql

if [ -f "scripts/Physical-Implementation.sql" ]; then
    sudo docker exec SITE_SAIGON /opt/mssql-tools18/bin/sqlcmd \
        -S localhost -U sa -P 'Admin@123456' -C \
        -i /scripts/Physical-Implementation.sql
fi

echo -e "${GREEN}✓ SITE_SAIGON ready${NC}"

# Create Linked Servers
echo -e "${BLUE}Creating Linked Servers...${NC}"
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
    -S localhost -U sa -P 'Admin@123456' -C \
    -i /scripts/create-linked-servers.sql

echo -e "${GREEN}✓ Linked Servers created${NC}"

# Run Tests
echo -e "${BLUE}Running Tests...${NC}"
sudo docker exec SITE_HANOI /opt/mssql-tools18/bin/sqlcmd \
    -S localhost -U sa -P 'Admin@123456' -C \
    -i /scripts/test-distributed.sql

echo ""
echo -e "${GREEN}========================================${NC}"
echo -e "${GREEN}SETUP COMPLETED!${NC}"
echo -e "${GREEN}========================================${NC}"
echo ""
echo "Connection Info:"
echo "  HANOI:  localhost,1433"
echo "  DANANG: localhost,1434"
echo "  SAIGON: localhost,1435"
echo "  User: sa"
echo "  Pass: Admin@123456"
