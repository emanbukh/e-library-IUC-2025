# 🏠 Koha Local Development Setup

## 🚀 Quick Local Setup Guide

This guide will help you set up Koha locally for development and testing.

## 📋 Prerequisites

### Option 1: MAMP (Recommended for Mac)

- Download from: https://www.mamp.info/
- Includes Apache, MySQL, PHP
- Easy to install and configure

### Option 2: XAMPP (Cross-platform)

- Download from: https://www.apachefriends.org/
- Works on Windows, Mac, Linux
- Complete web server stack

### Option 3: Built-in PHP Server (Quick Testing)

- PHP 8.0+ installed
- MySQL/MariaDB installed
- For quick testing only

## 🎯 Step-by-Step Setup

### Step 1: Install Web Server Stack

#### MAMP (Mac)

```bash
# Download and install MAMP
# Start MAMP
# Set document root to your project folder
```

#### XAMPP (All Platforms)

```bash
# Download and install XAMPP
# Start Apache and MySQL services
# Set document root to your project folder
```

#### Built-in PHP Server

```bash
# Install PHP and MySQL
brew install php mysql  # Mac
sudo apt install php mysql-server  # Ubuntu
```

### Step 2: Clone Repository

```bash
# Navigate to your web server directory
cd /Applications/MAMP/htdocs  # MAMP
cd /opt/lampp/htdocs  # XAMPP
cd ~/Sites  # Built-in server

# Clone the repository
git clone https://github.com/emanbukh/e-library-IUC-2025.git koha
cd koha
```

### Step 3: Download Koha

```bash
# Download latest Koha
wget https://download.koha-community.org/koha-latest.tar.gz
tar -xzf koha-latest.tar.gz

# Move to web directory
sudo mv koha-* /opt/koha
sudo chown -R www-data:www-data /opt/koha
```

### Step 4: Setup Database

```bash
# Access MySQL
mysql -u root -p

# Create database and user
CREATE DATABASE koha CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
CREATE USER 'kohauser'@'localhost' IDENTIFIED BY 'koha_password';
GRANT ALL PRIVILEGES ON koha.* TO 'kohauser'@'localhost';
FLUSH PRIVILEGES;
EXIT;
```

### Step 5: Configure Web Server

#### Apache Configuration

Create `/etc/apache2/sites-available/koha.conf`:

```apache
<VirtualHost *:80>
    ServerName localhost
    DocumentRoot /opt/koha/opac

    # OPAC
    <Directory /opt/koha/opac>
        AllowOverride All
        Require all granted
    </Directory>

    # Staff Interface
    Alias /intranet /opt/koha/intranet
    <Directory /opt/koha/intranet>
        AllowOverride All
        Require all granted
    </Directory>

    # Installer
    Alias /installer /opt/koha/installer
    <Directory /opt/koha/installer>
        AllowOverride All
        Require all granted
    </Directory>
</VirtualHost>
```

### Step 6: Run Koha Installer

1. **Access installer:** http://localhost/installer
2. **Follow setup wizard:**
   - Database: `localhost`
   - Database name: `koha`
   - Username: `kohauser`
   - Password: `koha_password`
3. **Create admin account:**
   - Username: `admin`
   - Password: `your_secure_password`

## 🌐 Access Your Local Koha

- **OPAC:** http://localhost/opac
- **Staff Interface:** http://localhost/intranet
- **Admin Login:** Use credentials from Step 6

## 🔧 Development Tools

### Backup Script

```bash
# Run backup
./deployment/scripts/backup.sh
```

### Update Script

```bash
# Update Koha
./deployment/scripts/update.sh
```

### Database Management

```bash
# Access database
mysql -u kohauser -p koha

# Backup database
mysqldump -u kohauser -p koha > backup.sql

# Restore database
mysql -u kohauser -p koha < backup.sql
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
   # Check MySQL status
   sudo systemctl status mysql

   # Restart MySQL
   sudo systemctl restart mysql
   ```

3. **Apache Errors**

   ```bash
   # Check Apache config
   sudo apache2ctl configtest

   # Restart Apache
   sudo systemctl restart apache2
   ```

4. **Port Conflicts**

   ```bash
   # Check what's using port 80
   lsof -i :80

   # Change port in Apache config if needed
   ```

## 📊 Local Development Workflow

1. **Start services:**

   ```bash
   # MAMP/XAMPP: Start from GUI
   # Built-in: php -S localhost:8000
   ```

2. **Make changes:**

   - Edit files in `/opt/koha`
   - Test in browser
   - Use browser dev tools

3. **Backup regularly:**

   ```bash
   ./deployment/scripts/backup.sh
   ```

4. **Update when needed:**
   ```bash
   ./deployment/scripts/update.sh
   ```

## 🔒 Security Notes

- **Local only:** This setup is for development only
- **Strong passwords:** Use secure passwords for admin account
- **Regular backups:** Backup your development data
- **Version control:** Use Git for code changes

## 📞 Need Help?

- **Documentation:** Check `GIT_DEPLOYMENT.md`
- **Server Setup:** Check `QUICK_START_GIT.md`
- **Koha Community:** https://koha-community.org/

---

**🎉 Your local Koha development environment is ready!**

**Total Setup Time:** ~15 minutes  
**Complexity:** ⭐⭐ (Easy)  
**Docker Required:** ❌ No
