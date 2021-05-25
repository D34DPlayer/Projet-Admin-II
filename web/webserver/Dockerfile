FROM php:apache

LABEL version="1.3"
LABEL description="Serveur web."

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions zip mysqli

COPY ./apache2/ /etc/apache2/

COPY ./b2b/ /var/www/html/b2b/
RUN chmod go-w /var/www/html/b2b/config.inc.php

COPY ./vitrine/ /var/www/html/vitrine/

COPY ./interne/ /var/www/html/interne/
RUN chmod go-w /var/www/html/interne/config.inc.php

RUN a2enmod ssl rewrite && \
    a2dissite 000-default && \
    a2ensite vitrine b2b interne

RUN chown -R www-data:www-data /var/www/html

COPY ./health.sh .

HEALTHCHECK --interval=5s --timeout=3s --start-period=5s CMD bash health.sh
