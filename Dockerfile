FROM bitnami/minideb:latest

LABEL description="A simple, unconfigured Apache 2.4 proxy service including the Shibboleth SP module" \
      version="0.3.0" \
      maintainer="pete@digitalidentitylabs.com"

ARG APT_KEY_DONT_WARN_ON_DANGEROUS_USAGE=1
ARG DEBIAN_FRONTEND="noninteractive"

WORKDIR /app

RUN install_packages curl runit apache2 openssl ca-certificates procps net-tools \
                      libapache2-mod-shib2  && \
    mkdir -p /run/shibboleth && chmod 0755 /run/shibboleth && chown _shibd /run/shibboleth && \
    mkdir -p /var/shibboleth && chmod 0755 /run/shibboleth && chown _shibd /run/shibboleth && \
    mkdir -p /etc/scripts

COPY etcfs /etc

RUN mv /etc/admin /opt/admin && chmod a+x /opt/admin/*.sh && sync && /opt/admin/prepare_apps.sh && export > /etc/envvars

EXPOSE 80 8080 443 8443 9443
STOPSIGNAL HUP
ENTRYPOINT ["/opt/admin/bootstrap_runit.sh"]

HEALTHCHECK --interval=30s --timeout=1s CMD curl -f http://localhost/server-status || exit 1






