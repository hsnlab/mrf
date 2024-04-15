#!/bin/bash
#set -x

MRF_ENABLE=${MRFENABLE:-"0"}
NFT_RULES_FILE=${NFTRULESFILE:-$1}

echo $MRF_ENABLE > /sys/kernel/mrf_nft_config/mrf_enable

nft flush ruleset
nft -f $NFT_RULES_FILE
