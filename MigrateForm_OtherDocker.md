# Guide to Reuse Docker Database with DDEV (No Export/Import Required)

## Overview

This guide covers methods to migrate services and configurations from Docker containers to DDEV:

### Database Migration (3 methods)
1. **Use External Volume** - Map an existing volume from another Docker container
2. **Copy Volume Data** - Copy data from an old volume to a new volume
3. **Use Volume from Running Container** - Share volume between containers

### Other Services Migration
4. **Application Files** - Copy codebase/application files
5. **PHP Configuration** - Migrate PHP config files (php.ini, php-fpm)
6. **Nginx Configuration** - Migrate Nginx config files
7. **Redis Volume** - Migrate Redis data
8. **Elasticsearch/OpenSearch Volume** - Migrate search index data
9. **Environment Variables** - Migrate environment configuration
10. **Complete Migration** - Full migration example

**Important Note:** PHP and Nginx services are provided by DDEV - you don't need to migrate the services themselves, only their configuration files and application code.

## Method 1: Use External Volume (Recommended)

### Step 1: Find Existing Database Volume

```bash
# List all volumes
docker volume ls

# Find database volume from another Docker container
docker volume ls | grep -E "(mariadb|mysql|db)"

# View detailed volume information
docker volume inspect <volume-name>
```

Example volumes you might have:
- `magento_dbdata`
- `gsp_dbdata`
- `ee246_dbdata`
- `magento-db-big`
- Or long volume ID (hash)

### Step 2: Create Docker Compose Override File

Create file `.ddev/docker-compose.db-override.yaml`:

```yaml
services:
  db:
    volumes:
      - <old-volume-name>:/var/lib/mysql
volumes:
  <old-volume-name>:
    external: true
```

**Specific example:**

```yaml
services:
  db:
    volumes:
      - magento_dbdata:/var/lib/mysql
volumes:
  magento_dbdata:
    external: true
```

### Step 3: Restart DDEV

```bash
# Stop current DDEV
ddev stop

# Start again with new configuration
ddev start
```

### Step 4: Verify Database

```bash
# Test database connection
ddev mysql

# Or view list of databases
ddev mysql -e "SHOW DATABASES;"
```

## Method 2: Copy Data from Old Volume to New Volume

If you want to create a new volume for DDEV but keep data from the old volume:

### Step 1: Create New Volume for DDEV

```bash
# DDEV will automatically create volume on start, or create manually:
docker volume create ddev-<project-name>-mariadb
```

### Step 2: Copy Data from Old Volume

```bash
# Create temporary container to copy data
docker run --rm \
  -v <old-volume-name>:/source:ro \
  -v ddev-<project-name>-mariadb:/dest \
  alpine sh -c "cp -a /source/. /dest/"

# Example:
docker run --rm \
  -v magento_dbdata:/source:ro \
  -v ddev-ee248-mariadb:/dest \
  alpine sh -c "cp -a /source/. /dest/"
```

### Step 3: Start DDEV

```bash
ddev start
```

## Method 3: Use Volume from Running Container

If another Docker container is running and you want to share the volume:

### Step 1: Find Volume Being Used

```bash
# View running containers
docker ps

# View volume information of container
docker inspect <container-id> | grep -A 10 Mounts
```

### Step 2: Create Override File

Create `.ddev/docker-compose.db-override.yaml` with corresponding volume name:

```yaml
services:
  db:
    volumes:
      - <volume-name-from-other-container>:/var/lib/mysql
volumes:
  <volume-name-from-other-container>:
    external: true
```

### Step 3: Ensure Old Container is Stopped

```bash
# Stop old container to avoid conflicts
docker stop <container-id>
docker rm <container-id>
```

### Step 4: Start DDEV

```bash
ddev start
```

## Important Notes

### 1. Check Database Version

Ensure database version is compatible:

```yaml
# In .ddev/config.yaml
database:
  type: mariadb
  version: "10.6"  # Must match version of old volume
```

### 2. Backup Before Changes

```bash
# Backup old volume before making changes
docker run --rm \
  -v <old-volume-name>:/data:ro \
  -v $(pwd):/backup \
  alpine tar czf /backup/db-backup-$(date +%Y%m%d).tar.gz -C /data .
```

### 3. Permissions

Ensure correct permissions:

```bash
# Fix permissions if needed
ddev exec chown -R mysql:mysql /var/lib/mysql
```

### 4. Database Credentials

DDEV uses default credentials:
- Host: `db`
- Database: `db`
- User: `db`
- Password: `db`

If the old database has different credentials, you can:
- Create new user in database
- Or re-import with new credentials

## Troubleshooting

### Error: Volume does not exist

```bash
# Check if volume exists
docker volume inspect <volume-name>

# If it doesn't exist, find the correct volume
docker volume ls
```

### Error: Permission denied

```bash
# Fix permissions in container
ddev exec chown -R mysql:mysql /var/lib/mysql
ddev exec chmod -R 755 /var/lib/mysql
```

### Error: Database version mismatch

```yaml
# Fix version in config.yaml to match
database:
  type: mariadb
  version: "10.6"  # Or appropriate version
```

