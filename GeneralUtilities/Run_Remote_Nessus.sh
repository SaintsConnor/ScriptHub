#!/bin/bash

# Define Nessus connection details
NESSUS_URL="https://<NESSUS_SERVER>:8834"
NESSUS_USERNAME="<USERNAME>"
NESSUS_PASSWORD="<PASSWORD>"

# Define target to scan
TARGET_IP="<TARGET_IP>"

# Define scan policy to use
SCAN_POLICY="<SCAN_POLICY_NAME>"

# Authenticate with Nessus API and get token
TOKEN=$(curl -k -X POST -H "Content-Type: application/json" -d '{"username": "'"$NESSUS_USERNAME"'", "password": "'"$NESSUS_PASSWORD"'"}' "$NESSUS_URL"/session -c /tmp/nessus_cookie 2>/dev/null | jq -r '.token')

# Create new scan and get scan ID
SCAN_ID=$(curl -k -X POST -H "Content-Type: application/json" -H "X-Cookie: token=$TOKEN" -d '{"uuid": "'"$SCAN_POLICY"'", "settings": {"name": "Nessus scan", "text_targets": "'"$TARGET_IP"'", "enabled": true}}' "$NESSUS_URL"/scans 2>/dev/null | jq -r '.scan.id')

# Launch scan
curl -k -X POST -H "Content-Type: application/json" -H "X-Cookie: token=$TOKEN" "$NESSUS_URL"/scans/"$SCAN_ID"/launch 2>/dev/null > /dev/null

echo "Nessus scan has been launched."
