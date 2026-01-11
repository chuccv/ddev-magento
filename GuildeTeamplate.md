# DDEV Template Guide - Copying .ddev Folder to Another Project

## Can I Copy the .ddev Folder to Another Project?

**Yes, you can copy the `.ddev` folder to another project and start it directly**, but there are a few important considerations:

## Quick Answer

You can copy the `.ddev` folder and start it, but you should **remove or comment out the `name` field** in `config.yaml` to avoid project name conflicts. DDEV will automatically use the directory name as the project name.

## Detailed Steps

### 1. Copy the .ddev Folder

```bash
# Copy the entire .ddev folder to your new project
cp -r /path/to/source/.ddev /path/to/new/project/
```

### 2. Update config.yaml

Open `.ddev/config.yaml` and remove or comment out the `name` field:

**Before:**
```yaml
name: ee248
type: magento2
docroot: pub
```

**After:**
```yaml
# name: ee248  # Commented out - DDEV will use directory name
type: magento2
docroot: pub
```

**Why?** According to DDEV documentation:
> If the name is omitted, the project will take the name of the enclosing directory, which is useful if you want to have a copy of the project side by side with this one.

### 3. Verify Configuration

Check these settings in `config.yaml` to ensure they match your new project:

- **`docroot`**: Should point to your web root (e.g., `pub` for Magento 2)
- **`type`**: Should match your project type (e.g., `magento2`, `drupal`, `wordpress`)
- **`php_version`**: Verify it matches your requirements
- **`database`**: Check database type and version

### 4. Optional: Review Docker Compose Overrides

If your new project doesn't need certain services, you can remove or ignore:
- `.ddev/docker-compose.redis.yaml` (if Redis not needed)
- `.ddev/docker-compose.opensearch.yaml` (if OpenSearch not needed)
- `.ddev/docker-compose.xhgui-override.yaml` (if XHGui not needed)

### 5. Start the Project

```bash
cd /path/to/new/project
ddev start
```

DDEV will automatically:
- Detect the project name from the directory
- Validate the configuration
- Adjust settings if needed
- Start the containers

## When to Use `ddev config` Instead

You should run `ddev config` if:

1. **Different project type**: Your new project is not Magento 2 (e.g., Drupal, WordPress)
2. **Different structure**: The `docroot` path is different
3. **Fresh setup**: You want DDEV to generate a clean configuration
4. **Custom requirements**: You need different PHP version, database type, etc.

Example:
```bash
cd /path/to/new/project
ddev config --project-type=magento2 --docroot=pub
```

## Summary

| Scenario | Action |
|----------|--------|
| Same project type, same structure | Copy `.ddev` folder, remove `name` field, run `ddev start` |
| Different project type or structure | Run `ddev config` to create new configuration |
| Want to reuse most settings | Copy `.ddev` folder, edit `config.yaml`, then `ddev start` |

## Best Practice

For template projects, it's recommended to:
1. Remove the `name` field from `config.yaml` (or set it as a comment)
2. Document any project-specific requirements
3. Include a README explaining the configuration

This makes the template more reusable across different projects.

## Adding OpenSearch and Elasticsearch

DDEV provides official add-ons for both OpenSearch and Elasticsearch search engines. You can add them to your project using the `ddev get` command.

### Adding OpenSearch

OpenSearch is an open-source search and analytics engine. To add it to your DDEV project:

```bash
cd /path/to/your/project
ddev get ddev/ddev-opensearch
ddev restart
```

**What it includes:**
- OpenSearch server (port 9200)
- OpenSearch Dashboards (port 5601/5602 for UI)
- Pre-configured with security disabled for development
- Includes useful plugins: `analysis-icu` and `analysis-phonetic`

**Access URLs:**
- OpenSearch API: `http://opensearch:9200` (inside container)
- OpenSearch Dashboards: `https://{project-name}.ddev.site:5602`

**Configuration files created:**
- `.ddev/docker-compose.opensearch.yaml` - Docker Compose override
- `.ddev/addon-metadata/ddev-opensearch/manifest.yaml` - Add-on metadata

