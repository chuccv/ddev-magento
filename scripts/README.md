# DDEV Dashboard Scripts

Custom UI dashboard to view DDEV projects list instead of using `ddev list` command.

## Usage (Simplest Way)

### Generate Static HTML Dashboard

```bash
cd scripts
./generate-dashboard.sh
```

The script will create `ddev-projects.html` file - open directly in browser:
- **Linux/Mac**: `xdg-open ddev-projects.html` or `open ddev-projects.html`
- **Or double-click the file** in file manager

**Auto-refresh**: HTML file automatically refreshes every 5 seconds.

### Or Serve with Web Server

After generating, serve with Python:
```bash
cd scripts
python3 -m http.server 8888
# Open: http://localhost:8888/ddev-projects.html
```

**Note**: Port 8888 (to avoid conflict with phpMyAdmin 8080).

## Other Options

### Python Server with Auto-Refresh API

```bash
cd scripts
python3 ddev-dashboard-server.py
# Open: http://localhost:8888/
```

### PHP Server

```bash
cd scripts
php -S localhost:8888 -t .
# Open: http://localhost:8888/ddev-dashboard.html
```

## Features

- ✅ Display all DDEV projects with beautiful UI
- ✅ Display status (running, stopped, error)
- ✅ Display URLs (HTTP, HTTPS, Mailpit)
- ✅ Auto-refresh every 5 seconds (optional)
- ✅ Responsive design
- ✅ Click on URL to open project

## Notes

- Requires `ddev` command in PATH
- Server needs permission to execute `ddev list -j`
- Dashboard uses JSON output from `ddev list -j`
