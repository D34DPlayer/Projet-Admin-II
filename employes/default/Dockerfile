FROM ubuntu:focal

LABEL version="1.1"
LABEL description="Environnement utilisateur minimal."

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update

# DNS queries, browser, mail client, voip client, vpn client and CA validation
RUN apt install -y dnsutils lynx mutt twinkle-console openvpn inetutils-* ca-certificates && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean
# Cleans the cache to reduce the image size

CMD ["bash"]
