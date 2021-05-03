include .env

compose_file ?= "docker-compose.yml"
project ?= "admin"
user ?= `whoami`

DC = docker-compose -p $(project) -f $(compose_file)

create-cert = docker run --name clientcerts --rm \
	-v "`pwd`/certs":/certs \
    -e CA_KEY=ca.key \
    -e CA_CERT=ca.crt \
    -e CA_EXPIRE=365 \
    -e SSL_EXPIRE=365
    

define HELP
Utilitaire docker-compose

Commandes:
----------
    build       - Build le docker-compose.
    help        - Affiche l'aide.
	proto-setup - Setup les certificats et les attribue aux containers.
    restart     - Redémarre les containers.
    start       - Démarre les containers. Alias: up
    stop        - Arrête les containers. Alias: down
endef
export HELP

help:
	@echo "$$HELP"

build:
	@cd employes/default && \
	docker -t d34d/projet-admin:employes-default .
	$(DC) build

start up:
	$(DC) up -d

stop down:
	$(DC) down

restart:
	$(DC) restart

proto-setup:
	[ -d certs ] || mkdir certs
	$(create-cert) \
		-e SSL_KEY=apache.key \
		-e SSL_CERT=apache.crt \
		-e SSL_CSR=apache.csr \
		-e SSL_SUBJECT=www.local \
		paulczar/omgwtfssl
	$(create-cert) \
		-e SSL_KEY=client.key \
		-e SSL_CERT=client.crt \
		-e SSL_CSR=client.csr \
		-e "SSL_SUBJECT=DB Client" \
		paulczar/omgwtfssl
	$(create-cert) \
		-e SSL_KEY=db.key \
		-e SSL_CERT=db.crt \
		-e SSL_CSR=db.csr \
		-e SSL_SUBJECT=192.168.1.2 \
		paulczar/omgwtfssl

	sudo chown -R $(user):$(user) ./certs
	# GIVE EVERYONE THEIR CERTS

	$(DC) run --name ws -d web-server sh
	$(DC) run --name db -d web-db sh

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


	# CREATE PKI VPN

	$(DC) run vpn-server ovpn_initpki


	# LAUNCH ALL THE SERVICES

	$(DC) down
	$(DC) up -d

	# TRUST CA IN SIMUL

	docker cp ./certs/ca.crt admin_simul-commercial_1:/usr/local/share/ca-certificates/
	docker exec admin_simul-commercial_1 update-ca-certificates
