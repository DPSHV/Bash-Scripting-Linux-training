#!/bin/bash
# ================================================================
# Script: disk_usage_report.sh
# Description:
#   Monitoruje zajętość dysków i zapisuje raport, jeśli przekroczony
#   jest określony próg użycia. Pomija filesystemy tmpfs.
#
# Usage:
#   ./disk_usage_report.sh [threshold]
#   - threshold: wartość procentowa granicy zajętości (domyślnie 80)
#
# Output:
#   - report.txt z wpisami w formacie:
#       <YYYY-MM-DD HH:MM:SS> DISK USAGE ABOVE THRESHOLD: FS, XX%
#
# Notes:
#   - opiera się na poleceniu `df -P`
#   - wymaga dostępu do systemu plików
#
# Author: shovker
# ================================================================

set -euo pipefail

THRESHOLD="${1:-80}"
REPORT_FILE="report.txt"

log_info() {
    echo "< $(date '+%F %T') > [INFO] $*"
}

log_warn() {
    echo "< $(date '+%F %T') > [WARN] $*" | tee -a "$REPORT_FILE"
}

cleanup() {
    rm -f "$temp"
}

temp="$(mktemp)"
trap cleanup EXIT


df -P | tail -n +2 > "$temp"

while read -r FS BLOCKS USED AVAIL CAP MOUNT; do
    CAP="${CAP%\%}"  
    if [[ "$FS" == *tmpfs* ]]; then
        continue
    fi

    if (( CAP > THRESHOLD )); then
        log_warn "DISK USAGE ABOVE ${THRESHOLD}%: $FS mounted on $MOUNT, $CAP%"
    else
        log_info "Disk OK: $FS ($CAP%)"
    fi
done < "$temp"
