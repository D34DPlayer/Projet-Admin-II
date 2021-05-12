#!/bin/bash

for template in $(find /etc/bind/ -name "*.template"); do
    file=${template%.*}
    DOLLAR="\$" envsubst < $template > $file
    echo ================================
    echo $file
    echo ================================
done

/usr/sbin/named -g -c /etc/bind/named.conf -u bind
