# Magento 2 DDEV Setup

[English](README.md) | [Tiếng Việt](README.vi.md)

Template cấu hình DDEV cho Magento 2 với PHP 8.3, MariaDB 10.6, Redis, OpenSearch và RabbitMQ.

## Yêu Cầu & Cài Đặt

### Yêu Cầu
- Docker Desktop hoặc Docker Engine + Docker Compose
- DDEV: `curl -fsSL https://ddev.com/install.sh | bash`
- Kiểm tra: `ddev version`

### DDEV Là Gì?
DDEV là công cụ mã nguồn mở tạo môi trường phát triển dựa trên Docker. Tính năng chính:
- Hỗ trợ đa dự án (chạy nhiều dự án cùng lúc)
- Đa nền tảng (Linux, macOS, Windows)
- Cấu hình sẵn cho Magento, Drupal, WordPress, Laravel, v.v.
- Môi trường nhất quán cho toàn team

## Bắt Đầu Nhanh

1. **Cấu hình dự án**:
   ```bash
   cd /đường/dẫn/đến/dự-án/magento
   ddev config --project-type=magento2 --docroot=pub
   ```

2. **Khởi động dự án**:
   ```bash
   ddev start
   ```

3. **Truy cập**: `https://{tên-dự-án}.ddev.site`

## Truy Cập Các Dịch Vụ

### Kiểm Tra Dự Án Đang Chạy

**Dòng Lệnh**:
```bash
ddev list
```

**Custom UI Dashboard** (Tùy chọn):
Tạo static HTML dashboard:
```bash
cd scripts
./generate-dashboard.sh
# Mở file ddev-projects.html (tự động refresh mỗi 5 giây)
```

Hoặc serve với web server:
```bash
cd scripts
python3 -m http.server 8888
# Mở: http://localhost:8888/ddev-projects.html
```

**Lưu ý**: Port mặc định là 8888 (tránh xung đột với phpMyAdmin 8080).

Xem `scripts/README.md` để biết thêm các tùy chọn (PHP, Node.js servers).

### URL Dự Án
- **Website**: `https://{tên-dự-án}.ddev.site`
- **Trang Quản Trị**: `https://{tên-dự-án}.ddev.site/admin` (kiểm tra `app/etc/env.php` cho URL admin)
- **Mailpit**: `https://{tên-dự-án}.ddev.site:8026` (test email)

### Truy Cập Services
- **Database**: Host: `db`, Port: `3306`, User: `db`, Password: `db`
- **Redis**: `redis:6379` (trong container)
- **OpenSearch**: `opensearch:9200` (trong container)
- **RabbitMQ Management**: Có sẵn qua router hoặc `rabbitmq:15672` (User: `magento`, Pass: `magento`)

## Cấu Hình

### Dịch Vụ Bao Gồm
- PHP 8.3-FPM, Nginx, MariaDB 10.6
- Redis 7.2, OpenSearch 2.5, RabbitMQ 3.13

### Thông Tin Database
- Host: `db`, Database: `db`, User: `db`, Password: `db`

### Service Hosts (trong container)
- Redis: `redis:6379`
- OpenSearch: `opensearch:9200`
- RabbitMQ: `rabbitmq:5672` (Management: `rabbitmq:15672`, User: `magento`, Pass: `magento`)

### File Cấu Hình
- `.ddev/config.yaml` - Cấu hình DDEV chính
- `.ddev/docker-compose.magento.yaml` - Các dịch vụ bổ sung
- `app/etc/env.php` - Cấu hình Magento

## Các Lệnh Thường Dùng

```bash
# Quản Lý Dự Án
ddev start|stop|restart              # Khởi động/dừng/khởi động lại
ddev list                            # Liệt kê tất cả dự án (hiển thị trạng thái và URLs)
ddev describe                        # Hiển thị thông tin dự án
ddev ssh                             # SSH vào web container
ddev exec <command>                  # Thực thi lệnh trong container

# Magento
ddev exec bin/magento cache:clean
ddev exec bin/magento setup:upgrade
ddev exec bin/magento setup:di:compile
ddev exec bin/magento setup:static-content:deploy -f

# Database
ddev import-db --file=đường/dẫn/db.sql
ddev export-db --file=backup.sql
ddev mysql                           # Truy cập MySQL CLI

# Composer
ddev composer install|update|require vendor/package

# Debugging
ddev xdebug on|off                   # Bật/tắt Xdebug
ddev logs [-s service]               # Xem logs
```

## DDEV Aliases - Lệnh Rút Gọn

Template này bao gồm file `.ddev_aliases` với các alias rút gọn để tiết kiệm thời gian gõ lệnh.

### Cài Đặt Nhanh

```bash
# Cách 1: Chạy script tự động
./setup-aliases.sh

# Cách 2: Nạp thủ công
source .ddev_aliases

# Cách 3: Thêm vào ~/.bashrc (tự động cho tất cả project)
echo "source $(pwd)/.ddev_aliases" >> ~/.bashrc
source ~/.bashrc
```

