# Changelog

## 0.7.0

### Major Changes

- Includes Mod Security 2 module for Apache, disabled by default (PR #8)

### Improvements

- Should no longer complain about OpenSSL versions (Debian fixed this, not me)

## 0.6.0

### Major Changes

- Kerberos support in Apache, from libapache2-mod-auth-gssapi and krb5-user (PRs #6 & #7)

### Improvements

- Update to Dockerfile base image to be more specific (Bookworm)

### Known Issues

- A [warning about OpenSSL versions](https://bugs.debian.org/cgi-bin/bugreport.cgi?bug=1069748) may be
  shown (due to upstream Debian issues) but does not seem to be a problem. 

## 0.5.1

### Major changes

- Package names for Shibboleth SP have been updated to match the new names in recent Debian releases

## 0.5.0

### Major changes

- Includes mod-auth-cas as an optional module. Enable it by setting `APACHE_EXTRA_MODS="auth_cas"`

## 0.4.0

### Major changes

- Includes mod-auth-openidc as an optional module. Enable it by setting `APACHE_EXTRA_MODS="auth_openidc"`

### Improvements

- Additional modules can be enabled by listing them in `APACHE_EXTRA_MODS`
- The default ServerName is set using the `SP_URL` ENV variable.

### Fixes

- Certificates and keys in /etc/shibboleth with typical filenames will have their
  permissions adjusted at runtime.
- UseCanonical is now `on` by default

## 0.3.1

D'oh, a minor script bug needs to be fixed

### Fixes

- The keygen.sh wrapper script would not run properly in descendent images as
  it wouldn't overwrite. Fixed by adding a -f force flag

## 0.3.0

A big rewrite to do mostly the same thing but a little bit better

### Major changes

- SWITCH no longer produces custom Shibboleth SP packages but Debian's are fine now,
  so we use those instead.
- Scripts and tools that were copied to /opt/admin are now in /etc/rasp
- The Dehydrated package has been removed
- Inspec is no longer used due to Chef's bait-and-switch to commercial licensing

### Improvements

- Environment variables SP_HOST, SP_URL and SP_ID are available, by default set to the 
  defaults used in the Shibboleth SP config files
- A keygen.sh script has been added to /etc/rasp, it will generate separate encryption
  and signing keypairs based on environment variables.
- The keygen.sh script will run immediately when sub-images are built
- Container images are built for both x86 and ARM64 platforms 
- Container images will be available on both Dockerhub and Github.

### Fixes

- The Shibd process now logs to STDOUT, like Apache
- The preparation script has been moved into the Dockerfile to improve build reliability

### Known Issues

- Most tests do not run, as only a few have been converted to Serverspec from Inspec so far.

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
