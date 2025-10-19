#!/bin/bash
# ================================================================
# Script: backup_daily.sh
# Description:
#   Create a daily backup of /etc into /var/backups/etc-YYYYMMDD.tar.gz
#   with logging and error handling.
#
# Usage:
#   ./backup_daily.sh
#
# Notes:
#   - Intended to be run from cron (e.g., every night).
#   - Logs activity to /var/log/backup_daily.log
#
# Author: shovker
# ================================================================
set -euo pipefail

log_file="/var/log/backup_daily.log"
backup_dir="/var/backups"
src_dir="/etc"
date_str=$(date +%F)
archive="${backup_dir}/etc-${date_str}.tar.gz"

log_info()  { echo "< $(date '+%F %T') > [INFO]  $*" | tee -a "$log_file"; }
log_error() { echo "< $(date '+%F %T') > [ERROR] $*" | tee -a "$log_file" >&2; exit 1; }

[[ -d "$backup_dir" ]] || mkdir -p "$backup_dir"

log_info "Starting backup of $src_dir to $archive"

if tar -czf "$archive" "$src_dir" 2>>"$log_file"; then
    log_info "Backup completed successfully: $archive"
else
    log_error "Backup failed!"
fi
