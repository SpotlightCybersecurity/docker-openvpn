FROM alpine
MAINTAINER Ryan <ryan@spotlightcybersecurity.com>

RUN apk --no-cache add openvpn runit
COPY docker_start.sh /docker_start.sh
CMD ["/docker_start.sh"]
