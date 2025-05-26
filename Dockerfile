# Use ubuntu 25.10 as base image
FROM ubuntu:25.10

RUN apt update && apt install -y isc-dhcp-server tcpdump

COPY ["./dhcpd.conf", "/etc/dhcp/dhcpd.conf"]

# lease database just needs to exist
RUN touch /var/lib/dhcp/dhcpd.leases && chmod 777 /var/lib/dhcp

# ./init.sh should also have this set to eth0,
# but people take things out of context all the time.
ARG INTERFACE=eth0

RUN mkdir -p /etc/network && \
    echo "auto $INTERFACE" >> /etc/network/interfaces

RUN mkdir -p /etc/default/ && \
    echo "INTERFACES=$INTERFACE" >> /etc/default/isc-dhcp-server

CMD ["dhcpd", "-f", "-d", "-cf", "/etc/dhcp/dhcpd.conf", "eth0"]

