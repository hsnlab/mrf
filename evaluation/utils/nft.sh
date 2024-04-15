#!/bin/bash
#set -x

NUM_RULES=1999

echo 0 > /sys/kernel/mrf_nft_config/mrf_enable

nft flush ruleset

nft add table test
nft add chain test test_chain \{ type filter hook forward priority 0\; \}

for i in $(seq 5000 $(expr 4999 + $NUM_RULES)); do
    nft add rule test test_chain udp dport $i accept
done

nft list ruleset
