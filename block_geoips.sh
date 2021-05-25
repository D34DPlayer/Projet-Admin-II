#!/usr/bin/bash

URL_V4=https://www.ipdeny.com/ipblocks/data/countries/all-zones.tar.gz
URL_V6=https://www.ipdeny.com/ipv6/ipaddresses/blocks/ipv6-all-zones.tar.gz
VAR="\$URL_V"
IP_VERSIONS='4 6'

COUNTRIES='CN RU IN KP VE'

for V in $IP_VERSIONS; do
    url=`eval "echo ${VAR}${V}"`
    folder="/tmp/block_ipv$V/"

    # Create the temporary folder
    mkdir -p $folder

    # Download and extract the block ips
    curl -k $url | tar -xz -C $folder

    # Flush the set
    ipset flush blocklist$V

    # Create the set for each country
    for country in `echo $COUNTRIES | tr [:upper:] [:lower:]`; do
        file="$folder/$country.zone"

        # Check that the file exists
        if [ ! -f $file ]; then
            echo "Country $country doesn't have ipv$V"
            continue;
        fi

        #
        for ipblock in `cat $file`; do
            ipset add blocklist$V $ipblock
        done
    done
done

# Create the lists using:
#     sudo ipset create blocklist4 hash:net family inet
#     sudo ipset create blocklist6 hash:net family inet6
# Then block the sets using iptables
#     sudo iptables -I INPUT -m set --match-set blocklist4 src -j DROP
#     sudo ip6tables -I INPUT -m set --match-set blocklist6 src -j DROP
# Add a cronjob weekly
#     sudo crontab -e
