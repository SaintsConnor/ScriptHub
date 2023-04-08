#!/bin/bash

# Update the system
echo "Updating system..."
apt update && apt upgrade -y
echo "System has been updated."

# Install necessary tools
echo "Installing necessary tools..."
apt install -y nmap iptables-persistent fail2ban
echo "Tools have been installed."

# Scan for open ports and services
echo "Scanning for open ports and services..."
nmap -sS -sV localhost > services.txt

# Secure SSH
if grep -q "22/tcp open" services.txt; then
  echo "Securing SSH..."
  sed -i 's/#Port 22/Port <non-standard-ssh-port>/' /etc/ssh/sshd_config
  sed -i 's/#PermitRootLogin yes/PermitRootLogin no/' /etc/ssh/sshd_config
  sed -i 's/#PasswordAuthentication yes/PasswordAuthentication no/' /etc/ssh/sshd_config
  systemctl restart sshd
  echo "SSH has been secured."
fi

# Secure FTP
if grep -q "21/tcp open" services.txt; then
  echo "Securing FTP..."
  sed -i 's/write_enable=YES/write_enable=NO/' /etc/vsftpd.conf
  echo "FTP has been secured."
fi

# Secure HTTP
if grep -q "80/tcp open" services.txt || grep -q "443/tcp open" services.txt; then
  echo "Securing HTTP..."
  echo "ServerTokens Prod" >> /etc/apache2/conf-available/security.conf
  echo "ServerSignature Off" >> /etc/apache2/conf-available/security.conf
  echo "TraceEnable Off" >> /etc/apache2/conf-available/security.conf
  systemctl restart apache2
  echo "HTTP has been secured."
fi

# Secure DNS
if grep -q "53/tcp open" services.txt || grep -q "53/udp open" services.txt; then
  echo "Securing DNS..."
  sed -i 's/#DNSSEC=yes/DNSSEC=yes/' /etc/systemd/resolved.conf
  echo "DNS has been secured."
fi

# Secure NTP
if grep -q "123/udp open" services.txt; then
  echo "Securing NTP..."
  iptables -A INPUT -p udp --dport 123 -j DROP
  echo "NTP has been secured."
fi

# Secure SNMP
if grep -q "161/udp open" services.txt; then
  echo "Securing SNMP..."
  iptables -A INPUT -p udp --dport 161 -j DROP
  echo "SNMP has been secured."
fi

# Secure SMTP
if grep -q "25/tcp open" services.txt; then
  echo "Securing SMTP..."
  sed -i 's/inet_interfaces = all/inet_interfaces = localhost/' /etc/postfix/main.cf
  systemctl restart postfix
  echo "SMTP has been secured."
fi

# Secure IMAP and POP3
if grep -q "143/tcp open" services.txt || grep -q "993/tcp open" services.txt || grep -q "110/tcp open" services.txt || grep -q "995/tcp open" services.txt; then
  echo "Securing IMAP and POP3..."
  sed -i 's/inet_interfaces = all/inet_interfaces = localhost/' /etc/dovecot/dovecot.conf
  systemctl restart dovecot
  echo "IMAP and POP3 have been secured."
fi

#Securing Samba
# Backup smb.conf
echo "Backing up smb.conf..."
cp /etc/samba/smb.conf /etc/samba/smb.conf.bak

# Update smb.conf
echo "Updating smb.conf..."
sed -i 's/map to guest = bad user/map to guest = never/g' /etc/samba/smb.conf
echo "Server signing = mandatory" >> /etc/samba/smb.conf
echo "SMB encryption = required" >> /etc/samba/smb.conf

# Restart Samba
echo "Restarting Samba..."
systemctl restart smbd

echo "Samba has been secured."

# Enable firewall
echo "Enabling firewall..."
iptables -P INPUT DROP
iptables -A INPUT -i lo -j ACCEPT
iptables -A INPUT -m state --state ESTABLISHED,RELATED -j ACCEPT
iptables -A INPUT -p tcp --dport 22 -j ACCEPT
iptables -A INPUT -p tcp --dport 21 -j ACCEPT
iptables -A INPUT -p tcp --dport 80 -j ACCEPT
iptables -A INPUT -p tcp --dport 443 -j ACCEPT
iptables-save > /etc/iptables/rules.v4
echo "Firewall has been enabled."

# Enable fail2ban
echo "Enabling fail2ban..."
systemctl enable fail2ban
systemctl start fail2ban
echo "Fail2ban has been enabled."

#Harden Kernal
# Install necessary packages
echo "Installing necessary packages..."
apt-get install -y gcc make curl
echo "Packages installed."

# Download and install kernel
echo "Downloading kernel..."
curl -O https://cdn.kernel.org/pub/linux/kernel/v5.x/linux-5.11.14.tar.xz
tar -xf linux-5.11.14.tar.xz
cd linux-5.11.14
echo "Compiling kernel..."
make defconfig
make -j $(nproc)
make modules_install
make install
echo "Kernel installed."

# Configure kernel parameters
echo "Configuring kernel parameters..."
echo "net.ipv4.ip_forward = 0" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.send_redirects = 0" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.send_redirects = 0" >> /etc/sysctl.conf
echo "net.ipv4.conf.all.accept_redirects = 0" >> /etc/sysctl.conf
echo "net.ipv4.conf.default.accept_redirects = 0" >> /etc/sysctl.conf
echo "kernel.sysrq = 0" >> /etc/sysctl.conf
echo "net.ipv4.icmp_echo_ignore_broadcasts = 1" >> /etc/sysctl.conf
echo "net.ipv4.icmp_ignore_bogus_error_responses = 1" >> /etc/sysctl.conf
echo "kernel.exec-shield = 1" >> /etc/sysctl.conf
echo "kernel.randomize_va_space = 2" >> /etc/sysctl.conf
echo "fs.protected_hardlinks = 1" >> /etc/sysctl.conf
echo "fs.protected_symlinks = 1" >> /etc/sysctl.conf
sysctl -p
echo "Kernel parameters configured."

# Harden sudoers file
echo "Harden sudoers file..."
chmod 440 /etc/sudoers
echo "Sudoers file hardened."

# Remove unnecessary packages
echo "Removing unnecessary packages..."
apt-get remove -y gcc make curl
echo "Unnecessary packages removed."

echo "Kernel hardened successfully!"

# Cleanup
rm services.txt

echo "System has been secured."
