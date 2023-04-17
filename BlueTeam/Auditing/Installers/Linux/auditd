sudo apt-get install auditd
sudo systemctl start auditd
sudo systemctl enable auditd
sudo auditctl -a always,exit -F arch=b64 -S execve
sudo auditctl -a always,exit -F arch=b64 -S open
sudo auditctl -a always,exit -F arch=b64 -S socket,connect,accept,bind -F key=network-traffic
sudo auditctl -a always,exit -F arch=b64 -S setuid,setgid,setgroups -F key=user-group-management
sudo auditctl -a always,exit -F arch=b64 -S clone,fork,execve,exit -F key=process-management
sudo auditctl -a always,exit -F arch=b64 -S mount,umount,reboot,shutdown -F key=system-configuration
