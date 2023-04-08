#!/bin/bash
echo "Enter the username: "
read username
echo "Enter the password: "
read password
useradd $username
echo $password | passwd $username --stdin
usermod -aG sudo $username
echo "User $username created and added to sudoers."
