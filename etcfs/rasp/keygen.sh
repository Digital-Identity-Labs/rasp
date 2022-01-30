#!/bin/sh

set -o errexit
set -o nounset
set -o noclobber

cd /etc/shibboleth

/usr/sbin/shib-keygen -u _shibd -g _shibd -h $SP_URL -y 10 -e $SP_ID -n sp-encrypt
/usr/sbin/shib-keygen -u _shibd -g _shibd -h $SP_URL -y 10 -e $SP_ID -n sp-signing