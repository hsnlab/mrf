#!/usr/bin/env bash
set -x


VM_IP=${VMIP:-"192.168.122.74"}
MRF_ENABLE=${MRFENABLE:-"0"}
NFT_RULES_FILE=${NFTRULESFILE:-""}
NUM_CORES=${CORES:-"1"}
MEAS_DEV=${MEASDEV:-"enp7s0np0"}
RX_FLOW_HASH=${RXFLOWHASH:-"sdfn"}

ssh root@$VM_IP "bash -s" <<EOF
export MRFENABLE=$MRF_ENABLE
export NFTRULESFILE=$NFT_RULES_FILE
/root/nft-file.sh
ethtool -L $MEAS_DEV combined $NUM_CORES
ethtool --config-nfc $MEAS_DEV rx-flow-hash udp4 $RX_FLOW_HASH
ethtool --config-nfc $MEAS_DEV rx-flow-hash tcp4 $RX_FLOW_HASH
EOF
