#!/usr/bin/env bash

## Fail unless all env variables are set
set -u

## Carry out all steps as one command, to return a failure code if something goes wrong
chmod a+x /etc/service/**/run && touch /etc/inittab && \
mkdir -p /var/run/apache2 && chown www-data /var/run/apache2 && \
mkdir -p /var/run/shibboleth && touch /etc/shibboleth/sp-key.pem && \
chown _shibd:_shibd /var/run/shibboleth /var/log/shibboleth /etc/shibboleth/sp-key.pem && \
a2enmod  shib ssl http2 rewrite proxy proxy_balancer proxy_ajp proxy_http proxy_http2 \
         headers expires deflate status && \
a2dismod cgi cgid
a2enconf defaults deversion security pterry tuning zz_overrides && \
ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
ln -sf /proc/self/fd/1 /var/log/apache2/error.log  && \
ln -sf /proc/self/fd/1 /var/log/apache2/other_vhosts_access.log && \
sync
