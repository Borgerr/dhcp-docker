# Dockerized DHCP

I couldn't find an easily deployable DHCP server for Linux hosts, so here we are.
This mainly has the goal of hosting a DHCP server on your dev machine when need be
for the sake of testing with other devices.

Really the only requirements are a typical Docker environment on any Linux host machine.
If this isn't the case, please either make a detailed issue or a PR.
I might've done something silly.

At the moment, this does NOT include a DNS server.
**You very likely should be setting this yourself**.
Otherwise, the default is set to Google's DNS server, `8.8.8.8`.
Some future release or adjacent repository may include a DNS server in a docker network.

The included initialization script [`init.sh`](<./init.sh>) also does not support
multiple subnets.
This is mostly because I don't currently see a reason why a dev machine should
need to do that, but if I end up seeing cases where that's necessary,
I may add that feature.

## Deploying

`./init.sh` initializes the DHCP server with the following overwritable variables:

- `SN1`: subnet 1, subnet server listens on (default `10.1.1.0`)
- `NM1`: netmask 1, netmask for SN1 (default `255.255.255.0`)
- `SN2`: subnet 2, empty definition for subnet with network ID (default `192.168.0.0`)
- `NM2`: netmask 2, netmask for SN2 (default `255.255.0.0`)
- `LEASE_RANGE_START`: Start of IPs leased, inclusive (default `10.1.1.3`)
- `LEASE_RANGE_END`: End of IPs leased, inclusive (default `10.1.1.254`)
- `DEFAULT_LEASE_TIME`: Time (in seconds) in which a leased IP address will expire, pending any requests from the client (default `600`)
- `MAX_LEASE_TIME`: Maximum time (in seconds) that an IP address can be leased (default `7200`)
- `DOMAIN_NAME_SERVERS`: IP address of DNS server (default `8.8.8.8`)
- `INTERNAL_DNS`: IP address of DNS server behind NAT (default `10.1.1.1`)
- `DEFAULT_GATEWAY`: Default IP address of Gateway (default `10.1.1.1`)

All of the above variables are overwritable with a `.env` file,
or by specifying on the CLI, e.g. `DEFAULT_LEASE_TIME=999 ./init.sh`.
You can also of course write a `dhcpd.conf` file in this directory
and that will be copied over to the container.

