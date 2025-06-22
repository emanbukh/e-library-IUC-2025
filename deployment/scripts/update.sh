#!/bin/bash

# Koha Update Script
# This script updates Koha to the latest version

set -e

# Configuration
KOHA_VERSION="23.11.00"
BACKUP_DIR="/var/backups/koha"
KOHA_DIR="/opt/koha"
WEB_DIR="/var/www/html/koha"

# Colors
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m'

echo -e "${GREEN}🔄 Starting Koha update...${NC}"

# Check if running as root
if [[ $EUID -eq 0 ]]; then
   echo -e "${RED}❌ This script should not be run as root${NC}"
   exit 1
fi

# Create backup before update
echo -e "${YELLOW}📦 Creating backup before update...${NC}"
./deployment/scripts/backup.sh

# Download latest Koha
echo -e "${YELLOW}📥 Downloading Koha $KOHA_VERSION...${NC}"
cd /tmp
wget "https://download.koha-community.org/koha-$KOHA_VERSION.tar.gz"
tar -xzf "koha-$KOHA_VERSION.tar.gz"

# Stop web server temporarily
echo -e "${YELLOW}⏸️  Stopping web server...${NC}"
sudo systemctl stop apache2

# Backup current Koha files
echo -e "${YELLOW}📁 Backing up current Koha files...${NC}"
sudo cp -r $KOHA_DIR $KOHA_DIR.backup.$(date +%Y%m%d_%H%M%S)

# Update Koha files
echo -e "${YELLOW}📁 Updating Koha files...${NC}"
sudo cp -r koha-$KOHA_VERSION/* $KOHA_DIR/
sudo chown -R www-data:www-data $KOHA_DIR
sudo chmod -R 755 $KOHA_DIR

# Update database schema
echo -e "${YELLOW}🗄️  Updating database schema...${NC}"
cd $KOHA_DIR
sudo -u www-data perl installer/data/mysql/updatedatabase.pl

# Restart web server
echo -e "${YELLOW}▶️  Starting web server...${NC}"
sudo systemctl start apache2

# Clean up
echo -e "${YELLOW}🧹 Cleaning up temporary files...${NC}"
rm -rf /tmp/koha-$KOHA_VERSION*
rm -f /tmp/koha-$KOHA_VERSION.tar.gz

# Create update log
cat > $WEB_DIR/UPDATE_LOG.txt <<EOF
Koha Update Log
===============

Update Date: $(date)
Previous Version: (check backup)
New Version: $KOHA_VERSION

Files Updated:
- Koha core files: $KOHA_DIR
- Database schema: Updated
- Web configuration: Preserved

Backup Location: $BACKUP_DIR

If issues occur, restore from backup:
1. Stop Apache: sudo systemctl stop apache2
2. Restore files: sudo cp -r $KOHA_DIR.backup.* $KOHA_DIR
3. Start Apache: sudo systemctl start apache2
EOF

echo -e "${GREEN}✅ Koha updated successfully!${NC}"
echo -e "${GREEN}🌐 Access your updated Koha at: http://localhost/koha/opac${NC}"
echo -e "${GREEN}📋 Update log saved to: $WEB_DIR/UPDATE_LOG.txt${NC}"
echo -e "${YELLOW}⚠️  Please test all functionality after update!${NC}" 