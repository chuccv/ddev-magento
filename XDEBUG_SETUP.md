# Xdebug Setup Guide for DDEV

## Quick Start

### Enable/Disable Xdebug

```bash
# Enable Xdebug
ddev xdebug on

# Disable Xdebug
ddev xdebug off

# Check status
ddev xdebug status
```

### Verify Xdebug is Working

```bash
# Check if loaded
ddev exec php -m | grep xdebug

# Check configuration
ddev exec php -i | grep xdebug.mode
ddev exec php -r "echo extension_loaded('xdebug') ? 'Loaded ✓' : 'Not loaded ✗';"
```

## Recommended: Trigger Mode (Best Performance)

Trigger mode makes xdebug only activate when needed, keeping your website fast when not debugging.

### Setup Trigger Mode

**Step 1:** Create `.ddev/php/xdebug.ini`:

```ini
[xdebug]
xdebug.mode=debug
xdebug.start_with_request=trigger
xdebug.client_host=host.docker.internal
xdebug.client_port=9003
xdebug.idekey=PHPSTORM
```

**Step 2:** Restart DDEV:

```bash
ddev restart
```

DDEV automatically loads all `.ini` files from `.ddev/php/` directory.

### How Trigger Mode Works

- **Xdebug is always available** but only activates when triggered
- **Website runs at normal speed** when not debugging (no performance hit)
- **No need to use `ddev xdebug on/off`** - xdebug is always ready

### Activating Xdebug (When Needed)

**Option 1: Browser Extension (Easiest)**
- Install "Xdebug helper" extension (Chrome/Firefox)
- Click the extension icon to enable/disable debugging
- Extension sends `XDEBUG_SESSION` cookie automatically

**Option 2: Manual Cookie**
- Set cookie `XDEBUG_SESSION=PHPSTORM` (or any value) in browser
- Use browser DevTools or extension to set cookie

**Option 3: CLI with Trigger**
```bash
ddev exec php -dxdebug.start_with_request=trigger -dxdebug.trigger_value=PHPSTORM scripts/test-xdebug.php
```

**Option 4: IDE Auto-Trigger**
- Most IDEs (VS Code, PhpStorm) automatically send trigger when listening for debug connections
- Just start debugging in IDE and it will trigger xdebug

### Important Notes

⚠️ **When you use `ddev xdebug on`, DDEV may override `start_with_request` to `yes`** (makes it always active, slowing down website).

**To use trigger mode properly:**
- Set `xdebug_enabled: true` in `.ddev/config.yaml` (optional, xdebug extension is always available)
- **Don't use `ddev xdebug on`** - it overrides trigger mode
- Use browser extension or cookie to trigger when needed

## Alternative: Always On Mode (Not Recommended)

This makes xdebug run on every request, significantly slowing down your website.

### Setup Always On Mode

Create `.ddev/php/xdebug.ini`:

```ini
[xdebug]
xdebug.mode=debug
xdebug.start_with_request=yes
xdebug.client_host=host.docker.internal
xdebug.client_port=9003
xdebug.idekey=PHPSTORM
```

Then restart:
```bash
ddev restart
```

**Note:** Only use this if you need xdebug active on every request. Use trigger mode instead for better performance.

## IDE Configuration

### VS Code / Cursor

1. Install extension: **PHP Debug** (by Xdebug)

2. Create `.vscode/launch.json`:
```json
{
    "version": "0.2.0",
    "configurations": [
        {
            "name": "Listen for Xdebug",
            "type": "php",
            "request": "launch",
            "port": 9003,
            "pathMappings": {
                "/var/www/html": "${workspaceFolder}"
            },
            "log": true
        }
    ]
}
```

3. Set breakpoints and start debugging (F5)

### PhpStorm

1. Go to **File > Settings > Languages & Frameworks > PHP > Servers**

2. Add new server:
   - Name: `{project-name}.ddev.site`
   - Host: `{project-name}.ddev.site`
   - Port: `80`
   - Debugger: `Xdebug`
   - Use path mappings: ✓
   - Project files: `/var/www/html` → `[your project path]`

3. Go to **File > Settings > Languages & Frameworks > PHP > Debug**
   - Xdebug port: `9003`
   - Can accept external connections: ✓

