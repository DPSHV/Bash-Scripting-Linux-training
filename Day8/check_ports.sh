#!/bin/bash
# =====================================================
# check_ports.sh
# Check host reachability and scan TCP ports with nc.
#
# Usage:
#   ./check_ports.sh <host/ip> <port1> [port2 ...]
#
# Exit codes:
#   0 - success
#   1 - usage error / host unreachable
# =====================================================

set -euo pipefail

log_error() { echo "[ERROR] $*" >&2; exit 1; }
log_warn()  { echo "[WARN]  $*" >&2; }
log_info()  { echo "[INFO]  $*"; }

[ $# -ge 2 ] || log_error "Usage: $0 <host/ip> <port1> [port2 ...]"

params=("$@")
ip="${params[0]}"

if ping -c1 -W1 "$ip" &>/dev/null; then
    log_info "Host $ip is reachable"
else
    log_error "Host $ip is not responding"
fi

for port in "${params[@]:1}"; do
    if nc -z -w2 "$ip" "$port" &>/dev/null; then
        log_info "Port $port is OPEN on $ip"
    else
        log_warn "Port $port is CLOSED on $ip"
    fi
done
