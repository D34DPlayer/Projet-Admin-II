#!/bin/bash

envsubst < /etc/bind/db.template > /etc/bind/db.m1-2.ephec-ti.be
/usr/sbin/named -g -c /etc/bind/named.conf -u bind
