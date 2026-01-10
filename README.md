# GSP Magento 2 Project - DDEV Setup

## English | [Tiếng Việt](#tiếng-việt)

---

## English

### Overview

This is a Magento 2 project configured to run with **DDEV**, a local development environment tool. DDEV provides a Docker-based environment with all necessary services for Magento development.

### Prerequisites

- Docker Desktop (or Docker Engine + Docker Compose)
- DDEV installed ([Installation Guide](https://ddev.readthedocs.io/en/stable/users/install/ddev-installation/))

### Quick Start

#### 1. Install DDEV (if not already installed)

```bash
curl -fsSL https://ddev.com/install.sh | bash
```

#### 2. Start the Project

```bash
cd /home/neil/Sites/gsp
ddev start
```

The project will be available at: **https://gsp.ddev.site**

#### 3. Access Services

- **Website**: https://gsp.ddev.site
- **Admin Panel**: https://gsp.ddev.site/admin (check `app/etc/env.php` for admin URL)
- **Database**: 
  - Host: `db`
  - Port: `3306` (inside container)
  - Database: `db`
  - Username: `db`
  - Password: `db`
- **OpenSearch**: http://gsp.ddev.site:9200 (or via port 127.0.0.1:32787)
- **RabbitMQ Management**: http://gsp.ddev.site:15672 (or via port 127.0.0.1:32793)
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
docker ps | grep ddev-gsp

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

## Tiếng Việt

### Tổng Quan

Đây là dự án Magento 2 được cấu hình để chạy với **DDEV**, một công cụ môi trường phát triển local. DDEV cung cấp môi trường dựa trên Docker với tất cả các dịch vụ cần thiết cho phát triển Magento.

### Yêu Cầu

- Docker Desktop (hoặc Docker Engine + Docker Compose)
- DDEV đã cài đặt ([Hướng dẫn cài đặt](https://ddev.readthedocs.io/en/stable/users/install/ddev-installation/))

### Bắt Đầu Nhanh

#### 1. Cài Đặt DDEV (nếu chưa cài)

```bash
curl -fsSL https://ddev.com/install.sh | bash
```

#### 2. Khởi Động Dự Án

```bash
cd /home/neil/Sites/gsp
ddev start
```

Dự án sẽ có sẵn tại: **https://gsp.ddev.site**

#### 3. Truy Cập Các Dịch Vụ

- **Website**: https://gsp.ddev.site
- **Trang Quản Trị**: https://gsp.ddev.site/admin (kiểm tra `app/etc/env.php` cho URL admin)
- **Database**: 
  - Host: `db`
  - Port: `3306` (trong container)
  - Database: `db`
  - Username: `db`
  - Password: `db`
- **OpenSearch**: http://gsp.ddev.site:9200 (hoặc qua port 127.0.0.1:32787)
- **RabbitMQ Management**: http://gsp.ddev.site:15672 (hoặc qua port 127.0.0.1:32793)
  - Username: `magento`
  - Password: `magento`
- **Redis**: Có sẵn tại `redis:6379` (trong container)

### Các Lệnh Thường Dùng

#### Quản Lý Dự Án

```bash
# Khởi động dự án
ddev start

# Dừng dự án
ddev stop

# Khởi động lại dự án
ddev restart

# Xem thông tin dự án
ddev describe

# Liệt kê tất cả dự án DDEV
ddev list
```

#### Lệnh Magento

```bash
# Thực thi lệnh Magento CLI
ddev exec bin/magento cache:clean
ddev exec bin/magento cache:flush
ddev exec bin/magento setup:upgrade
ddev exec bin/magento setup:di:compile
ddev exec bin/magento setup:static-content:deploy -f

# Hoặc vào container và chạy lệnh trực tiếp
ddev ssh
bin/magento cache:clean
```

#### Thao Tác Database

```bash
# Import database
ddev import-db --file=đường/dẫn/database.sql

# Export database
ddev export-db --file=database_backup.sql

# Truy cập MySQL trực tiếp
ddev mysql
# hoặc
ddev exec mysql -uroot -proot db
```

#### Lệnh Composer

```bash
# Cài đặt dependencies
ddev composer install

# Cập nhật dependencies
ddev composer update

# Yêu cầu một package
ddev composer require vendor/package
```

#### Xdebug

```bash
# Bật Xdebug (khi cần debug)
ddev xdebug on

# Tắt Xdebug (mặc định - hiệu suất tốt hơn)
ddev xdebug off
```

### Cấu Hình Dự Án

#### Các Dịch Vụ Đã Cài Đặt

- **PHP**: 8.3-FPM
- **Web Server**: Nginx
- **Database**: MariaDB 10.6
- **Cache**: Redis 7.2
- **Search**: OpenSearch 2.5
- **Message Queue**: RabbitMQ 3.13

#### Các File Cấu Hình

- **DDEV Config**: `.ddev/config.yaml`
- **Dịch Vụ Bổ Sung**: `.ddev/docker-compose.magento.yaml`
- **Magento Config**: `app/etc/env.php`

### Biến Môi Trường

Dự án sử dụng thông tin đăng nhập database mặc định của DDEV:
- Database: `db`
- Username: `db`
- Password: `db`
- Host: `db`

Redis, OpenSearch và RabbitMQ được cấu hình để sử dụng tên dịch vụ làm host:
- Redis: `redis:6379`
- OpenSearch: `opensearch:9200`
- RabbitMQ: `rabbitmq:5672`

### Khắc Phục Sự Cố

#### Xung Đột Port

Nếu gặp xung đột port:

```bash
# Kiểm tra port đang được sử dụng
ddev describe

# Dừng dự án xung đột
ddev stop -p tên-dự-án-xung-đột
```

#### Vấn Đề Quyền Truy Cập

```bash
# Sửa quyền file
ddev exec chmod -R 777 var pub/static pub/media generated
ddev exec chown -R www-data:www-data var pub/static pub/media generated
```

#### Xóa Tất Cả Cache

```bash
ddev exec bin/magento cache:clean
ddev exec bin/magento cache:flush
ddev exec rm -rf var/cache/* var/page_cache/* var/generation/*
```

#### Xây Dựng Lại Containers

```bash
# Khởi động lại containers
ddev restart

# Xây dựng lại hoàn toàn (nếu cần)
ddev poweroff
ddev start
```

#### Kiểm Tra Trạng Thái Dịch Vụ

```bash
# Xem tất cả containers
docker ps | grep ddev-gsp

# Xem logs
ddev logs
ddev logs -s db
ddev logs -s redis
```

### Mẹo Hiệu Suất

1. **Tắt Xdebug** khi không debug (mặc định đã tắt)
2. **Sử dụng chế độ hiệu suất của DDEV** (Mutagen/NFS) để cải thiện hiệu suất filesystem trên macOS/Windows
3. **Bật OPcache** trong PHP (đã được cấu hình trong DDEV)
4. **Sử dụng Redis** cho caching (đã được cấu hình)
5. **Tối ưu Magento** production mode để hiệu suất tốt hơn

### Chuyển Đổi Từ docker-magento

Dự án này đã được migrate từ [docker-magento](https://github.com/markshust/docker-magento). Các điểm khác biệt chính:

- Thông tin đăng nhập database đã thay đổi từ `magento/magento/magento` sang `db/db/db`
- Tên hostname dịch vụ vẫn giống nhau (`redis`, `opensearch`, `rabbitmq`)
- Sử dụng `ddev exec` thay vì `bin/cli` hoặc `bin/root`
- Sử dụng `ddev ssh` thay vì `bin/bash`

### Liên Kết Hữu Ích

- [Tài Liệu DDEV](https://ddev.readthedocs.io/)
- [Tài Liệu Magento 2](https://devdocs.magento.com/)
- [Hướng Dẫn DDEV Magento](https://ddev.readthedocs.io/en/stable/users/project-types/magento/)

---

## Quick Reference / Tài Liệu Tham Khảo Nhanh

| English | Tiếng Việt | Command |
|---------|-----------|---------|
| Start project | Khởi động dự án | `ddev start` |
| Stop project | Dừng dự án | `ddev stop` |
| Restart project | Khởi động lại dự án | `ddev restart` |
| View info | Xem thông tin | `ddev describe` |
| SSH into container | SSH vào container | `ddev ssh` |
| Execute command | Thực thi lệnh | `ddev exec <command>` |
| Import database | Import database | `ddev import-db --file=<file>` |
| Export database | Export database | `ddev export-db --file=<file>` |
| Clear cache | Xóa cache | `ddev exec bin/magento cache:clean` |
| Enable Xdebug | Bật Xdebug | `ddev xdebug on` |
| Disable Xdebug | Tắt Xdebug | `ddev xdebug off` |

---

**Last Updated**: 2025-01-10

