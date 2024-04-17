#!/usr/bin/env python3
""" PCAP traffic generator script """


import argparse

import numpy as np
from scapy.all import *


def generate_pkt(udp_dport=500, ip_dst="1.2.3.4", packet_len=100) -> Packet:
    """ Generate a single packet """
    base_pkt = Ether(dst="68:05:ca:30:45:d8")/IP(src="10.0.1.2", dst=ip_dst)
    base_pkt_len = len(base_pkt)
    pkt = base_pkt/UDP(sport=12345, dport=udp_dport)
    pkt /= 'x' * max(0, packet_len - base_pkt_len - 8)
    return pkt


def generate_pkt_index_table(distribution: str, num_pkts: int, num_flows: int,
                             zipf_param=4.0) -> list:
    """Generate packet index table, which can be used to shuffle a
    list of packets following a given distribution.

    Raises error when distribution not supported.
    """
    if distribution == 'zipf':
        distrib = np.random.default_rng().zipf(zipf_param, num_pkts)
    elif distribution == 'uniform':
        distrib = np.random.uniform(0.0, 1.0, num_pkts)
    else:
        raise ValueError("invalid distribution")

    return [int(i) for i in (distrib/float(max(distrib)))*(num_flows-1)]


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--distribution', '-d', type=str, default='uniform',
                        choices=['uniform', 'zipf'],
                        help='Packet distribution.')
    parser.add_argument('--zipf', '-z', type=float, default=4.0,
                        help='Number of packets to generate')
    parser.add_argument('--numpkts', '-n', type=int,
                        help='Number of packets to generate')
    parser.add_argument('--maxport', '-m', type=int,
                        help='Max UDP destinaton port.')
    parser.add_argument('--catch-all', '-c', type=bool,
                        help='Add an extra packet (maxport+1) that can match catch-all rules')
    parser.add_argument('--baseport', '-b', type=int, default=500,
                        help='Base UDP dport. '
                        'Packets will have udp dport in range of '
                        '[baseport:maxport]')
    parser.add_argument('--outfile', '-o', type=str,
                        help='Output PCAP file')
    args = parser.parse_args()
    baseport = args.baseport
    maxport = args.maxport
    num_flows = maxport - baseport
    if num_flows < 0:
        raise ValueError("maxport < baseport, exiting")

    # generate packets
    pkts_base = []
    dport = baseport
    for _ in range(num_flows):
        pkts_base.append(generate_pkt(udp_dport=dport))
        dport += 1
        if dport > maxport:
            dport = baseport

    pkt_idxs = generate_pkt_index_table(args.distribution,
                                        args.numpkts,
                                        num_flows,
                                        args.zipf)

    pkts = [pkts_base[i] for i in pkt_idxs]

    if args.catch_all:
        # add a single packet that matches to the catch-all rule only
        pkts.append(generate_pkt(udp_dport=(maxport + 1) % 65535))

    # write packets to pcap
    wrpcap(args.outfile, pkts)
