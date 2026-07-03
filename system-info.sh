#!/bin/bash

echo "====================================="
echo "       SYSTEM INFORMATION"
echo "====================================="

echo "Hostname        : $(hostname)"
echo "Current User    : $(whoami)"
echo "Current Date    : $(date)"
echo "Uptime          : $(uptime -p)"

echo
echo "----------- CPU Information -----------"
lscpu | grep "Model name"

echo
echo "----------- Memory Usage --------------"
free -h

echo
echo "----------- Disk Usage ----------------"
df -h /

echo
echo "----------- IP Address ----------------"
hostname -I

echo
echo "----------- Logged-in Users -----------"
who

echo
echo "======================================="
