#!/usr/bin/env bash
set -x


VM_IP=${VMIP:-"192.168.122.74"}
MRF_ENABLE=${MRFENABLE:-"0"}
NFT_RULES_FILE=${NFTRULESFILE:-""}
NUM_CORES=${CORES:-"1"}

ssh root@$VM_IP "bash -s" <<EOF
export MRFENABLE=$MRF_ENABLE
export NFTRULESFILE=$NFT_RULES_FILE
/root/nft-file.sh
ethtool -L enp7s0 combined $NUM_CORES
EOF
