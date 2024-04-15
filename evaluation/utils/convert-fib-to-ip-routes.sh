#!/bin/bash
#set -x

INFILE=$1
OUTFILE=$2
GW=${3:-"10.0.1.2"}

sed_rule="s/([0-9\/\.]+)\t([0-9\.]+)/ip route add \1 via $GW/g"
sed -r "$sed_rule" $INFILE > $OUTFILE

echo "ip route flush 0/0" >> $OUTFILE
echo "ip route add default via $GW" >> $OUTFILE
