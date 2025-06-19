# Koha Deployment Guide

## 🚀 GitHub + Plesk Deployment

This guide shows how to deploy your Koha Docker setup to production using GitHub and Plesk.

## 📋 Prerequisites

- **GitHub account** with repository
- **Plesk server** with Docker extension installed
- **Domain name** configured in Plesk
- **SSL certificate** (recommended)

## 🔧 Step 1: Prepare GitHub Repository

### 1.1 Create Repository Structure

```bash
koha_IUC/
├── docker-compose.production.yml
├── env.production.example
├── .gitignore
├── README.md
├── DEPLOYMENT.md
├── setup.sh
└── QUICK_START.md
```

### 1.2 Push to GitHub

```bash
# Initialize git repository
git init
git add .
git commit -m "Initial Koha Docker setup"

# Create GitHub repository and push
git remote add origin https://github.com/yourusername/koha-docker.git
git branch -M main
git push -u origin main
```

## 🌐 Step 2: Plesk Configuration

### 2.1 Install Docker Extension

1. **Login to Plesk**
2. **Go to Extensions** → **Docker**
3. **Install Docker extension** if not already installed

### 2.2 Create Domain

1. **Add Domain** in Plesk
2. **Configure DNS** to point to your server
3. **Enable SSL** (recommended)

### 2.3 Deploy with Docker

#### Option A: Direct Git Clone

```bash
# SSH to your server
ssh user@your-server.com

# Clone repository
git clone https://github.com/yourusername/koha-docker.git
cd koha-docker

# Configure environment
cp env.production.example .env.production
nano .env.production  # Edit with your values

# Start services
docker compose -f docker-compose.production.yml up -d
```

#### Option B: Plesk Docker Interface

1. **Go to Domains** → **Your Domain** → **Docker**
2. **Add Container** using `docker-compose.production.yml`
3. **Configure environment variables** in Plesk interface

## 🔒 Step 3: Security Configuration

### 3.1 Environment Variables

Update `.env.production` with secure values:

```bash
# Generate secure passwords
MYSQL_ROOT_PASSWORD=$(openssl rand -base64 32)
MYSQL_PASSWORD=$(openssl rand -base64 32)
KOHA_ADMINPASS=$(openssl rand -base64 32)
RABBITMQ_PASS=$(openssl rand -base64 32)
```

### 3.2 Firewall Configuration

```bash
# Allow only necessary ports
sudo ufw allow 80/tcp
sudo ufw allow 443/tcp
sudo ufw allow 22/tcp
sudo ufw enable
```

### 3.3 SSL Configuration

1. **Install Certbot** (Let's Encrypt)
2. **Generate SSL certificate**
3. **Configure reverse proxy** in Plesk

## 🌍 Step 4: Domain Configuration

### 4.1 Reverse Proxy Setup

Create Nginx configuration in Plesk:

```nginx
server {
    listen 80;
    server_name yourdomain.com www.yourdomain.com;
    return 301 https://$server_name$request_uri;
}

server {
    listen 443 ssl http2;
    server_name yourdomain.com www.yourdomain.com;

    ssl_certificate /path/to/your/certificate.crt;
    ssl_certificate_key /path/to/your/private.key;

    # OPAC
    location / {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }

    # Staff Interface
    location /intranet {
        proxy_pass http://localhost:8081;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}
```

## 📊 Step 5: Monitoring & Maintenance

### 5.1 Health Checks

```bash
# Check service status
docker compose -f docker-compose.production.yml ps

# View logs
docker compose -f docker-compose.production.yml logs -f

# Monitor resources
docker stats
```

### 5.2 Backup Strategy

```bash
# Database backup
docker exec koha-db-1 mysqldump -u root -p koha > backup_$(date +%Y%m%d).sql

# Volume backup
docker run --rm -v koha_mariadb_data:/data -v $(pwd):/backup alpine tar czf /backup/mariadb_$(date +%Y%m%d).tar.gz -C /data .
```

### 5.3 Update Process

```bash
# Pull latest changes
git pull origin main

# Update images
docker compose -f docker-compose.production.yml pull

# Restart services
docker compose -f docker-compose.production.yml up -d
```

## 🔄 Step 6: Automation (Optional)

### 6.1 GitHub Actions

Create `.github/workflows/deploy.yml`:

```yaml
name: Deploy to Production

on:
  push:
    branches: [main]

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
            cd /path/to/koha-docker
            git pull origin main
            docker compose -f docker-compose.production.yml pull
            docker compose -f docker-compose.production.yml up -d
```

## 🚨 Troubleshooting

### Common Issues

1. **Port Conflicts**

   ```bash
   # Check port usage
   netstat -tulpn | grep :8080
   ```

2. **Permission Issues**

   ```bash
   # Fix Docker permissions
   sudo chown -R $USER:$USER /var/lib/docker
   ```

3. **Memory Issues**
   ```bash
   # Increase swap space
   sudo fallocate -l 2G /swapfile
   sudo chmod 600 /swapfile
   sudo mkswap /swapfile
   sudo swapon /swapfile
   ```

## 📞 Support

- **Koha Community:** https://koha-community.org/
- **Plesk Documentation:** https://docs.plesk.com/
- **Docker Documentation:** https://docs.docker.com/

---

**Last Updated:** June 2025  
**Version:** 1.0
