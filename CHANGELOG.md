# Change Log
All notable changes to this project will be documented in this file.

The format is based on [Keep a Changelog](http://keepachangelog.com/)
and this project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased]

## [16.04-3.0.0] - 03/02/2017
### Added
- Basic travis testing using rubocop and shellcheck
- Make the client configs directory
- Support for lightsail cloud provider

### Changed
- Retrieving the IP from metadata can now be extended with multiple clouds
- Refactor Vagrantfile for modularity
- Use `dsaparam` during dhparam generation for faster initial server
  creation
- Reformat `config.yaml`

## [16.04-2.0.0] - 03/10/2016
### Changed
- moved config options from Vagrantfile to new config.yaml


## [16.04-1.0.0] - 21/09/2016
### Changed
- moved to Ubuntu 16.04
- switched client ovpn location from `client_certs/` to `client-configs/`
- rubocop fixes
- scripts moved from `shell/` to `provisioning/`
- client and server scripts are now based on templates

## [14.04-1.0.0] - 21/09/2016
### Added
- Initial release
