#!/bin/bash

# Script to enumerate ports, sub-domains, web directories, FTP/SSH shares, versions and CVEs

# Usage: ./enum.sh <target IP> <output directory>

# Check if target IP and output directory were provided
if [ $# -ne 2 ]; then
    echo "Usage: $0 <target IP> <output directory>"
    exit 1
fi

# Target IP address
target=$1

# Output directory
outdir=$2

# Create output directory if it does not exist
if [ ! -d "$outdir" ]; then
    mkdir -p $outdir
fi

# Nmap scan
echo "Running Nmap scan..."
nmap -sS -sV -p- -oA $outdir/nmap $target

# Sub-domain enumeration
echo "Running sub-domain enumeration..."
sublist3r -d $target -o $outdir/subdomains.txt

# Web directory enumeration
echo "Running web directory enumeration..."
gobuster dir -u http://$target -w /usr/share/wordlists/dirb/common.txt -x php,txt -t 20 -o $outdir/gobuster.txt

# FTP/SSH shares enumeration
echo "Running FTP/SSH shares enumeration..."
nmap -p 21,22 -sV -oA $outdir/ftp-ssh $target
ftp-anon $target > $outdir/ftp-anon.txt

# Version checking and CVE scan
echo "Checking versions and scanning for CVEs..."
nmap -sV -p- -oA $outdir/versions $target
nmap -sV --script vulners -oA $outdir/cves $target
