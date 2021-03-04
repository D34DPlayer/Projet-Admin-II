FROM php:apache

LABEL version="1.0"
LABEL description="Serveur web dynamique."

ADD https://github.com/mlocati/docker-php-extension-installer/releases/latest/download/install-php-extensions /usr/local/bin/

RUN chmod +x /usr/local/bin/install-php-extensions && sync && \
    install-php-extensions zip mysqli

COPY ./html/ /var/www/html/
