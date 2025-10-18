#!/bin/bash
# ================================================================
# Script: system_report.sh
# Description:
#   Generate a system snapshot report including CPU load, memory,
#   disk usage, and top processes by CPU and RAM usage.
#
# Usage:
#   ./system_report.sh
#
# Output:
#   - system_report.txt in the current directory
#
# Author: shovker
# ================================================================

set -euo pipefail

REPORT="system_report.txt"

{
    echo "========== System Report =========="
    echo "Generated: $(date '+%F %T')"
    echo

    echo "===== LOAD AVERAGE ====="
    uptime
    echo

    echo "===== MEMORY ====="
    free -m
    echo

    echo "===== DISK USAGE ====="
    df -h
    echo

    echo "===== TOP 5 PROCESSES (CPU) ====="
    ps aux --sort=-%cpu | head -n 6
    echo

    echo "===== TOP 5 PROCESSES (MEM) ====="
    ps aux --sort=-%mem | head -n 6
    echo

    echo "=================================="
} > "$REPORT"

echo "Report written to $REPORT"
