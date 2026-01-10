# DDEV Dashboard Scripts

Custom UI dashboard để xem danh sách DDEV projects thay vì dùng lệnh `ddev list`.

## Cách Sử Dụng (Đơn Giản Nhất)

### Generate Static HTML Dashboard

```bash
cd scripts
./generate-dashboard.sh
```

Script sẽ tạo file `ddev-projects.html` - mở trực tiếp trong browser:
- **Linux/Mac**: `xdg-open ddev-projects.html` hoặc `open ddev-projects.html`
- **Hoặc click đúp vào file** trong file manager

**Auto-refresh**: File HTML tự động refresh mỗi 5 giây.

### Hoặc Serve với Web Server

Sau khi generate, serve với Python:
```bash
cd scripts
python3 -m http.server 8888
# Mở: http://localhost:8888/ddev-projects.html
```

**Lưu ý**: Port 8888 (tránh xung đột với phpMyAdmin 8080).

## Các Option Khác

### Python Server với Auto-Refresh API

```bash
cd scripts
python3 ddev-dashboard-server.py
# Mở: http://localhost:8888/
```

### PHP Server

```bash
cd scripts
php -S localhost:8888 -t .
# Mở: http://localhost:8888/ddev-dashboard.html
```

## Tính Năng

- ✅ Hiển thị tất cả DDEV projects với UI đẹp
- ✅ Hiển thị trạng thái (running, stopped, error)
- ✅ Hiển thị URLs (HTTP, HTTPS, Mailpit)
- ✅ Auto-refresh mỗi 5 giây (tùy chọn)
- ✅ Responsive design
- ✅ Click vào URL để mở project

## Lưu Ý

- Cần có `ddev` command trong PATH
- Server cần quyền thực thi `ddev list -j`
- Dashboard sử dụng JSON output từ `ddev list -j`
