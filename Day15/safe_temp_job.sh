#!/bin/bash
# ================================================================
# Script: safe_temp_job.sh
# Description:
#   Demonstration of safe temporary file handling in Bash.
#   The script creates a temporary file, writes dummy data into it,
#   and ensures cleanup even if the script is interrupted (e.g. Ctrl+C).
#
# Usage:
#   ./safe_temp_job.sh
#
# Notes:
#   - Uses `trap` to catch SIGINT and SIGTERM.
#   - Safe cleanup prevents leftover temp files in /tmp.
#
# Author: shovker
# ================================================================
set -euo pipefail

log_error(){ echo "[ERROR] $*" >&2; exit 1; }
log_info(){ echo "[INFO]  $*"; }


tempfile=$(mktemp /tmp/safejob.XXXXXX)

cleanup() {
    if [[ -f "$tempfile" ]]; then
        rm -f "$tempfile"
        log_info "Removed tempfile: $tempfile"
    fi
}


trap cleanup EXIT INT TERM

log_info "Created tempfile: $tempfile"


for i in {1..10}; do
    echo "$(date '+%F %T') Dummy log entry $i" >> "$tempfile"
    sleep 1
done

log_info "Finished writing to tempfile."
