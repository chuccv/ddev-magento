# DDEV Aliases - Lệnh Rút Gọn

File `.ddev_aliases` chứa các alias rút gọn cho các lệnh DDEV thường dùng, giúp tiết kiệm thời gian gõ lệnh.

## Cài Đặt

### Cách 1: Tự Động (Khuyến Nghị)

Chạy script setup:
```bash
source .ddev_aliases
```

Hoặc thêm vào `~/.bashrc` để tự động nạp cho tất cả project:
```bash
echo "source $(pwd)/.ddev_aliases" >> ~/.bashrc
source ~/.bashrc
```

### Cách 2: Thủ Công

Thêm vào `~/.bashrc` hoặc `~/.bash_aliases`:
```bash
source /path/to/project/.ddev_aliases
```

## Danh Sách Aliases

### Quản Lý Dự Án
- `ds` → `ddev start`
- `dst` → `ddev stop`
- `dr` → `ddev restart`
- `dlist` → `ddev list`
- `ddes` / `dstat` → `ddev describe`
- `dpower` → `ddev poweroff`
- `dlaunch` → `ddev launch`

### Container & SSH
- `dssh` → `ddev ssh`
- `de` → `ddev exec`
- `dlog` → `ddev logs`

### Database
- `ddb` → `ddev mysql`
- `dimp` → `ddev import-db`
- `dexp` → `ddev export-db`

### Composer & PHP
- `dcom` → `ddev composer`
- `dphp` → `ddev php`
- `dnode` → `ddev exec npm`

### Magento
- `dmage` → `ddev magento`
- `ddrush` → `ddev drush` (cho Drupal)

### Debugging
- `dx` → `ddev xdebug`
- `dxoff` → `ddev xdebug off`

### Cấu Hình
- `dconf` → `ddev config`
- `dclean` → `ddev clean`
- `ddel` → `ddev delete`

## Ví Dụ Sử Dụng

```bash
# Thay vì: ddev start
ds

# Thay vì: ddev describe
ddes

# Thay vì: ddev composer install
dcom install

# Thay vì: ddev magento cache:flush
dmage cache:flush

# Thay vì: ddev exec bin/magento setup:upgrade
de bin/magento setup:upgrade

# Thay vì: ddev mysql
ddb

# Thay vì: ddev xdebug on
dx on
```

## Các Cách Khác Để Rút Gọn Lệnh

### 1. Bash Completion (Tự Động Hoàn Thành)

DDEV có hỗ trợ bash completion. Cài đặt:

```bash
# Tạo completion script
ddev completion bash > ~/.ddev-completion.bash

# Thêm vào ~/.bashrc
echo "source ~/.ddev-completion.bash" >> ~/.bashrc
source ~/.bashrc
```

Sau đó bạn có thể gõ `ddev <TAB>` để xem tất cả lệnh có sẵn.

### 2. Bash Functions (Linh Hoạt Hơn Alias)

Tạo file `~/.ddev_functions`:

```bash
d() {
    case "$1" in
        s) ddev start ;;
        st) ddev stop ;;
        r) ddev restart ;;
        e) shift; ddev exec "$@" ;;
        ssh) ddev ssh ;;
        com) shift; ddev composer "$@" ;;
        mage) shift; ddev magento "$@" ;;
        *) ddev "$@" ;;
    esac
}
```

Thêm vào `~/.bashrc`:
```bash
source ~/.ddev_functions
```

Sử dụng: `d s`, `d e bin/magento cache:flush`, `d com install`

### 3. Custom Scripts

Tạo các script wrapper trong `~/bin/` (thêm vào PATH):

```bash
mkdir -p ~/bin

# Tạo script dstart
cat > ~/bin/dstart << 'EOF'
#!/bin/bash
ddev start "$@"
EOF

chmod +x ~/bin/dstart
```

### 4. Sử Dụng History & Search

Bash history có thể giúp bạn:
- `Ctrl+R`: Tìm kiếm ngược trong history
- `!!`: Lặp lại lệnh trước
- `!ddev`: Chạy lệnh ddev gần nhất

### 5. Tạo Alias Theo Project

Thêm vào `~/.bashrc`:
```bash
# Alias cho project cụ thể
alias ee248='cd /home/neil/Sites/ee248 && ddev start'
alias proj1='cd /path/to/proj1 && ddev start'
```

## So Sánh Các Phương Pháp

| Phương Pháp | Ưu Điểm | Nhược Điểm |
|------------|---------|------------|
| **Aliases** | Đơn giản, nhanh | Không hỗ trợ arguments phức tạp |
| **Functions** | Linh hoạt, hỗ trợ arguments | Phức tạp hơn |
| **Bash Completion** | Tự động gợi ý, không cần nhớ | Cần cài đặt |
| **Scripts** | Có thể thêm logic phức tạp | Cần quản lý nhiều file |

## Mẹo

1. **Kết hợp nhiều phương pháp**: Dùng aliases cho lệnh đơn giản, functions cho lệnh phức tạp
2. **Sử dụng history**: `history | grep ddev` để tìm lệnh đã dùng
3. **Tạo alias nhóm**: `alias dstart='ddev start && ddev launch'`
4. **Sử dụng với custom commands**: Aliases cũng hoạt động với custom commands như `dmage`, `ddeploy`

## Troubleshooting

**Alias không hoạt động?**
```bash
# Kiểm tra alias đã được nạp chưa
alias | grep ddev

# Nạp lại
source ~/.bashrc
# hoặc
source .ddev_aliases
```

**Xung đột với lệnh khác?**
```bash
# Kiểm tra xem có lệnh nào trùng tên không
which ds
type ds
```

**Muốn xóa alias?**
```bash
unalias ds
```
