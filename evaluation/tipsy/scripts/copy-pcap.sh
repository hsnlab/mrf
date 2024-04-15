#!/usr/bin/env bash
# Copy PCAP to measurement directory and rewrite destination MAC addresses
set -x

PCAP_FILE=`jq .sut.environ.PCAPFILE benchmark.json`
MAC_ADDR=`jq .sut.environ.TESTERMAC benchmark.json`

cp $PCAP_FILE /tmp/tmp.pcap
tcprewrite --enet-dmac=$MAC_ADDR -i /tmp/tmp.pcap -o traffic.pcap
rm /tmp/tmp.pcap
