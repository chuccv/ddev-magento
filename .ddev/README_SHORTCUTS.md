# DDEV Magento Shortcuts

## Cài đặt Autocomplete

Để có autocomplete khi gõ `ddev <tab>`, thêm vào `~/.bashrc` hoặc `~/.bash_aliases`:

```bash
# DDEV completion - ee248 project
if [ -f "$HOME/Sites/ee248/.ddev/.bash_completion" ]; then
    source "$HOME/Sites/ee248/.ddev/.bash_completion"
fi
```

Sau đó chạy:
```bash
source ~/.bashrc
```

## Danh sách lệnh tắt

Chạy `ddev help` để xem danh sách đầy đủ các lệnh tắt.

### Cache
- `ddev cf` hoặc `ddev cc` - cache:clean
- `ddev cfl` - cache:flush
- `ddev cs` - cache:status
- `ddev cen` - cache:enable
- `ddev cdis` - cache:disable

### Setup
- `ddev su` - setup:upgrade
- `ddev sdc` - setup:di:compile
- `ddev ssd` - setup:static-content:deploy

### Indexer
- `ddev ir` - indexer:reindex
- `ddev is` - indexer:status
- `ddev isen` - indexer:set-mode enable
- `ddev iss` - indexer:set-mode schedule

### Module
- `ddev ms` - module:status
- `ddev men` - module:enable
- `ddev mdis` - module:disable

### Maintenance
- `ddev me` - maintenance:enable
- `ddev md` - maintenance:disable

### Deploy Mode
- `ddev dms` - deploy:mode:set
- `ddev dmshow` - deploy:mode:show

### Khác
- `ddev dm2` - wrapper cho ddev magento
- `ddev help` - hiển thị danh sách lệnh tắt
