#!/bin/bash
# ================================================================
# Script: disk_usage_report.sh
# Description:
#   Monitor disk usage using df(1) and generate a report
#   if any filesystem exceeds the given threshold. tmpfs
#   entries are ignored.
#
# Usage:
#   ./disk_usage_report.sh [threshold]
#     - threshold: percentage limit (default: 80)
#
# Output:
#   - Prints info/warning messages with timestamps
#   - Appends warnings to report.txt in the format:
#       <YYYY-MM-DD HH:MM:SS> [WARN] DISK USAGE ABOVE THRESHOLD: FS, XX%
#
# Exit codes:
#   0 → all filesystems below threshold
#   1
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