**Custom commands available:**
```bash
ddev opensearch-info      # Show cluster information
ddev opensearch-list      # List all indices
ddev opensearch-sample    # Create sample test data
ddev opensearch-dashboards [on|off]  # Enable/disable dashboards
```

### Adding Elasticsearch

Elasticsearch is another popular search engine. To add it to your DDEV project:

```bash
cd /path/to/your/project
ddev get ddev/ddev-elasticsearch
ddev restart
```

**What it includes:**
- Elasticsearch server (port 9200)
- Kibana (optional, for visualization)
- Pre-configured for development use

**Access URLs:**
- Elasticsearch API: `http://elasticsearch:9200` (inside container)
- Kibana (if included): `https://{project-name}.ddev.site:5601`

**Configuration files created:**
- `.ddev/docker-compose.elasticsearch.yaml` - Docker Compose override
- `.ddev/addon-metadata/ddev-elasticsearch/manifest.yaml` - Add-on metadata

### Using with Magento 2

If you're using Magento 2, you can configure the search engine during setup:

**For OpenSearch:**
```bash
ddev setup-install --search-engine=opensearch
```

**For Elasticsearch 7:**
```bash
ddev setup-install --search-engine=elasticsearch7
```

**For Elasticsearch 8:**
```bash
ddev setup-install --search-engine=elasticsearch8
```

The setup script will automatically configure Magento to use the selected search engine.

### Removing Search Engines

To remove an add-on:

```bash
# Remove OpenSearch
ddev get --remove ddev/ddev-opensearch

# Remove Elasticsearch
ddev get --remove ddev/ddev-elasticsearch
```

After removal, restart your project:
```bash
ddev restart
```

**What gets removed when you remove an add-on:**

**For OpenSearch (`ddev get --remove ddev/ddev-opensearch`):**
- `.ddev/docker-compose.opensearch.yaml` - Docker Compose override file
- `.ddev/addon-metadata/ddev-opensearch/` - Add-on metadata directory (including `manifest.yaml`)
- OpenSearch Docker volumes and data (indices will be lost)
- OpenSearch and OpenSearch Dashboards containers

**For Elasticsearch (`ddev get --remove ddev/ddev-elasticsearch`):**
- `.ddev/docker-compose.elasticsearch.yaml` - Docker Compose override file
- `.ddev/addon-metadata/ddev-elasticsearch/` - Add-on metadata directory (including `manifest.yaml`)
- Elasticsearch Docker volumes and data (indices will be lost)
- Elasticsearch and Kibana containers (if included)

**Note:** Custom commands (like `opensearch-info`, `opensearch-list`, etc.) that were created separately are **NOT** automatically removed by `ddev get --remove`. You need to manually delete them if you no longer need them:
- `.ddev/commands/host/opensearch-*`
- `.ddev/commands/web/opensearch-*` (if any)

**To completely clean up:**
```bash
# Remove the add-on
ddev get --remove ddev/ddev-opensearch

# Manually remove custom commands (if you created them separately)
rm -f .ddev/commands/host/opensearch-*
rm -f .ddev/commands/web/opensearch-*

# Remove Docker volumes (optional, removes all data)
ddev poweroff
docker volume ls | grep opensearch | awk '{print $2}' | xargs docker volume rm

# Restart
ddev start
```

### Notes

- **Both engines can coexist**: You can have both OpenSearch and Elasticsearch in the same project, but typically you'll only use one
- **Resource usage**: Both engines require significant memory (default: 512MB each). Adjust `OPENSEARCH_JAVA_OPTS` or `ES_JAVA_OPTS` if needed
- **Port conflicts**: Make sure ports 9200, 5601, 5602 are not in use by other services
- **Data persistence**: Search indices are stored in Docker volumes and persist across restarts

### Troubleshooting

**Check if services are running:**
```bash
ddev describe
```

**View logs:**
```bash
ddev logs -s opensearch
# or
ddev logs -s elasticsearch
```

**Test connection:**
```bash
# For OpenSearch
ddev exec curl http://opensearch:9200

# For Elasticsearch
ddev exec curl http://elasticsearch:9200
```
