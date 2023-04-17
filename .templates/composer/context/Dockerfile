FROM alpine:edge

##################################
# ARG to EV
ARG RUN_UID
ARG RUN_GID
ARG RUN_USER
ARG RUN_GROUP

ENV RUN_UID=$RUN_UID
ENV RUN_GID=$RUN_GID
ENV RUN_USER=$RUN_USER
ENV RUN_GROUP=$RUN_GROUP

##################################
# essentials
RUN apk     --no-cache upgrade
RUN apk     --no-cache update
RUN apk add --no-cache shadow vim sudo bash \
                       openvpn openvpn-doc easy-rsa iptables
##################################
# configurations

RUN adduser -D -u ${RUN_UID} -s /bin/bash -G wheel ${RUN_USER}

RUN  mkdir /etc/openvpn/server
COPY startvpn.sh  /usr/local/bin/startvpn.sh
COPY genclient.sh /usr/local/bin/genclient.sh
RUN  chmod +x    /usr/local/bin/startvpn.sh
RUN  chmod +x    /usr/local/bin/genclient.sh

ENTRYPOINT ["/usr/local/bin/startvpn.sh"]