### Các Alias Chính

```bash
# Quản lý dự án
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

### Ví Dụ

```bash
# Thay vì: ddev start
ds

# Thay vì: ddev composer install
dcom install

# Thay vì: ddev magento cache:flush
dmage cache:flush

# Thay vì: ddev describe
ddes
```

Xem [ALIASES.md](ALIASES.md) để biết hướng dẫn đầy đủ và các cách khác để rút gọn lệnh (bash completion, functions, scripts).

## Custom Commands (từ docker-magento)

Template này bao gồm các custom commands tương tự docker-magento để làm việc dễ dàng hơn:

### Magento CLI
```bash
ddev magento [command]                # Chạy Magento CLI (vd: ddev magento cache:flush)
ddev magento-version                  # Hiển thị phiên bản Magento
```

### Cache & Hiệu Suất
```bash
ddev cache-clean                     # Xóa cache bằng cache-clean.js
ddev cache-clean --watch             # Chế độ watch
ddev quick-cache-flush               # Xóa cache nhanh
```

### Deployment
```bash
ddev deploy [locales]                # Deployment đầy đủ (vd: ddev deploy en_US vi_VN)
ddev compile                         # Compile DI và generate code
ddev upgrade                        # Chạy setup:upgrade và compile
```

### Indexing
```bash
ddev reindex [index_name]           # Reindex tất cả hoặc index cụ thể
```

### Tiện Ích
```bash
ddev log [log_files]                # Xem Magento logs (vd: ddev log system.log)
ddev fixperms [directory]            # Sửa quyền filesystem
ddev setup-domain [domain]          # Setup domain và base URLs
ddev create-user                    # Tạo admin hoặc customer user
ddev n98 [command]                  # Chạy n98-magerun2 commands
ddev devconsole                     # Mở Magento dev console
ddev grunt [task]                   # Chạy Grunt tasks
```

### Database & Backup
```bash
ddev mysqldump [file]               # Backup database
ddev backup-all [dir]                # Backup database và files
```

### Redis
```bash
ddev redis-cli [command]            # Truy cập Redis CLI
```

Xem `.ddev/commands/DDEV_COMMANDS.md` để biết tài liệu đầy đủ.

## Khắc Phục Sự Cố

**Xung Đột Port**: `ddev describe` để kiểm tra ports, `ddev stop -p tên-dự-án` để dừng dự án xung đột

**Quyền Truy Cập**:
```bash
ddev exec chmod -R 777 var pub/static pub/media generated
ddev exec chown -R www-data:www-data var pub/static pub/media generated
```

**Xóa Cache**:
```bash
ddev exec bin/magento cache:clean && ddev exec bin/magento cache:flush
ddev exec rm -rf var/cache/* var/page_cache/* var/generation/*
```

**Xây Dựng Lại**: `ddev restart` hoặc `ddev poweroff && ddev start`

## Mẹo Hiệu Suất

1. Giữ Xdebug tắt khi không debug (mặc định: tắt)
2. Sử dụng chế độ hiệu suất DDEV (Mutagen/NFS) trên macOS/Windows
3. OPcache và Redis đã được cấu hình sẵn

## Chuyển Đổi Từ docker-magento

Điểm khác biệt:
- Database: `magento/magento/magento` → `db/db/db`
- Lệnh: `bin/cli` → `ddev exec`, `bin/bash` → `ddev ssh`
- Service hosts giữ nguyên: `redis`, `opensearch`, `rabbitmq`

**Các lệnh DDEV có sẵn:**

- `ddev magento` - Chạy lệnh Magento CLI (ví dụ: `ddev magento cache:flush`)
- `ddev magento-version` - Hiển thị phiên bản Magento
- `ddev cache-clean` - Xóa cache Magento
- `ddev quick-cache-flush` - Xóa cache nhanh
- `ddev deploy` - Deploy static content
- `ddev compile` - Compile DI
- `ddev upgrade` - Chạy setup:upgrade
- `ddev reindex` - Reindex Magento
- `ddev log` - Xem log Magento
- `ddev fixperms` - Sửa quyền file
- `ddev setup-install` - Cài đặt Magento đầy đủ
- `ddev setup-domain` - Thiết lập domain
- `ddev create-user` - Tạo admin user
- `ddev n98` - Chạy lệnh n98-magerun2
- `ddev mysql` - Truy cập MySQL CLI
- `ddev mysqldump` - Backup database
- `ddev redis-cli` - Truy cập Redis CLI
- `ddev grunt` - Chạy Grunt tasks
- `ddev devconsole` - Mở development console

## Tài Liệu

- [Tài Liệu DDEV](https://ddev.readthedocs.io/)
- [Tài Liệu Magento 2](https://devdocs.magento.com/)
- [Hướng Dẫn DDEV Magento](https://ddev.readthedocs.io/en/stable/users/project-types/magento/)

---

**Cập nhật lần cuối**: 2025-01-10
