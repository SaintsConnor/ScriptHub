#!/bin/bash

# Check if the script is being run as root
if [ "$EUID" -ne 0 ]; then
    echo "This script must be run as root."
    exit 1
fi

# Get a list of all users
USERS=$(cut -d: -f1 /etc/passwd)

# Set the output directory
OUTPUT_DIR=~/Documents/AuditLogs/auditd

# Loop through each user and dump all logs
for USER in $USERS; do
    # Create the user directory if it doesn't exist
    USER_DIR=$OUTPUT_DIR/$USER
    mkdir -p $USER_DIR
    
    # Get the current date in DD/MM/YYYY format
    DATE=$(date +%d/%m/%Y)
    
    # Create the date directory if it doesn't exist
    DATE_DIR=$USER_DIR/$DATE
    mkdir -p $DATE_DIR
    
    # Dump all logs and save to the appropriate file
    LOG=$DATE-logs.txt
    echo "Dumping all logs for user $USER to $DATE_DIR/$LOG..."
    sudo ausearch -ua $USER -i > $DATE_DIR/$LOG
done