4. Enable "Start Listening for PHP Debug Connections" (bug icon)

## Testing Xdebug

### Quick Test Script

Run the test script:
```bash
ddev exec php scripts/test-xdebug.php
```

This checks:
- Xdebug extension loading
- Xdebug version
- Xdebug configuration
- Available Xdebug functions

### Manual Testing

**Test with breakpoint:**
```bash
ddev exec php -r "xdebug_break(); echo 'Hello Xdebug';"
```

**Test with trigger mode:**
```bash
ddev exec php -dxdebug.start_with_request=trigger scripts/test-xdebug.php
```

**Check Xdebug info:**
```bash
ddev exec php -r "xdebug_info();"
```

### Debug CLI Scripts in IDE

1. **VS Code/Cursor**: 
   - Set breakpoints in your PHP file
   - Start debugging (F5) - "Listen for Xdebug"
   - Run: `ddev exec php -dxdebug.start_with_request=trigger scripts/test-xdebug.php`

2. **PhpStorm**:
   - Set breakpoints
   - Enable "Start Listening for PHP Debug Connections"
   - Run: `ddev exec php -dxdebug.start_with_request=trigger scripts/test-xdebug.php`

### Test Magento CLI with Xdebug

```bash
# With trigger mode
ddev exec php -dxdebug.start_with_request=trigger bin/magento --version

# Or use the test script
ddev exec php scripts/test-xdebug.php
```

## Advanced: Custom Configuration with Dockerfile

If you need more control, you can use `.ddev/web-build/` with Dockerfile:

**Step 1:** Create `.ddev/web-build/xdebug.ini`

**Step 2:** Create `.ddev/web-build/Dockerfile.xdebug`:
```dockerfile
ARG BASE_IMAGE
FROM $BASE_IMAGE
COPY xdebug.ini /usr/local/etc/php/conf.d/xdebug-custom.ini
```

**Step 3:** Restart DDEV:
```bash
ddev restart
```

**Note:** The `.ddev/php/` method is simpler and recommended for most cases.

## Troubleshooting

### Xdebug cannot connect

1. **Check if Xdebug is enabled:**
```bash
ddev xdebug status
```

2. **Check Xdebug configuration:**
```bash
ddev exec php -i | grep xdebug.client_port
ddev exec php -i | grep xdebug.mode
ddev exec php -i | grep xdebug.start_with_request
```

3. **Check firewall on host**

4. **Try restarting DDEV:**
```bash
ddev restart
```

### Xdebug slows down website

- **Use trigger mode** instead of always-on mode
- **Don't use `ddev xdebug on`** if using trigger mode (it overrides to always-on)
- Only activate xdebug when debugging (use browser extension)

### Configuration not applied

1. **Check file location:**
   - Should be `.ddev/php/xdebug.ini` (simple method)
   - Or `.ddev/web-build/xdebug.ini` with Dockerfile (advanced method)

2. **Verify file was loaded:**
```bash
ddev exec cat /usr/local/etc/php/conf.d/xdebug-custom.ini
# or
ddev exec ls -la /usr/local/etc/php/conf.d/ | grep xdebug
```

3. **Rebuild image if using Dockerfile:**
```bash
ddev debug rebuild
ddev restart
```

## Quick Commands (Aliases)

If you've loaded `.ddev_aliases`:
```bash
dx      # ddev xdebug on
dxoff   # ddev xdebug off
```

## Summary

**Best Practice:**
1. Use **trigger mode** (`.ddev/php/xdebug.ini` with `start_with_request=trigger`)
2. Use **browser extension** to enable/disable debugging
3. **Don't use `ddev xdebug on`** when using trigger mode
4. Website stays fast, xdebug only activates when needed

**Quick Setup:**
```bash
# 1. Create config file
echo '[xdebug]
xdebug.mode=debug
xdebug.start_with_request=trigger
xdebug.client_host=host.docker.internal
xdebug.client_port=9003
xdebug.idekey=PHPSTORM' > .ddev/php/xdebug.ini

# 2. Restart
ddev restart

# 3. Install browser extension "Xdebug helper"
# 4. Click extension icon to debug!
```
