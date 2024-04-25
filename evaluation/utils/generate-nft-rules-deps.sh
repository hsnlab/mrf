#!/bin/bash
set -e

if [ $1 == "-h" ]; then
    echo "usage: $0 <NUMRULES> <OUTFILE>"
    exit 0
fi

NUMRULES=${1:-"2000"}
OUTFILE=${2:-"/dev/stdout"}
BASEPORT=500

echo "add table test" > $OUTFILE
echo "add chain test test_chain { type filter hook forward priority 0; }" >> $OUTFILE

for i in $(seq $BASEPORT $(expr $(expr $BASEPORT - 1) + $NUMRULES)); do
    # for n in 32 28 24 20 16 12 8 4 0; do
    # for n in 32 24 16 8 0; do
    # for n in 32 0; do
    # for n in 32; do
	echo "add rule test test_chain ip daddr 1.2.3.4/$n udp dport $i counter accept" >> $OUTFILE
    done
done

# echo "add rule ip test testchain counter accept" >> $OUTFILE
