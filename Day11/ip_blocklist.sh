#!/bin/bash
# ================================================================
# Script: ip_blocklist.sh
# Description:
#   Parse authentication logs, detect repeated failed login attempts
#   from the same IP, and generate a blocklist file.
#
# Usage:
#   ./ip_blocklist.sh [threshold]
#   - threshold: number of failed attempts before IP is blacklisted (default: 5)
#
# Notes:
#   - Reads from /var/log/auth.log (Debian/Ubuntu) or /var/log/secure (RHEL).
#   - Output file: ./blacklisted_ips.txt
#   - Requires read access to log files (run as root or with sudo).
#
# Author: shovker
# ================================================================

set -euo pipefail

log_error() { echo "[ERROR] $*" >&2; exit 1; }
log_info()  { echo "[INFO]  $*"; }

file="/var/log/auth.log"
threshold=5
outfile="blacklisted.txt"


while [[ $# -gt 0 ]]; do
  case "$1" in
    --file) shift; file="${1:-}" ;;
    --threshold) shift; threshold="${1:-}" ;;
    --output) shift; outfile="${1:-}" ;;
    *) log_error "Unknown option: $1" ;;
  esac
  shift || true
done

[ -r "$file" ] || log_error "File not readable: $file"


grep "Failed password" "$file" \
  | awk '{print $11}' \
  | sort | uniq -c | sort -nr \
  > /tmp/ip_stats.txt

> "$outfile"  

while read -r count ip; do
  if [ "$count" -gt "$threshold" ]; then
    echo "$ip" >> "$outfile"
  fi
done < /tmp/ip_stats.txt

log_info "Blacklist written to $outfile"
