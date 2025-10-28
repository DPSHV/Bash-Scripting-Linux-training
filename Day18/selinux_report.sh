#!/bin/bash
# ================================================================
# Script: selinux_report.sh
# Description:
#   Generate a detailed SELinux status report including:
#   - Current mode (Enforcing/Permissive/Disabled)
#   - Detailed SELinux status
#   - Configuration file (/etc/selinux/config)
#   - Labels of processes and files
#   Report is printed to stdout and saved to /var/log/selinux_report.log
#
# Usage:
#   ./selinux_report.sh
#
# Notes:
#   - Requires SELinux tools (getenforce, sestatus).
#   - Will gracefully handle missing SELinux.
#
# Author: shovker
# ================================================================

set -euo pipefail

LOG_FILE="/var/log/selinux_report.log"

log_info() {
    echo "[INFO] $*"
}

log_error() {
    echo "[ERROR] $*" >&2
}

trap 'log_error "Unexpected error occurred. Exiting."; exit 1' ERR

generate_report() {
    if ! command -v getenforce &>/dev/null; then
        log_error "SELinux tools not found. Is SELinux installed?"
        return 1
    fi

    {
        echo "==== SELinux Report ===="
        date
        echo

        echo "Mode:"
        getenforce
        echo

        echo "Detailed status:"
        sestatus || true
        echo

        echo "Config file (/etc/selinux/config):"
        if [[ -f /etc/selinux/config ]]; then
            cat /etc/selinux/config
        else
            echo "No config file found."
        fi
        echo

        echo "Process labels (first 5):"
        ps -eZ | head -n 5 || true
        echo

        echo "File labels in /etc (first 5):"
        ls -Z /etc | head -n 5 || true
        echo
    } | tee "$LOG_FILE"

    log_info "Report saved to $LOG_FILE"
}

generate_report

