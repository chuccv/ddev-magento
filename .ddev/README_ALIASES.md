# DDEV Aliases & Shortcuts

## Thêm alias và autocomplete vào host machine

Để sử dụng alias `dm2` và autocomplete cho các lệnh tắt trên host machine:

### Cách 1: Source file từ project (khuyến nghị)

Thêm vào file `~/.bashrc` hoặc `~/.bash_aliases`:

```bash
# DDEV Magento alias và autocomplete - ee248 project
if [ -f "$HOME/Sites/ee248/.ddev/.bash_aliases_host" ]; then
    source "$HOME/Sites/ee248/.ddev/.bash_aliases_host"
fi
```

**Lưu ý:** Thay đổi đường dẫn `$HOME/Sites/ee248` cho phù hợp với đường dẫn project của bạn.

File `.bash_aliases_host` sẽ tự động load:
- Alias `dm2` cho `ddev magento`
- Alias `ddcko` cho `ddev`
- Bash completion cho tất cả các lệnh tắt (gõ `ddev <tab>` để xem gợi ý)

### Cách 2: Thêm trực tiếp

Hoặc thêm trực tiếp vào `~/.bashrc` hoặc `~/.bash_aliases`:

```bash
alias dm2="ddev magento"
```

### Áp dụng thay đổi

Sau khi thêm, chạy lệnh sau để áp dụng:

```bash
source ~/.bashrc
```

hoặc mở terminal mới.

## Sử dụng

### Autocomplete

Sau khi cấu hình, gõ `ddev <tab>` để xem danh sách tất cả các lệnh tắt có sẵn.

### Lệnh tắt

Chạy `ddev help` để xem danh sách đầy đủ các lệnh tắt.

Một số ví dụ:

```bash
# Cache
ddev cf          # cache:clean
ddev cfl         # cache:flush
ddev cs          # cache:status

# Setup
ddev su          # setup:upgrade
ddev sdc         # setup:di:compile
ddev ssd         # setup:static-content:deploy

# Indexer
ddev ir          # indexer:reindex
ddev is          # indexer:status

# Module
ddev ms          # module:status
ddev men         # module:enable
ddev mdis        # module:disable

# Maintenance
ddev me          # maintenance:enable
ddev md          # maintenance:disable
```

### Alias dm2

Bạn cũng có thể sử dụng alias `dm2`:

```bash
dm2 cache:flush
dm2 setup:upgrade
dm2 module:status
dm2 indexer:reindex
```

Thay vì:
```bash
ddev magento cache:flush
ddev magento setup:upgrade
```

Xem thêm: [README_SHORTCUTS.md](./README_SHORTCUTS.md)
