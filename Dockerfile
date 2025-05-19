# Use ubuntu 25.10 as base image
FROM ubuntu:25.10

RUN apt update && apt install -y isc-dhcp-server tcpdump

COPY ["./dhcpd.conf", "/etc/dhcp/dhcpd.conf"]

CMD ["dhcpd", "-f", "-d", "-cf", "/etc/dhcp/dhcpd.conf", "eth0"]

