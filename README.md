# 📚 Koha Library Management System - Git Deployment

A complete setup for Koha library management system using **Git-based deployment** (simple and reliable).

## 🚀 Why Git Deployment?

- ✅ **Simple** - No Docker complexity
- ✅ **Fast** - Direct file deployment
- ✅ **Reliable** - Works with any web hosting
- ✅ **Easy to manage** - Standard web server setup
- ✅ **No platform issues** - Works on any OS

## 📋 Quick Start

### 1. Clone Repository

```bash
git clone https://github.com/emanbukh/e-library-IUC-2025.git
cd e-library-IUC-2025
```

### 2. Follow Quick Start Guide

See [`QUICK_START_GIT.md`](QUICK_START_GIT.md) for 5-minute setup instructions.

### 3. Detailed Documentation

See [`GIT_DEPLOYMENT.md`](GIT_DEPLOYMENT.md) for complete deployment guide.

## 🏗️ Repository Structure

```
e-library-IUC-2025/
├── README.md                 # This file
├── QUICK_START_GIT.md        # 5-minute setup guide
├── GIT_DEPLOYMENT.md         # Complete deployment guide
└── deployment/
    ├── koha-install.sh       # Installation script
    ├── config/
    │   └── apache.conf       # Apache configuration
    └── scripts/
        ├── backup.sh         # Backup script
        └── update.sh         # Update script
```

## 🌐 Access Your Koha

After deployment:

- **OPAC (Public):** `http://yourdomain.com/koha/opac`
- **Staff Interface:** `http://yourdomain.com/koha/intranet`
- **Admin Login:** Use credentials created during installation

## 📊 Management

```bash
# Backup
./deployment/scripts/backup.sh

# Update
./deployment/scripts/update.sh

# Check status
sudo systemctl status apache2 mysql
```

## 🔧 Requirements

- **Web Server:** Apache/Nginx with PHP 8.0+
- **Database:** MySQL/MariaDB
- **OS:** Ubuntu/Debian (recommended)
- **Access:** SSH to server

## 🚀 Deployment Options

### Local Development

- **MAMP/XAMPP** - Easy local setup
- **Built-in PHP server** - Quick testing
- **Docker (optional)** - For development only

### Production Server

- **Shared hosting** - Standard web hosting
- **VPS/Dedicated** - Full control
- **Cloud platforms** - AWS, DigitalOcean, etc.

## 📞 Support

- **Documentation:** Check `GIT_DEPLOYMENT.md`
- **Quick Start:** Check `QUICK_START_GIT.md`
- **Koha Community:** https://koha-community.org/

---

**🎉 Simple, reliable, and Docker-free Koha deployment!**

**Last Updated:** June 2025  
**Version:** 3.0 (Git-based deployment only)
