#!/bin/bash
# ================================================================
# Script: cron_healthcheck.sh
# Description:
#   Healthcheck script to ping a host and log results.
#   Designed to be run by cron every few minutes.
#
# Usage:
#   ./cron_healthcheck.sh [host]
#
# Notes:
#   - Default host: 8.8.8.8
#   - Logs to /var/log/healthcheck.log
#   - Demonstrates use of trap and cleanup
#
# Author: shovker
# ================================================================
set -euo pipefail

log_file="/var/log/healthcheck.log"
host="${1:-8.8.8.8}"
tmpfile=$(mktemp /tmp/healthcheck.XXXXXX)

cleanup() {
    [[ -f "$tmpfile" ]] && rm -f "$tmpfile"
}
trap cleanup EXIT INT TERM

log_info()  { echo "< $(date '+%F %T') > [INFO]  $*" | tee -a "$log_file"; }
log_error() { echo "< $(date '+%F %T') > [ERROR] $*" | tee -a "$log_file" >&2; }

if ping -c1 -W2 "$host" >"$tmpfile" 2>&1; then
    log_info "Host $host is reachable"
else
    log_error "Host $host is unreachable"
fi
