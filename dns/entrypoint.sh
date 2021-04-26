#!/bin/bash

envsubst < /etc/bind/db.template > /etc/bind/db.m1-2.ephec-ti.be
envsubst < /etc/bind/named.conf.template > /etc/bind/named.conf
/usr/sbin/named -g -c /etc/bind/named.conf -u bind
