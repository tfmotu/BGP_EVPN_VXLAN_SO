#!/bin/sh

# Create the bond interface
ip link add bond0 type bond

# Set the bonding mode to 802.3ad (LACP)
ip link set bond0 type bond mode 802.3ad lacp_rate fast

# Add the slave interfaces to the bond
ip link set eth1 down
ip link set eth2 down
ip link set eth1 master bond0
ip link set eth2 master bond0
ip link set eth1 up
ip link set eth2 up

# Create the VLAN interfaces
ip link add link bond0 name bond0.101 type vlan id 101
ip link add link bond0 name bond0.102 type vlan id 102

# Create the bridges and add the VLAN interfaces to them
ip link add name br101 type bridge
ip link add name br102 type bridge

ip link set dev bond0.101 master br101
ip link set dev bond0.102 master br102

# Add the Ethernet interfaces as slaves to the bridges
ip link set dev eth9 master br101
ip link set dev eth8 master br102

# Configure the IP addresses for the bridges in order to L2 test (no routing services)
ip addr add 10.0.101.201/24 dev br101
ip addr add 10.0.102.201/24 dev br102

# Bring up the interfaces
ip link set br101 up
ip link set br102 up
ip link set bond0 up
ip link set eth9 up
ip link set eth8 up

echo "$(basename "$0") executed"
