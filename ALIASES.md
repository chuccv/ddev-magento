# DDEV Aliases - Command Shortcuts

The `.ddev_aliases` file contains shorthand aliases for commonly used DDEV commands, helping save time when typing commands.

## Installation

### Method 1: Automatic (Recommended)

Run the setup script:
```bash
source .ddev_aliases
```

Or add to `~/.bashrc` to auto-load for all projects:
```bash
echo "source $(pwd)/.ddev_aliases" >> ~/.bashrc
source ~/.bashrc
```

### Method 2: Manual

Add to `~/.bashrc` or `~/.bash_aliases`:
```bash
source /path/to/project/.ddev_aliases
```

## Alias List

### Project Management
- `ds` → `ddev ` (run command in container)
- `dstart` → `ddev start`
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
- `dm2` → `ddev magento`

### Debugging
- `dx` → `ddev xdebug`
- `dxoff` → `ddev xdebug off`

### Configuration
- `dconf` → `ddev config`
- `dclean` → `ddev clean`
- `ddel` → `ddev delete`

## Usage Examples

```bash
# Instead of: ddev start
dstart
# or
ds  # (run command in container, e.g.: ds magento --version)

# Instead of: ddev describe
ddes

# Instead of: ddev composer install
dcom install

# Instead of: ddev magento cache:flush
dmage cache:flush

# Instead of: ddev exec bin/magento setup:upgrade
de bin/magento setup:upgrade

# Instead of: ddev mysql
ddb

# Instead of: ddev xdebug on
dx on
```

## Other Ways to Shorten Commands

### 1. Bash Completion (Auto-complete)

DDEV supports bash completion. Install:

```bash
# Create completion script
ddev completion bash > ~/.ddev-completion.bash

# Add to ~/.bashrc
echo "source ~/.ddev-completion.bash" >> ~/.bashrc
source ~/.bashrc
```

Then you can type `ddev <TAB>` to see all available commands.

### 2. Bash Functions (More Flexible Than Aliases)

Create file `~/.ddev_functions`:

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

Add to `~/.bashrc`:
```bash
source ~/.ddev_functions
```

Usage: `d s`, `d e bin/magento cache:flush`, `d com install`

### 3. Custom Scripts

Create wrapper scripts in `~/bin/` (add to PATH):

```bash
mkdir -p ~/bin

# Create dstart script
cat > ~/bin/dstart << 'EOF'
#!/bin/bash
ddev start "$@"
EOF

chmod +x ~/bin/dstart
```

### 4. Using History & Search

Bash history can help you:
- `Ctrl+R`: Reverse search in history
- `!!`: Repeat last command
- `!ddev`: Run the most recent ddev command

### 5. Create Project-Specific Aliases

Add to `~/.bashrc`:
```bash
# Alias for specific project
alias ee248='cd /home/neil/Sites/ee248 && ddev start'
alias proj1='cd /path/to/proj1 && ddev start'
```

## Method Comparison

| Method | Advantages | Disadvantages |
|--------|------------|---------------|
| **Aliases** | Simple, fast | Don't support complex arguments |
| **Functions** | Flexible, support arguments | More complex |
| **Bash Completion** | Auto-suggest, no need to remember | Requires installation |
| **Scripts** | Can add complex logic | Need to manage multiple files |

## Tips

1. **Combine multiple methods**: Use aliases for simple commands, functions for complex commands
2. **Use history**: `history | grep ddev` to find used commands
3. **Create group aliases**: `alias dstart='ddev start && ddev launch'`
4. **Use with custom commands**: Aliases also work with custom commands like `dmage`, `ddeploy`

## Troubleshooting

**Alias not working?**
```bash
# Check if alias is loaded
alias | grep ddev

# Reload
source ~/.bashrc
# or
source .ddev_aliases
```

**Conflict with other commands?**
```bash
# Check if any command has the same name
which ds
type ds
```

**Want to remove alias?**
```bash
unalias ds
```
