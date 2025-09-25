#!/bin/bash
# ================================================================
# Script: net_audit.sh
# Description:
#   Basic network audit:
#     - List active listening sockets (ss -tulnp)
#     - Show processes bound to 0.0.0.0 / :: (external)
#     - Detect port conflicts (multiple procs on same port)
#
# Usage:
#   ./net_audit.sh
#
# Notes:
#   - Requires ss (iproute2)
#   - Works for both IPv4 and IPv6
#
# Author: shovker
# ================================================================

set -euo pipefail

log_error() { echo "[ERROR] $*" >&2; exit 1; }
log_info()  { echo "[INFO]  $*"; }

log_info "=== SOCKETS ==="
if ! ss -tulnp; then
    log_error "ss not available"
fi

log_info "=== EXTERNAL LISTENERS ==="
ss -tulnp | awk '$5 ~ /0\.0\.0\.0:/ || $5 ~ /\[::\]:/'

log_info "=== PORT CONFLICTS ==="
ss -tulnp | awk '{print $5}' | cut -d: -f2 | \
    sort | uniq -c | awk '$1 > 1 {print "PORT=" $2 " COUNT=" $1}'
