# ================================================================
# Script: log_analyzer.sh
# Description:
#   Analyze a log file and generate a summary:
#     - Count INFO/WARN/ERROR entries
#     - Top 3 processes generating most logs
#     - Peak log hour (HH:MM with most entries)
#
# Usage:
#   ./log_analyzer.sh --file /path/to/log [--lines N]
#
# Notes:
#   - Default: analyzes last 1000 lines
#   - Requires readable log file
#   - Tested with syslog/auth.log style logs
#
# Author: shovker
# ================================================================

#!/bin/bash
set -euo pipefail

log_error() { echo "[ERROR] $*" >&2; exit 1; }
log_warn()  { echo "[WARN]  $*" >&2; }
log_info()  { echo "[INFO]  $*"; }

file=""
lines=1000

while [[ $# -gt 0 ]]; do
    case "$1" in
        --file)
            shift; file="${1:-}";;
        --lines)
            shift; lines="${1:-}";;
        *)
            log_error "Unknown argument: $1"
            ;;
    esac
    shift || true
done

[ -n "$file" ] || log_error "Missing --file argument"
[ -r "$file" ] || log_error "File not readable: $file"

log_info "Analyzing last $lines lines of $file"


tmp=$(mktemp)
tail -n "$lines" "$file" > "$tmp"


info_count=$(grep -c "INFO" "$tmp" || true)
warn_count=$(grep -c "WARN" "$tmp" || true)
error_count=$(grep -c "ERROR" "$tmp" || true)


top_processes=$(awk '{print $5}' "$tmp" \
    | sed 's/:\?$//' \
    | sort | uniq -c | sort -nr | head -n 3)


peak_minute=$(awk '{print $3}' "$tmp" \
    | cut -d: -f1,2 \
    | sort | uniq -c | sort -nr | head -n 1)


echo "==== Log Summary ===="
echo "INFO  : $info_count"
echo "WARN  : $warn_count"
echo "ERROR : $error_count"
echo
echo "Top 3 processes:"
echo "$top_processes"
echo
echo "Peak log minute:"
echo "$peak_minute"

rm -f "$tmp"
