#!/bin/bash
# ================================================
#  Script: log_cleaner.sh
#  Description:
#    Shows "ERROR" lines from a log file.
#    Optionally clears the file after confirmation.
#
#    - Supports: --dry-run
#    - Greps for "ERROR" (case-insensitive)
#    - Asks before clearing the log
#
#  Usage:
#    ./log_cleaner.sh [--dry-run] <logfile>
#
#  Author: shovker
# ================================================
set -euo pipefail

log_info() { echo "[INFO] $*"; }
log_error() { echo "[ERROR] $*" >&2; exit 1; }

dryrun=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --dry-run)
      dryrun=true
      shift
      ;;
    --help)
      echo "Usage: $0 [--dry-run] <logfile>"
      exit 0
      ;;
    *)
      logfile="$1"
      shift
      ;;
  esac
done

[ -n "${logfile:-}" ] || log_error "Missing logfile argument"
[ -f "$logfile" ]     || log_error "File '$logfile' does not exist"

log_info "Extracting ERRORs from '$logfile'"
grep -i "error" "$logfile" || log_info "No errors found."

if [[ "$dryrun" == true ]]; then
  log_info "[DRY-RUN] Would clear '$logfile'"
else
  read -rp "Clear the log file? (y/n): " confirm
  [[ "$confirm" =~ ^[Yy]$ ]] && > "$logfile" && log_info "File cleared"
fi
