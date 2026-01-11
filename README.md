# Magento 2 DDEV Setup

[English](README.md) | [Tiếng Việt](README.vi.md)

DDEV configuration template for Magento 2 with PHP 8.3, MariaDB 10.6, Redis, OpenSearch, and RabbitMQ.

## Prerequisites & Installation

### Requirements
- Docker Desktop or Docker Engine + Docker Compose
- DDEV: `curl -fsSL https://ddev.com/install.sh | bash`
- Verify: `ddev version`

### What is DDEV?
DDEV is an open-source tool that creates isolated Docker-based development environments. Key features:
- Multi-project support (run multiple projects simultaneously)
- Cross-platform (Linux, macOS, Windows)
- Pre-configured for Magento, Drupal, WordPress, Laravel, etc.
- Consistent environment across team members

## Quick Start

1. **Configure your project**:
   ```bash
   cd /path/to/your/magento/project
   ddev config --project-type=magento2 --docroot=pub
   ```

2. **Start the project**:
   ```bash
   ddev start
   ```

3. **Access**: `https://{project-name}.ddev.site`

## Access Services

### Check Running Projects

**Command Line**:
```bash
ddev list
```

**Custom UI Dashboard** (Optional):
Generate static HTML dashboard:
```bash
cd scripts
./generate-dashboard.sh
# Opens ddev-projects.html (auto-refresh every 5s)
```

Or serve with web server:
```bash
cd scripts
python3 -m http.server 8888
# Open: http://localhost:8888/ddev-projects.html
```

**Note**: Default port is 8888 (to avoid conflict with phpMyAdmin on 8080).

See `scripts/README.md` for more options (PHP, Node.js servers).

### Project URLs
- **Website**: `https://{project-name}.ddev.site`
- **Admin Panel**: `https://{project-name}.ddev.site/admin` (check `app/etc/env.php` for admin URL)
- **phpMyAdmin**: `https://{project-name}.ddev.site:8037` (database management)
- **Mailpit**: `https://{project-name}.ddev.site:8026` (email testing)

### Service Access
- **Database**: Host: `db`, Port: `3306`, User: `db`, Password: `db`
- **Redis**: `redis:6379` (inside container)
- **OpenSearch**: `opensearch:9200` (inside container)
- **RabbitMQ Management**: Available via router or `rabbitmq:15672` (User: `magento`, Pass: `magento`)

## Configuration

### Services Included
- PHP 8.3-FPM, Nginx, MariaDB 10.6
- Redis 7.2, OpenSearch 2.5, RabbitMQ 3.13
- phpMyAdmin (database management)

### Database Credentials
- Host: `db`, Database: `db`, User: `db`, Password: `db`

### Service Hosts (inside container)
- Redis: `redis:6379`
- OpenSearch: `opensearch:9200`
- RabbitMQ: `rabbitmq:5672` (Management: `rabbitmq:15672`, User: `magento`, Pass: `magento`)

### Configuration Files
- `.ddev/config.yaml` - Main DDEV configuration
- `.ddev/docker-compose.magento.yaml` - Additional services
- `app/etc/env.php` - Magento configuration

## Common Commands

```bash
# Project Management
ddev start|stop|restart              # Start/stop/restart project
ddev list                            # List all projects (shows status and URLs)
ddev describe                        # Show project info
ddev ssh                             # SSH into web container
ddev exec <command>                  # Execute command in container

# Magento
ddev exec bin/magento cache:clean
ddev exec bin/magento setup:upgrade
ddev exec bin/magento setup:di:compile
ddev exec bin/magento setup:static-content:deploy -f -j8

# Database
ddev import-db --file=path/to/db.sql
ddev export-db --file=backup.sql
ddev mysql                           # Access MySQL CLI
# phpMyAdmin available at https://{project-name}.ddev.site:8037

# Composer
ddev composer install|update|require vendor/package

# Debugging
ddev xdebug on|off                   # Enable/disable Xdebug
ddev logs [-s service]               # View logs
```

## DDEV Aliases - Short Commands

This template includes `.ddev_aliases` file with short aliases to save typing time.

### Quick Setup

```bash
# Option 1: Run setup script
./setup-aliases.sh

# Option 2: Load manually
source .ddev_aliases

# Option 3: Add to ~/.bashrc (auto-load for all projects)
echo "source $(pwd)/.ddev_aliases" >> ~/.bashrc
source ~/.bashrc
```

### Main Aliases

