#!/bin/bash
# ================================================================
# Script: network_health.sh
# Description:
#   Perform a simple network health check by collecting:
#   - Network interfaces and addresses
#   - Routing table
#   - Connectivity to external IP (8.8.8.8)
#   - DNS resolution test (google.com)
#   Results are saved to a timestamped report file.
#
# Usage:
#   ./network_health.sh
#
# Notes:
#   - Output file: ./network_health.txt
#   - Requires basic network tools (ip, ping).
#
# Author: shovker
# ================================================================

set -euo pipefail

REPORT="network_health.txt"

log_info() {
    echo "< $(date '+%F %T') > [INFO] $*" >&2
}

log_error() {
    echo "< $(date '+%F %T') > [ERROR] $*" >&2
    exit 1
}

{
    echo "========== Network Health Report =========="
    echo "Generated: $(date)"
    echo "Host: $(hostname)"
    echo "=========================================="
    echo
    echo "===== Interfaces ====="
    ip a || log_error "Failed to get interfaces"
    echo
    echo "===== Routing table ====="
    ip route || log_error "Failed to get routing table"
    echo
    echo "===== Connectivity (ping to 8.8.8.8) ====="
    if ping -c1 -W2 8.8.8.8 >/dev/null 2>&1; then
        echo "OK: Internet connectivity working"
    else
        echo "FAIL: Cannot reach 8.8.8.8"
    fi
    echo
    echo "===== DNS test (ping google.com) ====="
    if ping -c1 -W2 google.com >/dev/null 2>&1; then
        echo "OK: DNS resolution working"
    else
        echo "FAIL: DNS resolution failed"
    fi
    echo
} > "$REPORT"

log_info "Network health report saved to $REPORT"
