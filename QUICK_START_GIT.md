# 🚀 Koha Quick Start - Git Deployment

## ⚡ 5-Minute Setup Guide

This guide will get your Koha library system running in minutes using Git deployment (no Docker complexity!).

## 📋 What You Need

- ✅ **Web hosting** with PHP 8.0+ and MySQL
- ✅ **SSH access** to your server
- ✅ **Domain name** (optional for local testing)

## 🎯 Quick Setup Steps

### Step 1: Server Preparation (2 minutes)

```bash
# Connect to your server
ssh user@your-server.com

# Update and install requirements
sudo apt update && sudo apt upgrade -y
sudo apt install -y apache2 mysql-server php php-mysql php-gd php-mbstring php-xml php-curl git curl wget
```

### Step 2: Database Setup (1 minute)

```bash
# Create database and user
sudo mysql -e "CREATE DATABASE koha CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
sudo mysql -e "CREATE USER 'kohauser'@'localhost' IDENTIFIED BY 'your_password';"
sudo mysql -e "GRANT ALL PRIVILEGES ON koha.* TO 'kohauser'@'localhost';"
sudo mysql -e "FLUSH PRIVILEGES;"
```

### Step 3: Deploy Koha (2 minutes)

```bash
# Clone your repository
cd /var/www/html
sudo git clone https://github.com/emanbukh/e-library-IUC-2025.git koha
sudo chown -R www-data:www-data koha

# Run installation script
cd koha
chmod +x deployment/koha-install.sh
./deployment/koha-install.sh
```

### Step 4: Web Configuration (1 minute)

```bash
# Copy Apache configuration
sudo cp deployment/config/apache.conf /etc/apache2/sites-available/koha.conf

# Edit domain name in config
sudo nano /etc/apache2/sites-available/koha.conf
# Change "yourdomain.com" to your actual domain

# Enable site
sudo a2ensite koha.conf
sudo a2enmod rewrite
sudo systemctl reload apache2
```

## 🌐 Access Your Koha

After setup, access your Koha at:

- **OPAC (Public):** `http://yourdomain.com/koha/opac`
- **Staff Interface:** `http://yourdomain.com/koha/intranet`
- **Installer:** `http://yourdomain.com/koha/installer`

## 🔧 Complete Installation

1. **Run the web installer:**

   - Go to: `http://yourdomain.com/koha/installer`
   - Follow the installation wizard
   - Use database credentials from Step 2

2. **Create admin account:**
   - Username: `admin`
   - Password: `your_secure_password`

## 📊 Management Commands

```bash
# Check status
sudo systemctl status apache2
sudo systemctl status mysql

# Backup
cd /var/www/html/koha
./deployment/scripts/backup.sh

# Update
cd /var/www/html/koha
./deployment/scripts/update.sh

# View logs
sudo tail -f /var/log/apache2/koha_error.log
```

## 🔒 Security Setup (Optional)

```bash
# Install SSL certificate
sudo apt install certbot python3-certbot-apache
sudo certbot --apache -d yourdomain.com

# Configure firewall
sudo ufw allow 22/tcp
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw enable
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

## 📞 Need Help?

- **Documentation:** Check `GIT_DEPLOYMENT.md` for detailed instructions
- **Backup:** Your data is automatically backed up in `/var/backups/koha`
- **Logs:** Check `/var/log/apache2/koha_error.log` for errors

---

**🎉 That's it! Your Koha library system is ready to use!**

**Total Setup Time:** ~5 minutes  
**Complexity:** ⭐ (Very Easy)  
**Docker Required:** ❌ No
