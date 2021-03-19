#!/bin/sh

user=$(whoami)

[ -d certs ] || mkdir certs

# SETUP CA
# CREATE CERTS

## WEB-SERVER
docker run --name clientcerts --rm \
    -v "$(pwd)/certs":/certs \
    -e CA_KEY=ca.key \
    -e CA_CERT=ca.crt \
    -e CA_EXPIRE=365 \
    -e SSL_EXPIRE=365 \
    -e SSL_KEY=apache.key \
    -e SSL_CERT=apache.crt \
    -e SSL_CSR=apache.csr \
    -e SSL_SUBJECT=www.local \
    paulczar/omgwtfssl

docker run --name clientcerts --rm \
    -v "$(pwd)/certs":/certs \
    -e CA_KEY=ca.key \
    -e CA_CERT=ca.crt \
    -e CA_EXPIRE=365 \
    -e SSL_EXPIRE=365 \
    -e SSL_KEY=client.key \
    -e SSL_CERT=client.crt \
    -e SSL_CSR=client.csr \
    -e "SSL_SUBJECT=DB Client" \
    paulczar/omgwtfssl

## WEB-DB
docker run --name clientcerts --rm \
    -v "$(pwd)/certs":/certs \
    -e CA_KEY=ca.key \
    -e CA_CERT=ca.crt \
    -e CA_EXPIRE=365 \
    -e SSL_EXPIRE=365 \
    -e SSL_KEY=db.key \
    -e SSL_CERT=db.crt \
    -e SSL_CSR=db.csr \
    -e SSL_SUBJECT=192.168.1.2 \
    paulczar/omgwtfssl

sudo chown -R ${user}:${user} ./certs

# GIVE EVERYONE THEIR CERTS

docker-compose -p admin run --name ws -d web-server sh
docker-compose -p admin run --name db -d web-db sh

## web-server (www.local) -> /etc/apache2/certificate/apache.{crt,key}
docker cp ./certs/apache.crt ws:/etc/apache2/certificate/
docker cp ./certs/apache.key ws:/etc/apache2/certificate/

## web-server (db client) -> /etc/apache2/certificate/client.{crt,key}
docker cp ./certs/client.crt ws:/etc/apache2/certificate/
docker cp ./certs/client.key ws:/etc/apache2/certificate/

## web-db -> /etc/mysql/ssl/db.{crt,key}
docker cp ./certs/db.crt db:/etc/mysql/ssl/
docker cp ./certs/db.key db:/etc/mysql/ssl/

# TRUST CA WHERE NEEDED

## web-server -> /etc/apache2/certificate/ca.crt
docker cp ./certs/ca.crt ws:/etc/apache2/certificate/

## web-db -> /etc/mysql/ssl/ca.crt
docker cp ./certs/ca.crt db:/etc/mysql/ssl/

# FIX CERT PERMS

docker exec ws chown -R www-data:www-data /etc/apache2/certificate
docker exec db chown -R mysql:mysql /etc/mysql/ssl

# LAUNCH ALL THE SERVICES

docker-compose -p admin down
docker-compose -p admin up -d

# TRUST CA IN SIMUL

docker cp ./certs/ca.crt admin_simul-commercial_1:/usr/local/share/ca-certificates/
docker exec admin_simul-commercial_1 update_ca_certificates
