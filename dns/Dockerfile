FROM internetsystemsconsortium/bind9:9.16

COPY db.local /etc/bind/
COPY named.conf /etc/bind/named.conf.template
COPY db.m1-2.ephec-ti.be /etc/bind/db.template

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
RUN apt-get install gettext-base

ENV DOMAIN_NAME "m1-2.ephec-ti.be"
ENTRYPOINT ["/entrypoint.sh"]
