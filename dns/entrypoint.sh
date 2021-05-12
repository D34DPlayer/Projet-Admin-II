#!/bin/bash

for template in $(find /etc/bind/ -name "*.template"); do
    file=${template%.*}
    DOLLAR="\$" envsubst < $template > $file
    printf \n================================
    echo    $file
    printf ================================
    cat $file
done
printf \n================================

/usr/sbin/named -g -c /etc/bind/named.conf -u bind
