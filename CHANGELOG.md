# Changelog

All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [Unreleased]

## [1.0.0] - 2025-01-10

### Added
- DDEV configuration for Magento 2 with PHP 8.3, MariaDB 10.6
- Redis 7.2 integration for cache and session
- OpenSearch 2.5 integration for search engine
- RabbitMQ 3.13 integration for message queue
- Custom commands similar to docker-magento
- DDEV aliases to shorten commands
- Dashboard UI for managing DDEV projects
- Xdebug support with toggle command
- XHGui integration for performance profiling
- Mailpit for email testing
- Scripts to assist migration from docker-magento
- Documentation in Vietnamese and English

### Features
- Magento CLI commands: `ddev magento`, `ddev magento-version`
- Cache management: `ddev cache-clean`, `ddev quick-cache-flush`
- Deployment: `ddev deploy`, `ddev compile`, `ddev upgrade`
- Indexing: `ddev reindex`
- Database: `ddev mysqldump`, `ddev backup-all`
- Redis: `ddev redis-cli`
- Utilities: `ddev log`, `ddev fixperms`, `ddev setup-domain`, `ddev create-user`
- Grunt support: `ddev grunt`
- n98-magerun2 support: `ddev n98`
