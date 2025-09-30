#!/bin/bash
# ================================================================
# Script: pkg_check.sh
# Description:
#   Check if a package is installed and report version + package manager
#
# Usage:
#   ./pkg_check.sh <package-name>
#
# Notes:
#   - Supports Debian/Ubuntu/Kali (dpkg/apt)
#   - Supports RHEL/CentOS/Fedora (rpm/dnf)
#   - Requires root privileges only if querying restricted packages
#
# Author: shovker
# ================================================================


set -euo pipefail

log_error() { echo "[ERROR] $*" >&2; exit 1; }
log_info()  { echo "[INFO]  $*"; }

[ $# -eq 1 ] || log_error "Usage: $0 <package-name>"

pkg="$1"
osrelease=$(source /etc/os-release; echo "$ID")

if [[ "$osrelease" == "debian" || "$osrelease" == "ubuntu" || "$osrelease" == "kali" ]]; then
    if dpkg -s "$pkg" >/dev/null 2>&1; then
        log_info "$pkg is installed"
        dpkg -s "$pkg" | grep '^Version'
        echo "Manager: apt"
    else
        log_info "$pkg is not installed"
    fi

elif [[ "$osrelease" == "rhel" || "$osrelease" == "centos" || "$osrelease" == "fedora" ]]; then
    if rpm -q "$pkg" >/dev/null 2>&1; then
        log_info "$pkg is installed"
        rpm -qi "$pkg" | grep '^Version'
        echo "Manager: dnf"
    else
        log_info "$pkg is not installed"
    fi

else
    log_error "Unsupported distro: $osrelease"
fi
