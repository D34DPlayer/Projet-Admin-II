FROM alpine:latest

LABEL version="1.0"
LABEL description="Serveur VPN."

RUN echo "http://dl-cdn.alpinelinux.org/alpine/edge/testing/" >> /etc/apk/repositories && \
    apk add --update openvpn iptables bash easy-rsa && \
    ln -s /usr/share/easy-rsa/easyrsa /usr/local/bin && \
    rm -rf /tmp/* /var/tmp/* /var/cache/apk/* /var/cache/distfiles/*

ENV OPENVPN=/etc/openvpn
ENV EASYRSA=/usr/share/easy-rsa \
    EASYRSA_CRL_DAYS=3650 \
    EASYRSA_PKI=$OPENVPN/certs/pki

EXPOSE 1194/udp

COPY ./bin /usr/local/bin
RUN chmod +x /usr/local/bin/*

COPY ./conf /etc/openvpn

CMD ["ovpn_run"]