```bash
# Project management
ds, dst, dr          # start, stop, restart
ddes, dlist          # describe, list
dlaunch, dpower      # launch, poweroff

# Container & SSH
dssh, de, dlog       # ssh, exec, logs

# Database
ddb, dimp, dexp      # mysql, import-db, export-db

# Composer & PHP
dcom, dphp, dnode    # composer, php, npm

# Magento
dmage                # magento

# Debugging
dx, dxoff            # xdebug on/off
```

### Examples

```bash
# Instead of: ddev start
ds

# Instead of: ddev composer install
dcom install

# Instead of: ddev magento cache:flush
dmage cache:flush

# Instead of: ddev describe
ddes
```

See [ALIASES.md](ALIASES.md) for complete guide and other ways to shorten commands (bash completion, functions, scripts).

## Custom Commands (from docker-magento)

This template includes custom commands similar to docker-magento for easier workflow:

### Magento CLI
```bash
ddev magento [command]                # Run Magento CLI (e.g., ddev magento cache:flush)
ddev magento-version                  # Show Magento version
```

### Cache & Performance
```bash
ddev cache-clean                     # Clean cache using cache-clean.js
ddev cache-clean --watch             # Watch mode
ddev quick-cache-flush               # Quick cache flush
```

### Deployment
```bash
ddev deploy [locales]                # Full deployment (e.g., ddev deploy en_US vi_VN)
ddev compile                         # Compile DI and generate code
ddev upgrade                        # Run setup:upgrade and compile
```

### Indexing
```bash
ddev reindex [index_name]           # Reindex all or specific index
```

### Utilities
```bash
ddev log [log_files]                # View Magento logs (e.g., ddev log system.log)
ddev fixperms [directory]            # Fix filesystem permissions
ddev setup-domain [domain]          # Setup domain and base URLs
ddev create-user                    # Create admin or customer user
ddev n98 [command]                  # Run n98-magerun2 commands
ddev devconsole                     # Open Magento dev console
ddev grunt [task]                   # Run Grunt tasks
```

### Database & Backup
```bash
ddev mysqldump [file]               # Backup database
ddev backup-all [dir]                # Backup database and files
```

### Redis
```bash
ddev redis-cli [command]            # Access Redis CLI
```

See `.ddev/commands/DDEV_COMMANDS.md` for complete documentation.

## Troubleshooting

**Port Conflicts**: `ddev describe` to check ports, `ddev stop -p project-name` to stop conflicting project

**Permissions**:
```bash
ddev exec chmod -R 777 var pub/static pub/media generated
ddev exec chown -R www-data:www-data var pub/static pub/media generated
```

**Clear Cache**:
```bash
ddev exec bin/magento cache:clean && ddev exec bin/magento cache:flush
ddev exec rm -rf var/cache/* var/page_cache/* var/generation/*
```

**Rebuild**: `ddev restart` or `ddev poweroff && ddev start`

## Performance Tips

1. Keep Xdebug disabled when not debugging (default: off)
2. Use DDEV performance modes (Mutagen/NFS) on macOS/Windows
3. OPcache and Redis are already configured

## Migrating from docker-magento

Key differences:
- Database: `magento/magento/magento` → `db/db/db`
- Commands: `bin/cli` → `ddev exec`, `bin/bash` → `ddev ssh`
- Service hosts remain the same: `redis`, `opensearch`, `rabbitmq`

**Available DDEV commands:**

- `ddev magento` - Run Magento CLI commands (e.g., `ddev magento cache:flush`)
- `ddev magento-version` - Display Magento version
- `ddev cache-clean` - Clean Magento cache
- `ddev quick-cache-flush` - Quick cache flush
- `ddev deploy` - Deploy static content
- `ddev compile` - Compile DI
- `ddev upgrade` - Run setup:upgrade
- `ddev reindex` - Reindex Magento
- `ddev log` - View Magento logs
- `ddev fixperms` - Fix file permissions
- `ddev setup-install` - Full Magento installation
- `ddev setup-domain` - Setup domain
- `ddev create-user` - Create admin user
- `ddev n98` - Run n98-magerun2 commands
- `ddev mysql` - Access MySQL CLI
- `ddev mysqldump` - Dump database
- `ddev redis-cli` - Access Redis CLI
- `ddev grunt` - Run Grunt tasks
- `ddev devconsole` - Open development console

## Resources

- [DDEV Documentation](https://ddev.readthedocs.io/)
- [DDEV Magento Guide](https://docs.ddev.com/en/stable/users/quickstart/#magento-2/)

---

**Last Updated**: 2025-01-10
