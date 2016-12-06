# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]
### Added
- Basic travis testing using rubocop and shellcheck

### Changed
- moved config options from Vagrantfile to new config.yaml
- Retrieving the IP from metadata can now be extended with multiple clouds
- Refactor Vagrantfile for modularity
- Use `dsaparam` during dhparam generation for faster initial server
  creation

## [16.04-1.0.0]
### Changed
- moved to Ubuntu 16.04
- switched client ovpn location from `client_certs/` to `client-configs/`
- rubocop fixes
- scripts moved from `shell/` to `provisioning/`
- client and server scripts are now based on templates

## [14.04-1.0.0]
### Added
- Initial release
