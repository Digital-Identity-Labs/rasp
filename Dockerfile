FROM bitnami/minideb:latest

LABEL description="A simple, unconfigured Apache 2.4 proxy service including the Shibboleth SP module (SWITCH edition)" \
      version="0.2.1" \
      maintainer="pete@digitalidentitylabs.com"

ARG SRC_DIR=/usr/local/src
ARG SWITCH_KEY_FP="294E 37D1 5415 6E00 FB96 D7AA 26C3 C469 15B7 6742"
ARG REPODEB_FILE=switchaai-apt-source_1.0.0_all.deb
ARG REPODEB_URL=https://pkg.switch.ch/switchaai/debian/dists/buster/main/binary-all/misc/${REPODEB_FILE}
ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
ARG DEBIAN_FRONTEND="noninteractive"

WORKDIR $SRC_DIR

RUN echo "\n## Preparing OS..." && \
    install_packages curl runit apache2 openssl ca-certificates gnupg dirmngr procps net-tools apt-utils && \
    echo "\n## Adding SWITCH Debian package repository" && \
    curl --fail --remote-name $REPODEB_URL  && \
    apt-get install ./$REPODEB_FILE && \
    apt-key --keyring /usr/share/keyrings/SWITCHaai-swdistrib.gpg list | echo grep '${SWITCH_KEY_FP}' && \
    echo "\n## Installing SWITCH Shibboleth SP packages..." && \
    install_packages shibboleth libapache2-mod-shib2 dehydrated && \
    mkdir -p /run/shibboleth && chmod 0755 /run/shibboleth && chown _shibd /run/shibboleth && \
    mkdir -p /var/shibboleth && chmod 0755 /run/shibboleth && chown _shibd /run/shibboleth && \
    mkdir -p /etc/scripts && \
    echo "\n## Tidying up..." && \
    rm -rf $SRC_DIR/* && \
    apt-get remove --auto-remove --yes --allow-remove-essential gnupg dirmngr apt-utils

COPY etcfs /etc

RUN mv /etc/admin /opt/admin && chmod a+x /opt/admin/*.sh && sync && /opt/admin/prepare_apps.sh && export > /etc/envvars

EXPOSE 80 8080 443 8443 9443
STOPSIGNAL HUP
ENTRYPOINT ["/opt/admin/bootstrap_runit.sh"]

HEALTHCHECK --interval=30s --timeout=1s CMD curl -f http://localhost/server-status || exit 1






