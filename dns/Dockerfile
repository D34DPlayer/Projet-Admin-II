FROM internetsystemsconsortium/bind9:9.16

COPY db.local /etc/bind/
COPY named.conf /etc/bind/named.conf.template
COPY db.m1-2.ephec-ti.be /etc/bind/db.template

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
RUN apt-get update && apt-get -y install dnsutils gettext-base

ENV DOMAIN_NAME "m1-2.ephec-ti.be"
ENTRYPOINT ["/entrypoint.sh"]
HEALTHCHECK --interval=5s --timeout=3s --start-period=5s CMD dig @127.0.0.1 cloudflare.com || exit 1
