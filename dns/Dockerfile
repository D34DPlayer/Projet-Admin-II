FROM internetsystemsconsortium/bind9:9.16

COPY named.conf /etc/bind/
COPY db.local /etc/bind/
COPY db.m1-2.ephec-ti.be /etc/bind/db.template

COPY entrypoint.sh /
RUN chmod +x /entrypoint.sh
RUN apt-get install gettext-base

ENV DOMAIN_NAME "m1-2.ephec-ti.be"
ENTRYPOINT ["/entrypoint.sh"]
