FROM ubuntu:focal

LABEL version="1.0"
LABEL description="Environnement utilisateur minimal."

ARG DEBIAN_FRONTEND=noninteractive

RUN apt update

# DNS queries, browser, mail client, voip client and vpn client 
RUN apt install -y dnsutils lynx mutt twinkle-console openvpn && \
    rm -rf /var/lib/apt/lists/* && \
    apt clean
# Cleans the cache to reduce the image size

CMD ["bash"]
