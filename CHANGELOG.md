# Change Log
All notable changes to this project will be documented in this file.
This project adheres to [Semantic Versioning](http://semver.org/).

## [Unreleased][unreleased]

## [0.3.1] - 2015-04-03
### Fixed
- Fix check if build is needed
- After successful build, delete existing containers

## [0.3.0] - 2015-03-31
### Added
- Don't run as root. Shared folders are now created with uid/gid 1000.
  This is the uid of the default user on most systems, it should allow
  you to run "repo sync" etc. on the host machine (outside of the
  Docker container). NOTE: Ownership of existing folders
  (host machine: android/ + ccache/) will be fixed automatically on the
  first run. If you notice any problems, try to fix the ownership
  manually or remove the two folders on the host machine.
- Move ccache initialization to startup.sh. This fixes a major problem
  with ccache being initialized before the volume is mounted.
  The contents of /srv/ccache were therefore empty and
  CCACHE_MAXSIZE=50G was not set. The result was that ccache could only
  use up to 1 GB of cache data (default value). Thanks to a bigger
  cache, builds gets finished a lot faster thank before.
- Small Docker improvements. Add the CM version to the Docker image
  tag. Use cached images during "docker build". Be more verbose.
- Add this CHANGELOG.md file based on
  https://github.com/olivierlacan/keep-a-changelog/

## [0.2.0] - 2015-01-20
### Added
- Add changes to build CyanogenMod 12.0
- Add FORCE_BUILD flag
- Install rsync

### Fixed
- Fix issues with SELinux

## [0.1.0] - 2014-09-17
### Added
- Initial release

[unreleased]: https://github.com/stucki/docker-cyanogenmod/compare/v0.3.1...HEAD
[0.3.1]: https://github.com/stucki/docker-cyanogenmod/compare/v0.3.0...v0.3.1
[0.3.0]: https://github.com/stucki/docker-cyanogenmod/compare/v0.2.0...v0.3.0
[0.2.0]: https://github.com/stucki/docker-cyanogenmod/compare/v0.1.0...v0.2.0