### Error: Container won't start

```bash
# View logs to debug
ddev logs -s db

# Or view docker logs
docker logs ddev-<project-name>-db
```

## Practical Examples

### Example 1: Migrate from docker-magento to DDEV

```bash
# 1. Find docker-magento volume
docker volume ls | grep magento

# 2. Create override file
cat > .ddev/docker-compose.db-override.yaml << EOF
services:
  db:
    volumes:
      - magento_dbdata:/var/lib/mysql
volumes:
  magento_dbdata:
    external: true
EOF

# 3. Stop docker-magento
docker-compose -f docker-compose.yml down

# 4. Start DDEV
ddev start
```

### Example 2: Share database between 2 DDEV projects

```bash
# 1. Create shared volume
docker volume create shared-mariadb

# 2. In project 1, create override
cat > .ddev/docker-compose.db-override.yaml << EOF
services:
  db:
    volumes:
      - shared-mariadb:/var/lib/mysql
volumes:
  shared-mariadb:
    external: true
EOF

# 3. Copy from project 1 to project 2
cp .ddev/docker-compose.db-override.yaml /path/to/project2/.ddev/

# 4. Start both projects (not simultaneously)
```

---

## Migrating Other Services and Configuration

While PHP and Nginx services are provided by DDEV (no need to migrate the services themselves), you can migrate their configurations, application files, and volumes from other services.

### Important Note

**PHP and Nginx services don't need migration** - DDEV already provides them. You only need to:
- Copy application files/codebase
- Migrate configuration files (if customized)
- Migrate volumes from other services (Redis, Elasticsearch, etc.)

---

## Method 4: Migrate Application Files (Codebase)

### Step 1: Copy Application Files

Copy your application files from the old Docker container to your DDEV project:

```bash
# Copy files from running container
docker cp <container-id>:/path/to/app /path/to/ddev-project/

# Or if container is stopped, mount volume temporarily
docker run --rm \
  -v <old-volume-name>:/source:ro \
  -v $(pwd):/dest \
  alpine sh -c "cp -a /source/. /dest/"
```

### Step 2: Verify File Structure

```bash
# Check file structure matches your project type
ls -la

# For Magento 2, ensure pub/ directory exists
ls -la pub/
```

---

## Method 5: Migrate PHP Configuration

### Step 1: Extract PHP Configuration from Old Container

```bash
# Copy php.ini from old container
docker cp <container-id>:/usr/local/etc/php/php.ini ./php.ini.backup

# Copy PHP-FPM pool configuration
docker cp <container-id>:/usr/local/etc/php-fpm.d/www.conf ./www.conf.backup
```

### Step 2: Create Custom PHP Dockerfile

Create `.ddev/web-build/Dockerfile.php-custom`:

```dockerfile
# Copy custom php.ini
COPY php.ini /usr/local/etc/php/php.ini

# Or modify specific PHP settings
RUN echo "memory_limit = 512M" >> /usr/local/etc/php/conf.d/custom.ini && \
    echo "upload_max_filesize = 64M" >> /usr/local/etc/php/conf.d/custom.ini && \
    echo "post_max_size = 64M" >> /usr/local/etc/php/conf.d/custom.ini

# Copy custom PHP-FPM pool configuration
COPY www.conf /usr/local/etc/php-fpm.d/www.conf
```

### Step 3: Place Configuration Files

Place your custom configuration files in `.ddev/web-build/`:
- `php.ini` (or `php-custom.ini`)
- `www.conf` (PHP-FPM pool config)

### Step 4: Rebuild and Restart

```bash
ddev restart
```

---

## Method 6: Migrate Nginx Configuration

### Step 1: Extract Nginx Configuration from Old Container

```bash
# Copy nginx configuration from old container
docker cp <container-id>:/etc/nginx/nginx.conf ./nginx.conf.backup
docker cp <container-id>:/etc/nginx/sites-available/default ./nginx-site.conf.backup
```

### Step 2: Use DDEV's Nginx Configuration System

DDEV supports custom Nginx configurations. For Magento 2, you can use:

**Option A: Full Nginx Configuration (Magento 2)**

DDEV already provides `.ddev/nginx_full/nginx-site.conf` for Magento 2. If you need to customize:

```bash
# Copy your custom nginx config
cp nginx-site.conf.backup .ddev/nginx_full/nginx-site.conf

# Or edit the existing one
nano .ddev/nginx_full/nginx-site.conf
```

**Option B: Add Custom Snippets**

Create `.ddev/nginx/nginx.conf` (or `.ddev/nginx/nginx-site.conf`):

```nginx
# Custom location blocks
location /custom {
    try_files $uri $uri/ /index.php?$query_string;
}

# Custom PHP handling
location ~ \.php$ {
    fastcgi_read_timeout 600s;
    fastcgi_connect_timeout 600s;
}
```

### Step 3: Restart DDEV

```bash
ddev restart
```

**Note:** DDEV will automatically merge your custom Nginx configuration with the default configuration.

---

## Method 7: Migrate Redis Volume

### Step 1: Find Redis Volume

