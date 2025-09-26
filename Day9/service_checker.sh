#!/bin/bash
# ================================================================
# Script: service_checker.sh
# Description:
#   Check status and enablement of given systemd services.
#
# Usage:
#   ./service_checker.sh <service1> <service2> ...
#
# Notes:
#   - Requires: systemd (systemctl)
#   - Exit codes: 0 success, 1 usage/tool error
#
# Author: shovker
# ================================================================

set -euo pipefail

log_error() { echo "[ERROR] $*" >&2; exit 1; }
log_warn()  { echo "[WARN]  $*"; }
log_info()  { echo "[INFO]  $*"; }


if [ "$#" -eq 0 ]; then
  log_error "Provide at least one service name"
fi


command -v systemctl >/dev/null 2>&1 || log_error "systemctl not found"

printf "%-24s %-10s %-10s\n" "SERVICE" "ACTIVE" "ENABLED"

for svc in "$@"; do
  if systemctl status "$svc" >/dev/null 2>&1; then
    active=$(systemctl is-active "$svc" 2>/dev/null || echo "unknown")
    enabled=$(systemctl is-enabled "$svc" 2>/dev/null || echo "unknown")
    printf "%-24s %-10s %-10s\n" "$svc" "$active" "$enabled"
  else
    log_warn "Service not found: $svc"
  fi
done
