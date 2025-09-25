#!/bin/bash
# ================================================================
# Script: ip_report.sh
# Description:
#   Reports IPv4 and IPv6 addresses with interface state (UP/DOWN).
#
# Usage:
#   ./ip_report.sh
#
# Notes:
#   - Strips CIDR mask from IPs
#   - Uses `ip -o` (one-line) format
#
# Author: shovker
# ================================================================

set -euo pipefail

log_error() { echo "[ERROR] $*" >&2; exit 1; }
log_info()  { echo "[INFO]  $*"; }

log_info "=== IPv4 ==="
ip -o -4 a | while read -r idx iface fam addr _; do
    ip_clean="${addr%%/*}"
    state=$(ip link show "$iface" | awk '/state/ {print $9}')
    echo "IFACE=$iface ADDR=$ip_clean STATE=$state"
done

log_info "=== IPv6 ==="
ip -o -6 a | while read -r idx iface fam addr _; do
    ip_clean="${addr%%/*}"
    state=$(ip link show "$iface" | awk '/state/ {print $9}')
    echo "IFACE=$iface ADDR=$ip_clean STATE=$state"
done
