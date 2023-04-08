#!/bin/bash

# Update package manager
apt-get update

# Install dependencies for Automated Penetration Testing script
apt-get install -y nmap metasploit-framework nikto

# Install dependencies for Automated Enumeration script
apt-get install -y nmap dirb dnsenum enum4linux nikto smbclient sslscan wpscan

# Install dependencies for SSH, FTP, HTTPS securing scripts
apt-get install -y iptables fail2ban

# Install dependencies for Kernel Hardening script
apt-get install -y grsecurity-appguard kernel-package libssl-dev

# Install dependencies for Nessus vulnerability scanning script
apt-get install -y wget bzip2

# Download and install Nessus
cd /tmp
wget https://www.tenable.com/downloads/api/v1/public/pages/nessus/downloads/12608/download?i_agree_to_tenable_license_agreement=true
mv download\?i_agree_to_tenable_license_agreement\=true nessus.deb
dpkg -i nessus.deb
