#!/bin/bash
echo "Enter the source file path: "
read source_file
echo "Enter the destination file path: "
read dest_file
echo "Enter the remote server IP address: "
read server_ip
echo "Enter the remote server username: "
read username
echo "Enter the remote server password: "
read password
echo "Starting SCP transfer..."
scp $source_file $username@$server_ip:$dest_file
