curl http://web-vitrine 2>/dev/null | grep "<h1>Index</h1>" > /dev/null

if [ ! $? -eq 0 ]; then
    exit 1
fi

curl http://web-b2b 2>/dev/null | grep "<body id=loginform>" > /dev/null

if [ ! $? -eq 0 ]; then
    exit 1
fi
