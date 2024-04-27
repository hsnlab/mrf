#!/bin/bash
set -e

if [ $1 == "-h" ]; then
    echo "usage: $0 <NUMRULES> <OUTFILE> <DEPENDENCY_CHAIN_LEN>"
    exit 0
fi

NUMRULES=${1:-"2000"}
OUTFILE=${2:-"/dev/stdout"}
DEPCHAINLEN=${3:-"1"}
BASEPORT=500

prefixes="32"
case $DEPCHAINLEN in
    2)
	prefixes="32 0"
	;;
    5)
	prefixes="32 24 16 8 0"
	;;
    9)
	prefixes="32 28 24 20 16 12 8 4 0"
	;;
    *)
	echo "DEPENDENCY_CHAIN_LEN not set, fallback to 1"
	;;
esac

echo "add table test" > $OUTFILE
echo "add chain test test_chain { type filter hook forward priority 0; }" >> $OUTFILE

for i in $(seq $BASEPORT $(expr $(expr $BASEPORT - 1) + $NUMRULES)); do
     for n in $prefixes; do
	echo "add rule test test_chain ip daddr 1.2.3.4/$n udp dport $i counter accept" >> $OUTFILE
    done
done

# echo "add rule ip test testchain counter accept" >> $OUTFILE
