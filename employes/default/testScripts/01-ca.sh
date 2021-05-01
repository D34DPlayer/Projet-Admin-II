if [ ! -f ca.lock ]; then
    update-ca-certificates
    touch ca.lock
fi
