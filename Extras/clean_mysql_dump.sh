#!/bin/bash
# ================================================================
# Script: clean_mysql_dump.sh
# Description:
#   Monitors disk usage and automatically cleans up the contents
#   of the MySQL dump directory if disk usage exceeds a threshold.
#
# Usage:
#   ./clean_mysql_dump.sh
#   - Adjust 'target' and 'threshold' variables inside the script
#
# Notes:
#   - Logs are written to /var/log/disk_cleanup.log
#   - Disk usage is checked with df(1) on the filesystem where
#     the target directory resides
#   - Requires proper permissions to delete files in $target
#
# Exit codes:
#   0 → completed successfully
#   1 → error occurred (e.g. cannot fetch disk usage, missing target)
#
# Author: shovker
# ================================================================

set -euo pipefail

log_info() {
    echo "< $(date '+%F %T') > [INFO] $*" >> /var/log/disk_cleanup.log
}

log_error() {
    echo "< $(date '+%F %T') > [ERROR] $*" >> /var/log/disk_cleanup.log
    exit 1
}

target="/home/user/mysql_dumps"
threshold=90

diskusage=$(df -P "$target" | awk 'NR==2 {print $5}')
diskusage="${diskusage%\%}"

if ! [[ "$diskusage" =~ ^[0-9]+$ ]]; then
    log_error "Failed to get disk usage"
fi

if (( diskusage > threshold )); then
    if [ -d "$target" ]; then
        shopt -s nullglob
        rm -rf "$target"/* || true
        log_info "Cleaned $target because disk usage exceeded ${threshold}% (current: ${diskusage}%)"
    else
        log_error "Target directory $target does not exist"
    fi
else
    log_info "Disk usage is ${diskusage}%, no cleanup needed"
fi
