#!/bin/bash
# ================================================================
# Script: unit_lister.sh
# Description:
#   List systemd services in a clean, tabular form.
#   Flags:
#     --enabled-only : show only services enabled for autostart
#
# Usage:
#   ./unit_lister.sh [--enabled-only]
#
# Notes:
#   - Requires: systemd (systemctl), awk
#   - Uses `list-units` for runtime state and `list-unit-files` for enablement
#   - Exit codes: 0 success, 1 usage/tool error
#
# Author: shovker
# ================================================================

set -euo pipefail

log_error() { echo "[ERROR] $*" >&2; exit 1; }
log_warn()  { echo "[WARN]  $*"; }
log_info()  { echo "[INFO]  $*"; }


for bin in systemctl awk; do
  command -v "$bin" >/dev/null 2>&1 || log_error "Missing required tool: $bin"
done

enabled_only=false


if [ "$#" -gt 1 ]; then
  log_error "Too many arguments. Usage: $0 [--enabled-only]"
fi

while [ "$#" -gt 0 ]; do
  case "$1" in
    --enabled-only) enabled_only=true ;;
    -h|--help)
      echo "Usage: $0 [--enabled-only]"
      exit 0
      ;;
    *)
      log_error "Unknown parameter: $1"
      ;;
  esac
  shift
done

if [ "$enabled_only" = true ]; then
  log_info "Listing enabled services (unit files)…"

  systemctl --no-pager list-unit-files --type=service \
    | awk 'NR>1 && $2=="enabled" { printf "%-48s %-10s\n", $1, $2 }'
else
  log_info "Listing active services (runtime)…"

  systemctl --no-pager list-units --type=service \
    | awk 'NR>1 { printf "%-48s %-10s %-10s\n", $1, $3, $4 }'
fi
