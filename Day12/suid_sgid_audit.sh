#!/bin/bash
# ================================================================
# Script: suid_sgid_audit.sh
# Description:
#   Scan /usr, /bin, /sbin for files with SUID/SGID bits,
#   collect file metadata, mark suspicious entries, and count totals.
#
# Usage:
#   ./suid_sgid_audit.sh
#
# Notes:
#   - Output: ./report.txt
#   - Suspicious = owner != root OR world-writable
#   - Uses: find, stat, wc, mktemp
#
# Author: shovker
# ================================================================

set -euo pipefail

REPORT_FILE="./report.txt"
TMPFILE="$(mktemp)"
suid_count=0
gid_count=0
sus_count=0

log_info()  { echo "[INFO] $*" >&2; }
log_error() { echo "[ERROR] $*" >&2; }

cleanup() {
    rm -f "$TMPFILE"
}
trap cleanup EXIT


log_info "Scanning for SUID files..."
find /usr /bin /sbin -perm -4000 -type f > "$TMPFILE"
suid_count=$(wc -l < "$TMPFILE")

log_info "Scanning for SGID files..."
find /usr /bin /sbin -perm -2000 -type f >> "$TMPFILE"
gid_count=$(( $(wc -l < "$TMPFILE") - suid_count ))


{
  echo "================================================"
  echo " SUID/SGID Audit Report"
  echo " Generated: $(date)"
  echo "================================================"
  echo
} > "$REPORT_FILE"


while IFS= read -r file; do 
    name=$(stat -c '%n' "$file")
    rights=$(stat -c '%A' "$file")
    owner=$(stat -c '%U' "$file")
    size=$(stat -c '%s' "$file")

    {
      echo "[FILE]:   $name"
      echo "Rights :  $rights"
      echo "Owner  :  $owner"
      echo "Size   :  $size"
    } >> "$REPORT_FILE"

    flagged=false

    if [[ "$owner" != "root" ]]; then 
        echo "!!! SUS (owner!=root)" >> "$REPORT_FILE"
        ((sus_count++))
        flagged=true
    fi

    if [[ "${rights:8:1}" == "w" ]]; then
        echo "!!! SUS (world-writable)" >> "$REPORT_FILE"
        ((sus_count++))
        flagged=true
    fi

    if [[ $flagged == false ]]; then
        echo "OK" >> "$REPORT_FILE"
    fi

    echo "-----------------------------" >> "$REPORT_FILE"
done < "$TMPFILE"


{
  echo
  echo "==== SUMMARY ===="
  echo "SUID files   : $suid_count"
  echo "SGID files   : $gid_count"
  echo "Suspicious   : $sus_count"
  echo "Report saved : $REPORT_FILE"
} >> "$REPORT_FILE"

log_info "Audit complete. Report: $REPORT_FILE"
