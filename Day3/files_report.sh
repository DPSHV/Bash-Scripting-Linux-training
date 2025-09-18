#!/bin/bash
# ================================================
#  Script: files_report.sh
#  Description:
#    For each file passed as an argument, print a one-line report:
#      FILE=<name> LINES=<line_count> SIZE=<bytes>
#    At the end, print TOTAL_LINES=<sum_of_lines>.
#
#  Details:
#    - Iterates over all positional parameters ("$@").
#    - Counts lines via: wc -l < "$file"  (number only, no filename).
#    - Gets size in bytes via: stat -c%s "$file".
#    - Missing files are reported to stderr as warnings.
#
#  Output format:
#    FILE=<name> LINES=<n> SIZE=<bytes>
#    TOTAL_LINES=<sum>
#
#  Author: shovker
# ================================================


set -euo pipefail # -e = exit on error -u = error on undefined var -o pipefail = fail if any cmd in pipeline fails
IFS=$'\n\t' # safer splitting: newline + tab only (not space)

log_warn() { echo "[WARN] $*" >&2; }
log_error() { echo "[ERROR] $*" >&2; exit 1; }

# check 4 empty vartable
[ $# -gt 0 ] || log_error "No files provided"

lines_total=0

for file in "$@"; do
    if [ -f "$file" ]; then
        lines=$(wc -l < "$file")         # pure line count wout fname
        size=$(stat -c%s "$file")        # file size in bytes
        printf "FILE=%s LINES=%s SIZE=%s\n" "$file" "$lines" "$size"
        lines_total=$((lines_total + lines))
    else
        log_warn "File '$file' not found"
    fi
done

echo "TOTAL_LINES=$lines_total"