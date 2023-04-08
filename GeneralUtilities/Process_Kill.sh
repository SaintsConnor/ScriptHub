#!/bin/bash
echo "Enter the PID of the process to kill: "
read pid
kill $pid
echo "Process $pid has been killed."
