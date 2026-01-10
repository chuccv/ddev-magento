# Magento 2 DDEV Setup

[English](README.md) | [Tiếng Việt](README.vi.md)

---

### Tổng Quan

Đây là dự án Magento 2 được cấu hình để chạy với **DDEV**, một công cụ môi trường phát triển local. DDEV cung cấp môi trường dựa trên Docker với tất cả các dịch vụ cần thiết cho phát triển Magento.

### DDEV Là Gì?

**DDEV** là một công cụ mã nguồn mở giúp đơn giản hóa phát triển web local. Nó tạo ra môi trường phát triển độc lập, có thể tái sử dụng bằng Docker containers. Các tính năng chính:

- **Hỗ trợ đa dự án**: Quản lý nhiều dự án cùng lúc không xung đột
- **Đa nền tảng**: Hoạt động trên Linux, macOS và Windows
- **Cấu hình sẵn**: Hỗ trợ nhiều CMS/framework (Magento, Drupal, WordPress, Laravel, v.v.)
- **Thiết lập dễ dàng**: Các lệnh đơn giản cho quản lý dự án
- **Môi trường nhất quán**: Cùng một môi trường trên tất cả các thành viên trong team

### Yêu Cầu

- **Docker Desktop** (hoặc Docker Engine + Docker Compose)
  - Tải xuống: [Docker Desktop](https://www.docker.com/products/docker-desktop)
  - Hoặc cài Docker Engine: [Cài Đặt Docker Engine](https://docs.docker.com/engine/install/)
- **DDEV** đã cài đặt ([Hướng dẫn cài đặt](https://ddev.readthedocs.io/en/stable/users/install/ddev-installation/))

### Cài Đặt DDEV

#### Linux / macOS / WSL2

```bash
curl -fsSL https://ddev.com/install.sh | bash
```

Sau khi cài đặt, khởi động lại terminal hoặc chạy:
```bash
source ~/.bashrc
```

#### Kiểm Tra Cài Đặt

```bash
ddev version
```

Bạn sẽ thấy số phiên bản DDEV nếu cài đặt thành công.

### DDEV Cơ Bản

#### Hiểu Về Cấu Trúc DDEV

- **Dự án**: Mỗi thư mục có folder `.ddev` là một dự án DDEV
- **Container**: Mỗi dịch vụ (web, db, redis) chạy trong container Docker riêng
- **Router**: Router của DDEV quản lý tất cả dự án và route requests đến đúng container
- **Config**: Cấu hình dự án được lưu trong `.ddev/config.yaml`

#### Các Khái Niệm DDEV Thường Dùng

1. **Tên dự án**: Tự động lấy từ tên thư mục (có thể ghi đè)
2. **URL**: Mỗi dự án có URL dạng `{tên-dự-án}.ddev.site`
3. **Dịch vụ**: Các dịch vụ được cấu hình sẵn (web, db) cộng với các dịch vụ bổ sung (redis, opensearch, v.v.)
4. **Đa dự án**: Có thể chạy nhiều dự án đồng thời - mỗi dự án có containers riêng biệt

#### Các Lệnh DDEV Cơ Bản

```bash
# Kiểm tra phiên bản DDEV
ddev version

# Liệt kê tất cả dự án
ddev list

# Khởi động một dự án (trong thư mục dự án)
ddev start

# Dừng một dự án
ddev stop

# Khởi động lại một dự án
ddev restart

# Dừng tất cả dự án
ddev stop -a

# Xem thông tin dự án
ddev describe

# SSH vào web container
ddev ssh

# Thực thi lệnh trong container
ddev exec <command>

# Xem logs
ddev logs
```

#### Thiết Lập Dự Án Mới

1. **Tạo thư mục dự án**:
   ```bash
   mkdir my-magento-project
   cd my-magento-project
   ```

2. **Cấu hình DDEV**:
   ```bash
   ddev config --project-type=magento2 --docroot=pub
   ```

3. **Khởi động dự án**:
   ```bash
   ddev start
   ```

4. **Truy cập dự án**: `https://my-magento-project.ddev.site`

### Bắt Đầu Nhanh

#### 1. Cài Đặt DDEV (nếu chưa cài)

```bash
curl -fsSL https://ddev.com/install.sh | bash
```

#### 2. Cấu Hình Dự Án

Nếu bạn chưa cấu hình DDEV cho dự án:

```bash
cd /đường/dẫn/đến/dự-án/magento
ddev config --project-type=magento2 --docroot=pub
```

Hoặc nếu dự án đã được cấu hình, chỉ cần khởi động:

```bash
cd /đường/dẫn/đến/dự-án/magento
ddev start
```

Dự án sẽ có sẵn tại: **https://{tên-dự-án}.ddev.site**

#### 3. Truy Cập Các Dịch Vụ

- **Website**: https://{tên-dự-án}.ddev.site
- **Trang Quản Trị**: https://{tên-dự-án}.ddev.site/admin (kiểm tra `app/etc/env.php` cho URL admin)
- **Database**: 
  - Host: `db`
  - Port: `3306` (trong container)
  - Database: `db`
  - Username: `db`
  - Password: `db`
- **OpenSearch**: Có sẵn tại `opensearch:9200` (trong container)
- **RabbitMQ Management**: Có sẵn tại `rabbitmq:15672` (trong container)
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
docker ps | grep ddev-

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

**Cập nhật lần cuối**: 2025-01-10

