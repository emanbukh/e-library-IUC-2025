# Koha Git-Based Deployment Guide

## 🚀 Simple Git Deployment (No Docker)

This guide shows how to deploy Koha using Git and standard web hosting, without Docker complexity.

## 📋 Prerequisites

- **GitHub repository** (you already have: https://github.com/emanbukh/e-library-IUC-2025.git)
- **Web hosting** with PHP 8.0+ and MySQL/MariaDB
- **SSH access** to your hosting server
- **Domain name** configured

## 🔧 Step 1: Prepare Your Repository

### 1.1 Create Deployment Branch

```bash
# Create a deployment branch
git checkout -b deployment

# Add deployment files
git add .
git commit -m "Add deployment configuration"
git push origin deployment
```

### 1.2 Repository Structure

Your repository should have:

```
e-library-IUC-2025/
├── README.md
├── DEPLOYMENT.md
├── GIT_DEPLOYMENT.md
├── setup.sh
├── QUICK_START.md
└── deployment/
    ├── koha-install.sh
    ├── config/
    │   ├── apache.conf
    │   └── nginx.conf
    └── scripts/
        ├── backup.sh
        └── update.sh
```

## 🌐 Step 2: Server Setup

### 2.1 Connect to Your Server

```bash
ssh user@your-server.com
```

### 2.2 Install Requirements

```bash
# Update system
sudo apt update && sudo apt upgrade -y

# Install required packages
sudo apt install -y apache2 mysql-server php php-mysql php-gd php-mbstring php-xml php-curl git curl wget

# Install Composer
curl -sS https://getcomposer.org/installer | php
sudo mv composer.phar /usr/local/bin/composer
```

### 2.3 Configure MySQL

```bash
# Secure MySQL installation
sudo mysql_secure_installation

# Create database and user
sudo mysql -u root -p
```

```sql
CREATE DATABASE koha CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'kohauser'@'localhost' IDENTIFIED BY 'your_secure_password';
GRANT ALL PRIVILEGES ON koha.* TO 'kohauser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

## 📥 Step 3: Deploy Koha

### 3.1 Clone Repository

```bash
# Navigate to web directory
cd /var/www/html

# Clone your repository
sudo git clone https://github.com/emanbukh/e-library-IUC-2025.git koha
sudo chown -R www-data:www-data koha
```

### 3.2 Install Koha

```bash
# Navigate to Koha directory
cd koha

# Download Koha
wget https://download.koha-community.org/koha-latest.tar.gz
tar -xzf koha-latest.tar.gz
sudo mv koha-* /opt/koha

# Set permissions
sudo chown -R www-data:www-data /opt/koha
```

### 3.3 Configure Apache

```bash
# Create Apache configuration
sudo nano /etc/apache2/sites-available/koha.conf
```

Add this configuration:

```apache
<VirtualHost *:80>
    ServerName yourdomain.com
    ServerAlias www.yourdomain.com

    DocumentRoot /var/www/html/koha/opac

    # OPAC
    <Directory /var/www/html/koha/opac>
        AllowOverride All
        Require all granted
    </Directory>

    # Staff Interface
    Alias /intranet /var/www/html/koha/intranet
    <Directory /var/www/html/koha/intranet>
        AllowOverride All
        Require all granted
    </Directory>

    ErrorLog ${APACHE_LOG_DIR}/koha_error.log
    CustomLog ${APACHE_LOG_DIR}/koha_access.log combined
</VirtualHost>
```

### 3.4 Enable Site

```bash
# Enable the site
sudo a2ensite koha.conf
sudo a2enmod rewrite
sudo systemctl reload apache2
```

## 🔧 Step 4: Koha Configuration

### 4.1 Run Koha Installer

1. **Access the web installer:**

   - Go to: `http://yourdomain.com/installer`
   - Follow the installation wizard

2. **Database configuration:**

   - Host: `localhost`
   - Database: `koha`
   - User: `kohauser`
   - Password: `your_secure_password`

3. **Create admin account:**
   - Username: `admin`
   - Password: `your_secure_admin_password`

### 4.2 Configure Elasticsearch (Optional)

```bash
# Install Elasticsearch
wget -qO - https://artifacts.elastic.co/GPG-KEY-elasticsearch | sudo apt-key add -
echo "deb https://artifacts.elastic.co/packages/7.x/apt stable main" | sudo tee /etc/apt/sources.list.d/elastic-7.x.list
sudo apt update
sudo apt install elasticsearch

# Start Elasticsearch
sudo systemctl start elasticsearch
sudo systemctl enable elasticsearch
```

## 🔒 Step 5: Security Configuration

### 5.1 SSL Certificate

```bash
# Install Certbot
sudo apt install certbot python3-certbot-apache

# Get SSL certificate
sudo certbot --apache -d yourdomain.com -d www.yourdomain.com
```

### 5.2 Firewall Configuration

```bash
# Configure UFW
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable
```

## 📊 Step 6: Maintenance Scripts

### 6.1 Backup Script

Create `/var/www/html/koha/scripts/backup.sh`:

```bash
#!/bin/bash
# Backup Koha database and files

DATE=$(date +%Y%m%d_%H%M%S)
BACKUP_DIR="/var/backups/koha"

# Create backup directory
mkdir -p $BACKUP_DIR

# Backup database
mysqldump -u kohauser -p koha > $BACKUP_DIR/koha_db_$DATE.sql

# Backup Koha files
tar -czf $BACKUP_DIR/koha_files_$DATE.tar.gz /opt/koha

# Keep only last 7 days of backups
find $BACKUP_DIR -name "*.sql" -mtime +7 -delete
find $BACKUP_DIR -name "*.tar.gz" -mtime +7 -delete

echo "Backup completed: $DATE"
```

### 6.2 Update Script

Create `/var/www/html/koha/scripts/update.sh`:

```bash
#!/bin/bash
# Update Koha to latest version

cd /var/www/html/koha

# Backup before update
./scripts/backup.sh

# Download latest Koha
wget https://download.koha-community.org/koha-latest.tar.gz
tar -xzf koha-latest.tar.gz

# Update files
sudo cp -r koha-*/* /opt/koha/
sudo chown -R www-data:www-data /opt/koha

# Run database updates
cd /opt/koha
sudo -u www-data perl installer/data/mysql/updatedatabase.pl

echo "Koha updated successfully"
```

## 🔄 Step 7: Automated Deployment

### 7.1 GitHub Actions (Optional)

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Server

on:
  push:
    branches: [deployment]

jobs:
  deploy:
    runs-on: ubuntu-latest
    steps:
      - name: Deploy to server
        uses: appleboy/ssh-action@v0.1.5
        with:
          host: ${{ secrets.HOST }}
          username: ${{ secrets.USERNAME }}
          key: ${{ secrets.KEY }}
          script: |
            cd /var/www/html/koha
            git pull origin deployment
            ./scripts/update.sh
```

## 🌐 Step 8: Access Your Koha

After deployment:

- **OPAC (Public):** `https://yourdomain.com`
- **Staff Interface:** `https://yourdomain.com/intranet`
- **Admin Login:** Use the credentials you created during installation

## 📋 Management Commands

```bash
# Check Koha status
sudo systemctl status apache2
sudo systemctl status mysql

# View logs
sudo tail -f /var/log/apache2/koha_error.log

# Backup
cd /var/www/html/koha
./scripts/backup.sh

# Update
cd /var/www/html/koha
./scripts/update.sh
```

## 🚨 Troubleshooting

### Common Issues

1. **Permission Errors**

   ```bash
   sudo chown -R www-data:www-data /opt/koha
   sudo chmod -R 755 /opt/koha
   ```

2. **Database Connection**

   ```bash
   sudo mysql -u kohauser -p koha
   ```

3. **Apache Errors**
   ```bash
   sudo apache2ctl configtest
   sudo systemctl restart apache2
   ```

## 📞 Support

- **Koha Community:** https://koha-community.org/
- **Documentation:** https://wiki.koha-community.org/
- **Installation Guide:** https://wiki.koha-community.org/wiki/Koha_on_ubuntu_-_packages

---

**This Git-based approach is much simpler than Docker and works with any standard web hosting!** 🎉

**Last Updated:** June 2025  
**Version:** 1.0
