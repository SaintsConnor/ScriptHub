#!/bin/bash
echo "Hidden files:"
find / -name ".*" -exec ls -la {} \;
