# DDEV Custom Commands - Từ Docker Magento

Danh sách các custom commands được thêm vào ddev để sử dụng tiện hơn, tương tự như docker-magento.

## Commands (Web Container)

### Magento CLI

#### `ddev magento [command]`
Chạy Magento CLI commands
```bash
ddev magento cache:flush
ddev magento setup:upgrade
ddev magento indexer:reindex
```

#### `ddev magento-version`
Hiển thị phiên bản Magento
```bash
ddev magento-version
```

### Cache & Performance

#### `ddev cache-clean [options]`
Clean cache sử dụng cache-clean.js
```bash
ddev cache-clean
ddev cache-clean --watch  # Watch mode
```

#### `ddev quick-cache-flush`
Quick flush cache (alias cho magento cache:flush)
```bash
ddev quick-cache-flush
```

### Deployment & Compilation

#### `ddev deploy [locales]`
Chạy quy trình deployment chuẩn của Magento
```bash
ddev deploy
ddev deploy en_US vi_VN
```

#### `ddev compile`
Compile Magento DI và generate code
```bash
ddev compile
```

#### `ddev upgrade`
Chạy setup:upgrade và compile
```bash
ddev upgrade
```

### Indexing

#### `ddev reindex [index_name]`
Reindex Magento indexes
```bash
ddev reindex                    # Reindex tất cả
ddev reindex catalog_product    # Reindex cụ thể
```

### User Management

#### `ddev create-user`
Tạo admin hoặc customer user
```bash
ddev create-user
```

### Logs

#### `ddev log [log_files]`
Xem Magento logs
```bash
ddev log                        # Xem tất cả logs
ddev log system.log exception.log  # Xem logs cụ thể
```

### Utilities

#### `ddev fixperms [directory]`
Fix filesystem permissions
```bash
ddev fixperms                   # Fix tất cả
ddev fixperms var               # Fix directory cụ thể
```

#### `ddev setup-domain [domain]`
Setup domain name và base URLs
```bash
ddev setup-domain ee246.com
```

#### `ddev n98 [command]`
Chạy n98-magerun2 commands
```bash
ddev n98 sys:info
ddev n98 customer:list
ddev n98 config:get web/secure/base_url
```

#### `ddev devconsole`
Mở Magento dev console (n98-magerun2 dev:console)
```bash
ddev devconsole
```

#### `ddev grunt [task]`
Chạy Grunt tasks
```bash
ddev grunt
ddev grunt watch
```

## Database Commands

#### `ddev mysql [options]`
Truy cập MySQL CLI
```bash
ddev mysql
ddev mysql -e "SHOW DATABASES;"
ddev mysql -e "SELECT * FROM admin_user;"
```

## Host Commands

#### `ddev mysqldump [output_file]`
Backup database
```bash
ddev mysqldump                  # Tự động tạo tên file với timestamp
ddev mysqldump backup.sql       # Chỉ định tên file
```

#### `ddev backup-all [backup_dir]`
Backup database và files
```bash
ddev backup-all                 # Backup vào thư mục backups/
ddev backup-all my-backups      # Backup vào thư mục tùy chỉnh
```

## Redis Commands

#### `ddev redis-cli [command]`
Truy cập Redis CLI
```bash
ddev redis-cli
ddev redis-cli PING
ddev redis-cli KEYS "*"
```

## So sánh với Docker Magento

| Docker Magento | DDEV |
|----------------|------|
| `make magento cache:flush` | `ddev magento cache:flush` |
| `make cache-clean` | `ddev cache-clean` |
| `make deploy` | `ddev deploy` |
| `make log` | `ddev log` |
| `make fixperms` | `ddev fixperms` |
| `make mysql` | `ddev mysql` |
| `make mysqldump` | `ddev mysqldump` |
| `make create-user` | `ddev create-user` |
| `make setup-domain` | `ddev setup-domain` |
| `make n98-magerun2` | `ddev n98` |

## Lưu ý

- Tất cả các commands đều chạy trong ddev environment
- Các commands đã được cấu hình để hoạt động tương tự như docker-magento
- Có thể xem thêm commands bằng: `ddev help`
- Các commands tự động được thêm vào ddev sau khi start project
