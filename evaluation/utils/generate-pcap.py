#!/usr/bin/env python3
""" PCAP traffic generator script """


import argparse

from scapy.all import *


def generate_pkt(udp_dport=5000, ip_dst="1.2.3.4", packet_len=100):
    """ Generate a single packet """
    base_pkt = Ether(dst="68:05:ca:30:45:d8")/IP(src="10.0.1.2", dst=ip_dst)
    base_pkt_len = len(base_pkt)
    pkt = base_pkt/UDP(sport=12345, dport=udp_dport)
    pkt /= 'x' * max(0, packet_len - base_pkt_len - 8)
    return pkt


if __name__ == "__main__":
    parser = argparse.ArgumentParser()
    parser.add_argument('--distribution', '-d', type=str, default='uniform',
                        help='Packet distribution. Supported: uniform')
    parser.add_argument('--numpkts', '-n', type=int,
                        help='Number of packets to generate')
    parser.add_argument('--maxport', '-m', type=int,
                        help='High UDP dport. (useful to control flow size)')
    parser.add_argument('--baseport', '-b', type=int,
                        help='Base UDP dport. '
                        'Packets will have udp dport in range of '
                        '[baseport:baseport+num_flows]')
    parser.add_argument('--outfile', '-o', type=str,
                        help='Output PCAP file')
    args = parser.parse_args()

    # generate packets
    pkts = []
    dport = args.baseport
    for _ in range(args.numpkts):
        pkts.append(generate_pkt(udp_dport=dport))
        dport += 1
        if dport >= args.maxport:
            dport = args.baseport

    # write packets to pcap
    wrpcap(args.outfile, pkts)
