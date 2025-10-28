#!/bin/bash
# ================================================================
# Script: apparmor_report.sh
# Description:
#   Generate a detailed AppArmor status report including:
#   - General AppArmor status
#   - Loaded profiles and their modes
#   - Profiles related to sshd or nginx (if present)
#   Report is printed to stdout and saved to /var/log/apparmor_report.log
#
# Usage:
#   ./apparmor_report.sh
#
# Notes:
#   - Requires AppArmor tools (aa-status).
#   - Will gracefully handle missing AppArmor.
#
# Author: shovker
# ================================================================

set -euo pipefail

LOG_FILE="/var/log/apparmor_report.log"

log_info() {
    echo "[INFO] $*"
}

log_error() {
    echo "[ERROR] $*" >&2
}

trap 'log_error "Unexpected error occurred. Exiting."; exit 1' ERR

generate_report() {
    if ! command -v aa-status &>/dev/null; then
        log_error "AppArmor tools not found. Is AppArmor installed?"
        return 1
    fi

    {
        echo "==== AppArmor Report ===="
        date
        echo

        echo "General status:"
        aa-status
        echo

        echo "Profiles:"
        aa-status --profile || true
        echo

        echo "Checking profiles for sshd or nginx:"
        grep -E "(sshd|nginx)" /etc/apparmor.d/* 2>/dev/null || echo "No sshd/nginx profiles found."
        echo
    } | tee "$LOG_FILE"

    log_info "Report saved to $LOG_FILE"
}

generate_report

