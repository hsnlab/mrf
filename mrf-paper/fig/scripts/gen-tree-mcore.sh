#!/bin/bash

MAX_K=64
#N=1
M=500

SRC=uniform

LB=roundrobin

DS=wsplay
N=400000
echo -- $DS/$SRC: m=$M n=$N l=$LB 
for ((i=${MAX_K}; i>=1; i--)); do
    ./cmtf -m $M -n $N -d $DS -s $SRC -l $LB -k $i
done

DS=wbtree
N=200000
echo -- $DS/$SRC: m=$M n=$N l=$LB 
for ((i=${MAX_K}; i>=1; i--)); do
    ./cmtf -m $M -n $N -d $DS -s $SRC -l $LB -k $i
done

LB=modulo

DS=wsplay
N=2000000
echo -- $DS/$SRC: m=$M n=$N l=$LB 
for ((i=${MAX_K}; i>=1; i--)); do
    ./cmtf -m $M -n $N -d $DS -s $SRC -l $LB -k $i
done

DS=wbtree
N=200000
echo -- $DS/$SRC: m=$M n=$N l=$LB 
for ((i=${MAX_K}; i>=1; i--)); do
    ./cmtf -m $M -n $N -d $DS -s $SRC -l $LB -k $i
done

# #####################
# SRC=zipf:1.01
# M=250

# LB=roundrobin

# DS=wsplay
# N=100000
# echo -- $DS/$SRC: m=$M n=$N l=$LB 
# for ((i=${MAX_K}; i>=1; i--)); do
#     ./cmtf -m $M -n $N -d $DS -s $SRC -l $LB -k $i
# done

# DS=wbtree
# N=100000
# echo -- $DS/$SRC: m=$M n=$N l=$LB 
# for ((i=${MAX_K}; i>=1; i--)); do
#     ./cmtf -m $M -n $N -d $DS -s $SRC -l $LB -k $i
# done

# LB=modulo

# DS=wsplay
# N=100000
# echo -- $DS/$SRC: m=$M n=$N l=$LB 
# for ((i=${MAX_K}; i>=1; i--)); do
#     ./cmtf -m $M -n $N -d $DS -s $SRC -l $LB -k $i
# done

# DS=wbtree
# N=100000
# echo -- $DS/$SRC: m=$M n=$N l=$LB 
# for ((i=${MAX_K}; i>=1; i--)); do
#     ./cmtf -m $M -n $N -d $DS -s $SRC -l $LB -k $i
# done
