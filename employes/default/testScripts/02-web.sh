curl https://www.local 2>/dev/null | grep "<body id=loginform>" > /dev/null

if [ ! $? -eq 0 ]; then
    echo Site interne non disponible !
fi

curl https://www.${DOMAIN_NAME} 2>/dev/null | grep "<h1>Index</h1>" > /dev/null

if [ ! $? -eq 0 ]; then
    echo Site vitrine non disponible !
fi

curl https://b2b.${DOMAIN_NAME} 2>/dev/null | grep "<body id=loginform>" > /dev/null

if [ ! $? -eq 0 ]; then
    echo Site b2b non disponible !
fi
