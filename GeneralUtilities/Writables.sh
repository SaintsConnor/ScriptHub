#!/bin/bash
echo "Writable files:"
find / -type f -writable -exec ls -la {} \;
echo ""
echo "Writable directories:"
find / -type d -writable -exec ls -la {} \;
