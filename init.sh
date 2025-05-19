#!/bin/env sh

if [ "$1" == "-h" ]; then
  echo "Usage: `basename $0`"
  echo "IAFM. Read the README."
  exit 0
fi

if [ -f "./dhcpd.conf" ]; then
    echo "dhcpd.conf already exists, skipping configuration."
else
    if [ -f "./.env" ]; then
        source ./.env
    fi

    # Listening IP info
    : ${SN1:='10.1.1.0'}
    : ${NM1:='255.255.255.0'}

    # Empty definition for subnet
    : ${SN2:='192.168.0.0'}
    : ${NM2:='255.255.0.0'}

    # IP Lease range
    : ${LEASE_RANGE_START:='10.1.1.3'}
    : ${LEASE_RANGE_END:='10.1.1.254'}

    # Lease time
    : ${DEFAULT_LEASE_TIME:='600'}
    : ${MAX_LEASE_TIME:='7200'}

    # DNS Server
    : ${DOMAIN_NAME_SERVERS:='8.8.8.8'} # google DNS

    # Default gateway
    : ${DEFAULT_GATEWAY:='10.1.1.1'}

    # Write to dhcpd.conf
    touch dhcpd.conf

    echo "default-lease-time $DEFAULT_LEASE_TIME;" >> dhcpd.conf
    echo "max-lease-time $MAX_LEASE_TIME;" >> dhcpd.conf
    echo "" >> dhcpd.conf

    echo "subnet $SN1 netmask $NM1 {" >> dhcpd.conf
    echo "  range $LEASE_RANGE_START $LEASE_RANGE_END;" >> dhcpd.conf
    echo "  option domain-name-servers $DOMAIN_NAME_SERVERS;" >> dhcpd.conf
    echo "  option routers $DEFAULT_GATEWAY;" >> dhcpd.conf
    echo "}" >> dhcpd.conf
    echo "" >> dhcpd.conf

    echo "subnet $SN2 netmask $NM2 {" >> dhcpd.conf
    echo "}" >> dhcpd.conf
    echo "" >> dhcpd.conf

    #echo "subnet $SN1 netmask $NM1 {" >> dhcpd.conf
    #echo "  range $LEASE_RANGE_START $LEASE_RANGE_END;" >> dhcpd.conf
    #echo "  option routers $DEFAULT_GATEWAY;" >> dhcpd.conf
    #echo "}" >> dhcpd.conf
    #echo "" >> dhcpd.conf

fi

docker build --tag "dhcp" .
docker run --detach "dhcp"

