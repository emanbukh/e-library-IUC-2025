# Koha Quick Start Guide

## 🚀 Quick Setup

1. **Clone and setup:**

   ```bash
   cd /Users/emanbukhori/2025
   git clone https://gitlab.com/koha-community/koha-testing-docker.git koha_IUC
   cd koha_IUC
   ./setup.sh
   ```

2. **Access Koha:**
   - Staff Interface: [http://localhost:8081](http://localhost:8081)
   - OPAC: [http://localhost:8080](http://localhost:8080)
   - Login: `koha` / `koha`

## 📋 Essential Commands

```bash
# Start services
./koha-testing-docker/bin/ktd up -d

# Stop services
./koha-testing-docker/bin/ktd down

# View logs
./koha-testing-docker/bin/ktd --logs

# Access Koha shell
./koha-testing-docker/bin/ktd --shell

# Access database
./koha-testing-docker/bin/ktd --dbshell
```

## 🔧 Services

- **Koha ILS** - Library management system
- **MariaDB** - Database (port 3306)
- **Elasticsearch** - Search engine (port 9200)
- **Memcached** - Caching
- **RabbitMQ** - Message queuing

## 📚 Documentation

- Full documentation: [README.md](README.md)
- Koha Community: https://koha-community.org/
- Wiki: https://wiki.koha-community.org/

---

**Status:** ✅ Ready to use  
**Last Updated:** June 2025
