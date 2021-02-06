# Changelog

## 0.2.0

### Improvements

- Is now based on Debian 10
- Uses Shibboleth SP v3, packaged by SWITCH
- Contains a runs_once directory for miscellaneous init scripts
- Improved Runit startup process

### Fixes

- Services now finish when the container is sent a kill signal or ctrl-c-ed from the commandline
- No warnings during Docker container build process

## 0.1.0

### Initial release
