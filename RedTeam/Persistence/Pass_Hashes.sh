#!/bin/bash
echo "Password hashes for all users:"
grep -v -E "^(root|\$)" /etc/shadow | awk -F: '{print $1 " : " $2}'
