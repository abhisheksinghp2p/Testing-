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
top | head -5

echo
echo "----------- Memory Usage --------------"
free -h

echo
echo "----------- Disk Usage ----------------"
df -h /

echo
echo "----------- IP Address ----------------"
hostname -I
hostnamectl | egrep "Kernel|Operating System|Static hostname"

echo
echo "----------- Logged-in Users -----------"
who

echo
echo "======================================="
