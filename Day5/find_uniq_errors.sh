#!/bin/bash
# ============================================================================
#  Script: find_uniq_errors.sh
#  Author: shovker
#  Description:
#    Parses a log file and prints unique lines containing the word "ERROR",
#    ignoring case. Ensures input is valid and limits to a single file.
#
#    Usage:
#      ./find_uniq_errors.sh <logfile>
#
#    Example:
#      ./find_uniq_errors.sh /var/log/syslog
#
# ============================================================================

log_error() { echo "[ERROR] $*" >&2; exit 1; }
log_warn()  { echo "[WARN]  $*" >&2; }
log_info()  { echo "[INFO]  $*"; }

[[ $# -eq 1 ]] || log_error "Usage: $0 <logfile>"
[[ -f "$1" ]]   || log_error "File '$1' not found or not a regular file"

log_info "Processing file: $1"

grep -i "ERROR" "$1" | sort | uniq
