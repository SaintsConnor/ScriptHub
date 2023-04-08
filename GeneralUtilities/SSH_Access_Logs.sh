#!/bin/bash
echo "Checking SSH access logs..."
tail -f /var/log/auth.log | grep sshd
