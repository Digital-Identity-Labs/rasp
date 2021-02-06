FROM bitnami/minideb:latest

LABEL description="A simple, unconfigured Apache 2.4 proxy service including the Shibboleth SP module (SWITCH edition)" \
      version="0.2.0" \
      maintainer="pete@digitalidentitylabs.com"

ARG SRC_DIR=/usr/local/src
ARG SWITCH_KEY_FP=26C3C46915B76742

WORKDIR $SRC_DIR

RUN echo "\n## Preparing OS..." && \
    install_packages curl runit apache2 openssl ca-certificates gnupg dirmngr procps net-tools && \
    echo "\n## Installing SWITCH Shibboleth SP packages..." && \
    curl -O http://pkg.switch.ch/switchaai/SWITCHaai-swdistrib.asc && \
    gpg -v --with-fingerprint SWITCHaai-swdistrib.asc | grep $SWITCH_KEY_FP && \
    apt-key add SWITCHaai-swdistrib.asc && \
    echo 'deb http://pkg.switch.ch/switchaai/debian buster main' | tee /etc/apt/sources.list.d/SWITCHaai-swdistrib.list > /dev/null && \
    install_packages shibboleth libapache2-mod-shib2 dehydrated && \
    mkdir -p /run/shibboleth && chmod 0755 /run/shibboleth && chown _shibd /run/shibboleth && \
    mkdir -p /var/shibboleth && chmod 0755 /run/shibboleth && chown _shibd /run/shibboleth && \
    echo "\n## Tidying up..." && \
    rm -rf $SRC_DIR/* && \
    apt-get remove --auto-remove --yes --allow-remove-essential gnupg dirmngr

COPY etcfs /etc

RUN mv /etc/admin /opt/admin && chmod a+x /opt/admin/*.sh && sync && /opt/admin/prepare_apps.sh && export > /etc/envvars

EXPOSE 80 8080 443 8443 9443
STOPSIGNAL HUP
ENTRYPOINT ["/opt/admin/bootstrap_runit.sh"]

HEALTHCHECK --interval=30s --timeout=1s CMD curl -f http://localhost/server-status || exit 1






