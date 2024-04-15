#!/usr/bin/env bash

# Copy PCAP to measurement directory and rewrite destination MAC addresses


PCAP_FILE=`jq .sut.environ.PCAPFILE`
MAC_ADDR=`jq .sut.environ.TESTERMAC`

cp $PCAP_FILE /tmp/tmp.pcap
tcprewrite --enet-dmac=$MAC_ADDR -i /tmp/tmp.pcap -o traffic.pcap
rm /tmp/tmp.pcap
