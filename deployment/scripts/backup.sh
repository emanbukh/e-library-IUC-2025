#!/bin/bash

# Koha Backup Script
# This script creates backups of Koha database and files

set -e

# Configuration
BACKUP_DIR="/var/backups/koha"
DATE=$(date +%Y%m%d_%H%M%S)
RETENTION_DAYS=7

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}📦 Starting Koha backup...${NC}"

# Create backup directory
sudo mkdir -p $BACKUP_DIR

# Get database credentials from Koha config
if [ -f "/opt/koha/etc/koha-conf.xml" ]; then
    DB_NAME=$(grep -oP '<dbname>\K[^<]+' /opt/koha/etc/koha-conf.xml)
    DB_USER=$(grep -oP '<user>\K[^<]+' /opt/koha/etc/koha-conf.xml)
    DB_PASS=$(grep -oP '<pass>\K[^<]+' /opt/koha/etc/koha-conf.xml)
else
    echo -e "${YELLOW}⚠️  Koha config not found, using defaults${NC}"
    DB_NAME="koha"
    DB_USER="kohauser"
    DB_PASS="koha_password"
fi

# Backup database
echo -e "${YELLOW}🗄️  Backing up database...${NC}"
mysqldump -u $DB_USER -p$DB_PASS $DB_NAME > $BACKUP_DIR/koha_db_$DATE.sql
gzip $BACKUP_DIR/koha_db_$DATE.sql

# Backup Koha files
echo -e "${YELLOW}📁 Backing up Koha files...${NC}"
sudo tar -czf $BACKUP_DIR/koha_files_$DATE.tar.gz /opt/koha

# Backup web configuration
echo -e "${YELLOW}🌐 Backing up web configuration...${NC}"
sudo tar -czf $BACKUP_DIR/web_config_$DATE.tar.gz /var/www/html/koha /etc/apache2/sites-available/koha.conf

# Create backup info file
cat > $BACKUP_DIR/backup_info_$DATE.txt <<EOF
Koha Backup Information
=======================

Backup Date: $(date)
Backup Time: $DATE

Files Created:
- Database: koha_db_$DATE.sql.gz
- Koha Files: koha_files_$DATE.tar.gz
- Web Config: web_config_$DATE.tar.gz

Database Information:
- Database: $DB_NAME
- User: $DB_USER

Backup Location: $BACKUP_DIR
Total Size: $(du -sh $BACKUP_DIR/*$DATE* | awk '{sum+=$1} END {print sum}')

Restore Instructions:
1. Extract files: tar -xzf koha_files_$DATE.tar.gz
2. Restore database: gunzip -c koha_db_$DATE.sql.gz | mysql -u $DB_USER -p $DB_NAME
3. Restore web config: tar -xzf web_config_$DATE.tar.gz
EOF

# Clean old backups
echo -e "${YELLOW}🧹 Cleaning old backups...${NC}"
find $BACKUP_DIR -name "*.sql.gz" -mtime +$RETENTION_DAYS -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +$RETENTION_DAYS -delete
find $BACKUP_DIR -name "backup_info_*.txt" -mtime +$RETENTION_DAYS -delete

# Show backup summary
echo -e "${GREEN}✅ Backup completed successfully!${NC}"
echo -e "${GREEN}📊 Backup Summary:${NC}"
echo "  - Database: $BACKUP_DIR/koha_db_$DATE.sql.gz"
echo "  - Files: $BACKUP_DIR/koha_files_$DATE.tar.gz"
echo "  - Config: $BACKUP_DIR/web_config_$DATE.tar.gz"
echo "  - Info: $BACKUP_DIR/backup_info_$DATE.txt"
echo "  - Total Size: $(du -sh $BACKUP_DIR/*$DATE* | awk '{sum+=$1} END {print sum}')"
echo "  - Retention: $RETENTION_DAYS days" 