#!/bin/bash
# ================================================================
# Script: firewall_report.sh
# Description:
#   Generate a firewall rules report using nftables or iptables.
#   The script automatically detects which firewall tool is present
#   and collects the ruleset into a timestamped report file.
#
# Usage:
#   sudo ./firewall_report.sh
#
# Notes:
#   - Output file: ./firewall_report.txt
#   - Requires root privileges to display complete rules.
#   - Safer than using SUID bit — run with sudo or via systemd service.
#
# Author: shovker
# ================================================================

set -euo pipefail

REPORT="firewall_report.txt"

log_info() {
    echo "< $(date '+%F %T') > [INFO] $*" >&2
}

log_error() {
    echo "< $(date '+%F %T') > [ERROR] $*" >&2
    exit 1
}

{
    echo "========== Firewall Report =========="
    echo "Generated: $(date)"
    echo "Host: $(hostname)"
    echo "====================================="
    echo
} > "$REPORT"

if command -v nft >/dev/null 2>&1; then
    log_info "Collecting nftables ruleset..."
    {
        echo "=== nftables ruleset ==="
        nft list ruleset
        echo
    } >> "$REPORT"
fi

if command -v iptables >/dev/null 2>&1; then
    log_info "Collecting iptables rules..."
    {
        echo "=== iptables rules ==="
        iptables -L -n -v
        echo
    } >> "$REPORT"
fi

log_info "Firewall report saved to $REPORT"
