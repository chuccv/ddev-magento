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

## Configuration

### Services Included
- PHP 8.3-FPM, Nginx, MariaDB 10.6
- Redis 7.2, OpenSearch 2.5, RabbitMQ 3.13

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
ddev list                            # List all projects
ddev describe                        # Show project info
ddev ssh                             # SSH into web container
ddev exec <command>                  # Execute command in container

# Magento
ddev exec bin/magento cache:clean
ddev exec bin/magento setup:upgrade
ddev exec bin/magento setup:di:compile
ddev exec bin/magento setup:static-content:deploy -f

# Database
ddev import-db --file=path/to/db.sql
ddev export-db --file=backup.sql
ddev mysql                           # Access MySQL CLI

# Composer
ddev composer install|update|require vendor/package

# Debugging
ddev xdebug on|off                   # Enable/disable Xdebug
ddev logs [-s service]               # View logs
```

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

## Resources

- [DDEV Documentation](https://ddev.readthedocs.io/)
- [Magento 2 Docs](https://devdocs.magento.com/)
- [DDEV Magento Guide](https://ddev.readthedocs.io/en/stable/users/project-types/magento/)

---

**Last Updated**: 2025-01-10
