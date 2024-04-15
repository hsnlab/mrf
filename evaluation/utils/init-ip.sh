#!/bin/bash
set -x

MEASDEV="enp7s0"
TESTERMAC="3c:fd:fe:ba:19:00"

modprobe nf_tables
sysctl -w net.ipv4.ip_forward=1

dhclient enp1s0

ip addr add 10.0.1.4/24 dev $MEASDEV
ip link set dev $MEASDEV up

ip n add 10.0.1.2 dev $MEASDEV lladdr $TESTERMAC nud permanent

ethtool --config-nfc $MEASDEV rx-flow-hash udp4 sdfn
ethtool --config-nfc $MEASDEV rx-flow-hash tcp4 sdfn
