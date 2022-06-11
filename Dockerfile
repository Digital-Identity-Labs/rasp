FROM bitnami/minideb:latest

LABEL description="A simple, unconfigured Apache reverse proxy service including the Shibboleth SP module" \
      maintainer="pete@digitalidentitylabs.com" \
      org.opencontainers.image.source="https://github.com/Digital-Identity-Labs/rasp"

ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
ARG DEBIAN_FRONTEND="noninteractive"

ENV SP_HOST="sp.example.org"
ENV SP_URL="https://$SP_HOST"
ENV SP_ID="$SP_URL/shibboleth"
ENV SP_CERT_DIRS="/etc/shibboleth" \
    APACHE_EXTRA_MODS=""

WORKDIR /app

RUN install_packages curl runit apache2 openssl ca-certificates \
    libapache2-mod-shib2 libapache2-mod-auth-openidc libapache2-mod-auth-cas && \
    mkdir -p /run/shibboleth && chmod 0755 /run/shibboleth && chown _shibd /run/shibboleth && \
    mkdir -p /var/shibboleth && chmod 0755 /run/shibboleth && chown _shibd /run/shibboleth && \
    mkdir -p /etc/scripts

COPY etcfs /etc

RUN chmod a+x /etc/service/**/run && touch /etc/inittab && \
    cp -a /etc/shibboleth /etc/shibboleth.dist && \
    mkdir -p /var/run/apache2 && chown www-data /var/run/apache2 && \
    mkdir -p /var/run/shibboleth && \
    mkdir -p /etc/shibboleth/metadata/override && \
    mkdir -p /etc/shibboleth/metadata/local && \
    mkdir -p /etc/shibboleth/metadata/federated && \
    mkdir -p /etc/shibboleth/metadata/bilateral && \
    mkdir -p /etc/shibboleth/credentials && \
    chown _shibd:_shibd /var/run/shibboleth /var/log/shibboleth && \
    chmod a+x /etc/rasp/*.sh && \
    /etc/rasp/keygen.sh && \
    chown   root:_shibd /etc/shibboleth/*-key.pem && chmod g+r,o-r /etc/shibboleth/*-key.pem && \
    chown _shibd:_shibd /etc/shibboleth/metadata/federated && \
    a2enmod shib ssl http2 rewrite proxy proxy_balancer proxy_ajp proxy_http proxy_http2 \
            headers expires deflate status && \
    a2dismod cgi cgid auth_openidc auth_cas && \
    a2enconf defaults deversion security pterry tuning zz_overrides && \
    ln -sf /proc/self/fd/1 /var/log/apache2/access.log && \
    ln -sf /proc/self/fd/1 /var/log/apache2/error.log  && \
    ln -sf /proc/self/fd/1 /var/log/apache2/other_vhosts_access.log && \
    ln -sf /proc/self/fd/1 /var/log/shibboleth/shibd.log && \
    ln -sf /proc/self/fd/1 /var/log/shibboleth/shibd_warn.log && \
    ln -sf /proc/self/fd/1 /var/log/shibboleth/signature.log && \
    ln -sf /proc/self/fd/1 /var/log/shibboleth/transaction.log && \
    export > /etc/envvars

EXPOSE 80 8080 443 8443 9443
STOPSIGNAL HUP
ENTRYPOINT ["/etc/rasp/bootstrap_runit.sh"]

ONBUILD RUN /etc/rasp/keygen.sh

HEALTHCHECK --interval=30s --timeout=3s CMD curl -f http://127.0.0.1:80/server-status || exit 1