```bash
# List Redis volumes
docker volume ls | grep redis

# View volume details
docker volume inspect <redis-volume-name>
```

### Step 2: Create Redis Override File

Create `.ddev/docker-compose.redis-override.yaml`:

```yaml
services:
  redis:
    volumes:
      - <old-redis-volume>:/data
volumes:
  <old-redis-volume>:
    external: true
```

**Example:**

```yaml
services:
  redis:
    volumes:
      - magento_redis:/data
volumes:
  magento_redis:
    external: true
```

### Step 3: Restart DDEV

```bash
ddev restart
```

---

## Method 8: Migrate Elasticsearch/OpenSearch Volume

### Step 1: Find Elasticsearch/OpenSearch Volume

```bash
# List Elasticsearch volumes
docker volume ls | grep -E "(elasticsearch|opensearch)"

# View volume details
docker volume inspect <opensearch-volume-name>
```

### Step 2: Create OpenSearch Override File

Create `.ddev/docker-compose.opensearch-override.yaml`:

```yaml
services:
  opensearch:
    volumes:
      - <old-opensearch-volume>:/usr/share/opensearch/data
volumes:
  <old-opensearch-volume>:
    external: true
```

**Example:**

```yaml
services:
  opensearch:
    volumes:
      - magento_elasticsearch:/usr/share/opensearch/data
volumes:
  magento_elasticsearch:
    external: true
```

### Step 3: Restart DDEV

```bash
ddev restart
```

---

## Method 9: Migrate Environment Variables

### Step 1: Extract Environment Variables from Old Container

```bash
# View environment variables from old container
docker inspect <container-id> | grep -A 50 Env

# Or if using docker-compose
docker-compose config | grep -A 20 environment
```

### Step 2: Add to DDEV Configuration

Add environment variables to `.ddev/config.yaml`:

```yaml
web_environment:
  - MAGENTO_ENCRYPTION_KEY=<your-key>
  - APP_ENV=production
  - CUSTOM_VAR=value
```

Or create `.ddev/docker-compose.env-override.yaml`:

```yaml
services:
  web:
    environment:
      - MAGENTO_ENCRYPTION_KEY=<your-key>
      - APP_ENV=production
```

### Step 3: Restart DDEV

```bash
ddev restart
```

---

## Method 10: Complete Migration Example (All Services)

Complete migration from docker-magento to DDEV:

```bash
# 1. Stop old docker-magento
docker-compose -f docker-compose.yml down

# 2. Find all volumes
docker volume ls | grep magento

# 3. Create database override
cat > .ddev/docker-compose.db-override.yaml << EOF
services:
  db:
    volumes:
      - magento_dbdata:/var/lib/mysql
volumes:
  magento_dbdata:
    external: true
EOF

# 4. Create Redis override (if needed)
cat > .ddev/docker-compose.redis-override.yaml << EOF
services:
  redis:
    volumes:
      - magento_redis:/data
volumes:
  magento_redis:
    external: true
EOF

# 5. Create OpenSearch override (if needed)
cat > .ddev/docker-compose.opensearch-override.yaml << EOF
services:
  opensearch:
    volumes:
      - magento_elasticsearch:/usr/share/opensearch/data
volumes:
  magento_elasticsearch:
    external: true
EOF

# 6. Copy application files (if not already in project)
# (Application files should already be in your project directory)

# 7. Copy custom PHP config (if any)
# cp php.ini .ddev/web-build/php.ini
# (Then create Dockerfile.php-custom)

# 8. Copy custom Nginx config (if any)
# cp nginx-site.conf .ddev/nginx_full/nginx-site.conf

# 9. Start DDEV
ddev start

# 10. Verify services
ddev describe
```

---

## Summary: What Can and Cannot Be Migrated

### ✅ Can Be Migrated (Volumes)
- **Database** (MariaDB/MySQL) - ✅ Full migration possible
- **Redis** - ✅ Full migration possible
- **Elasticsearch/OpenSearch** - ✅ Full migration possible
- **RabbitMQ** - ✅ Full migration possible (if added to DDEV)
- **Application files** - ✅ Copy files directly

### ⚠️ Partial Migration (Configuration)
- **PHP configuration** - ✅ Migrate config files (php.ini, php-fpm)
- **Nginx configuration** - ✅ Migrate config files (nginx.conf, site configs)
- **Environment variables** - ✅ Add to config.yaml or docker-compose override

### ❌ Not Needed (Services)
- **PHP service** - ❌ DDEV provides it (just migrate config)
- **Nginx service** - ❌ DDEV provides it (just migrate config)
- **Web server** - ❌ DDEV manages it automatically

---

## Conclusion

With the methods above, you can:
- ✅ Reuse database from another Docker container
- ✅ Migrate Redis, Elasticsearch, and other service volumes
- ✅ Migrate PHP and Nginx configuration files
- ✅ Copy application files/codebase
- ✅ Migrate environment variables
- ✅ No need to export/import database
- ✅ Preserve data and database structure
- ✅ Share database/services between multiple projects

**Note:** Always backup before changing volumes or configurations to avoid data loss!
