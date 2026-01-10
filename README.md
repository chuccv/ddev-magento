# Magento 2 DDEV Setup

[English](README.md) | [Tiếng Việt](README.vi.md)

---

### Overview

This is a Magento 2 project configured to run with **DDEV**, a local development environment tool. DDEV provides a Docker-based environment with all necessary services for Magento development.

### What is DDEV?

**DDEV** is an open-source tool that simplifies local web development. It creates isolated, reproducible development environments using Docker containers. Key features:

- **Multi-project support**: Manage multiple projects simultaneously without conflicts
- **Cross-platform**: Works on Linux, macOS, and Windows
- **Pre-configured**: Supports many CMS/frameworks (Magento, Drupal, WordPress, Laravel, etc.)
- **Easy setup**: Simple commands for project management
- **Consistent environment**: Same environment across all team members

### Prerequisites

- **Docker Desktop** (or Docker Engine + Docker Compose)
  - Download: [Docker Desktop](https://www.docker.com/products/docker-desktop)
  - Or install Docker Engine: [Install Docker Engine](https://docs.docker.com/engine/install/)
- **DDEV** installed ([Installation Guide](https://ddev.readthedocs.io/en/stable/users/install/ddev-installation/))

### Installing DDEV

#### Linux / macOS / WSL2

```bash
curl -fsSL https://ddev.com/install.sh | bash
```

After installation, restart your terminal or run:
```bash
source ~/.bashrc
```

#### Verify Installation

```bash
ddev version
```

You should see the DDEV version number if installed correctly.

### DDEV Basics

#### Understanding DDEV Structure

- **Project**: Each directory with a `.ddev` folder is a DDEV project
- **Container**: Each service (web, db, redis) runs in its own Docker container
- **Router**: DDEV router manages all projects and routes requests to correct containers
- **Config**: Project configuration is stored in `.ddev/config.yaml`

#### Common DDEV Concepts

1. **Project Name**: Automatically derived from directory name (can be overridden)
2. **URL**: Each project gets a URL like `{projectname}.ddev.site`
3. **Services**: Pre-configured services (web, db) plus additional services (redis, opensearch, etc.)
4. **Multi-project**: Can run multiple projects simultaneously - each has isolated containers

#### Basic DDEV Commands

```bash
# Check DDEV version
ddev version

# List all projects
ddev list

# Start a project (in project directory)
ddev start

# Stop a project
ddev stop

# Restart a project
ddev restart

# Stop all projects
ddev stop -a

# View project information
ddev describe

# SSH into web container
ddev ssh

# Execute command in container
ddev exec <command>

# View logs
ddev logs
```

#### Setting Up a New Project

1. **Create project directory**:
   ```bash
   mkdir my-magento-project
   cd my-magento-project
   ```

2. **Configure DDEV**:
   ```bash
   ddev config --project-type=magento2 --docroot=pub
   ```

3. **Start the project**:
   ```bash
   ddev start
   ```

4. **Access your project**: `https://my-magento-project.ddev.site`

### Quick Start

#### 1. Install DDEV (if not already installed)

```bash
curl -fsSL https://ddev.com/install.sh | bash
```

#### 2. Configure Your Project

If you haven't configured DDEV yet for your project:

```bash
cd /path/to/your/magento/project
ddev config --project-type=magento2 --docroot=pub
```

Or if the project is already configured, just start it:

```bash
cd /path/to/your/magento/project
ddev start
```

The project will be available at: **https://{project-name}.ddev.site**

#### 3. Access Services

- **Website**: https://{project-name}.ddev.site
- **Admin Panel**: https://{project-name}.ddev.site/admin (check `app/etc/env.php` for admin URL)
- **Database**: 
  - Host: `db`
  - Port: `3306` (inside container)
  - Database: `db`
  - Username: `db`
  - Password: `db`
- **OpenSearch**: Available at `opensearch:9200` (inside container)
- **RabbitMQ Management**: Available at `rabbitmq:15672` (inside container)
  - Username: `magento`
  - Password: `magento`
- **Redis**: Available at `redis:6379` (inside container)

### Common Commands

#### Project Management

```bash
# Start the project
ddev start

# Stop the project
ddev stop

# Restart the project
ddev restart

# View project information
ddev describe

# List all DDEV projects
ddev list
```

#### Magento Commands

```bash
# Execute Magento CLI commands
ddev exec bin/magento cache:clean
ddev exec bin/magento cache:flush
ddev exec bin/magento setup:upgrade
ddev exec bin/magento setup:di:compile
ddev exec bin/magento setup:static-content:deploy -f

# Or enter the container and run commands directly
ddev ssh
bin/magento cache:clean
```

#### Database Operations

```bash
# Import database
ddev import-db --file=path/to/database.sql

# Export database
ddev export-db --file=database_backup.sql

# Access MySQL directly
ddev mysql
# or
ddev exec mysql -uroot -proot db
```

#### Composer Commands

```bash
# Install dependencies
ddev composer install

# Update dependencies
ddev composer update

# Require a package
ddev composer require vendor/package
```

#### Xdebug

```bash
# Enable Xdebug (when needed)
ddev xdebug on

# Disable Xdebug (default - better performance)
ddev xdebug off
```

### Project Configuration

#### Services Included

- **PHP**: 8.3-FPM
- **Web Server**: Nginx
- **Database**: MariaDB 10.6
- **Cache**: Redis 7.2
- **Search**: OpenSearch 2.5
- **Message Queue**: RabbitMQ 3.13

#### Configuration Files

- **DDEV Config**: `.ddev/config.yaml`
- **Additional Services**: `.ddev/docker-compose.magento.yaml`
- **Magento Config**: `app/etc/env.php`

### Environment Variables

The project uses default DDEV database credentials:
- Database: `db`
- Username: `db`
- Password: `db`
- Host: `db`

Redis, OpenSearch, and RabbitMQ are configured to use service names as hosts:
- Redis: `redis:6379`
- OpenSearch: `opensearch:9200`
- RabbitMQ: `rabbitmq:5672`

### Troubleshooting

#### Port Conflicts

If you encounter port conflicts:

```bash
# Check what's using the ports
ddev describe

# Stop conflicting project
ddev stop -p conflicting-project-name
```

#### Permissions Issues

```bash
# Fix file permissions
ddev exec chmod -R 777 var pub/static pub/media generated
ddev exec chown -R www-data:www-data var pub/static pub/media generated
```

#### Clear All Caches

```bash
ddev exec bin/magento cache:clean
ddev exec bin/magento cache:flush
ddev exec rm -rf var/cache/* var/page_cache/* var/generation/*
```

#### Rebuild Containers

```bash
# Rebuild project containers
ddev restart

# Full rebuild (if needed)
ddev poweroff
ddev start
```

#### Check Service Status

```bash
# View all containers
docker ps | grep ddev-

# Check logs
ddev logs
ddev logs -s db
ddev logs -s redis
```

### Performance Tips

1. **Disable Xdebug** when not debugging (it's disabled by default)
2. **Use DDEV's performance modes** (Mutagen/NFS) for better filesystem performance on macOS/Windows
3. **Enable OPcache** in PHP (already configured in DDEV)
4. **Use Redis** for caching (already configured)
5. **Optimize Magento** production mode for better performance

### Switching from docker-magento

This project was migrated from [docker-magento](https://github.com/markshust/docker-magento). Key differences:

- Database credentials changed from `magento/magento/magento` to `db/db/db`
- Service hostnames remain the same (`redis`, `opensearch`, `rabbitmq`)
- Use `ddev exec` instead of `bin/cli` or `bin/root`
- Use `ddev ssh` instead of `bin/bash`

### Useful Links

- [DDEV Documentation](https://ddev.readthedocs.io/)
- [Magento 2 Documentation](https://devdocs.magento.com/)
- [DDEV Magento Guide](https://ddev.readthedocs.io/en/stable/users/project-types/magento/)

---

**Last Updated**: 2025-01-10
