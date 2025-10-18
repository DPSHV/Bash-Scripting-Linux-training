#!/bin/bash
# ================================================================
# Script: system_alert.sh
# Description:
#   Monitor key system metrics (RAM, Disk, Load) and log alerts if
#   thresholds are exceeded.
#
# Usage:
#   ./system_alert.sh
#
# Output:
#   - system_alert.log with timestamped alerts or info
#
# Author: shovker
# ================================================================

set -euo pipefail

LOGFILE="system_alert.log"
RAM_THRESHOLD=90
DISK_THRESHOLD=80
LOAD_THRESHOLD=5.0

timestamp=$(date '+%F %T')


ram_used=$(free | awk '/Mem:/ {printf "%.0f", $3/$2*100}')
disk_used=$(df -P / | awk 'NR==2 {gsub("%","",$5); print $5}')


load=$(awk '{print $1}' /proc/loadavg)

if (( ram_used > RAM_THRESHOLD || disk_used > DISK_THRESHOLD )) || (( $(echo "$load > $LOAD_THRESHOLD" | bc -l) )); then
    echo "<$timestamp> [ALERT] RAM=${ram_used}% DISK=${disk_used}% LOAD=${load}" >> "$LOGFILE"
else
    echo "<$timestamp> [INFO] System OK (RAM=${ram_used}% DISK=${disk_used}% LOAD=${load})" >> "$LOGFILE"
fi
