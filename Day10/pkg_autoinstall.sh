#!/bin/bash
# ================================================================
# Script: pkg_autoinstall.sh
# Description:
#   Verify if given packages are installed; if missing, install them
#
# Usage:
#   ./pkg_autoinstall.sh <package1> [package2 ...]
#
# Notes:
#   - Debian/Ubuntu/Kali: uses dpkg + apt-get
#   - RHEL/CentOS/Fedora: uses rpm + dnf
#   - Requires root privileges for installation (via sudo)
#   - Non-interactive mode (-y) used for unattended installs
#
# Author: shovker
# ================================================================


set -euo pipefail

log_error() { echo "[ERROR] $*" >&2; exit 1; }
log_warn()  { echo "[WARN]  $*"; }
log_info()  { echo "[INFO]  $*"; }

[ $# -gt 0 ] || log_error "Usage: $0 <package1> [package2 ...]"

osrelease=$(source /etc/os-release; echo "$ID")

print_report() {
    printf "%-20s %-12s %-20s %-10s\n" "PACKAGE" "STATUS" "VERSION" "MANAGER"
    printf "%-20s %-12s %-20s %-10s\n" "-------" "------" "-------" "-------"
}

print_line() {
    local name="$1" status="$2" version="$3" mgr="$4"
    printf "%-20s %-12s %-20s %-10s\n" "$name" "$status" "$version" "$mgr"
}

print_report

for pkg in "$@"; do
    case "$osrelease" in
        debian|ubuntu|kali)
            if dpkg -s "$pkg" >/dev/null 2>&1; then
                version=$(dpkg -s "$pkg" | awk -F': ' '/^Version/ {print $2; exit}')
                print_line "$pkg" "installed" "$version" "apt-get"
            else
                log_warn "$pkg not found, installing..."
                sudo apt-get update -qq
                set +e
                sudo apt-get install -y "$pkg" >/dev/null 2>&1
                rc=$?
                set -e
                if [[ $rc -eq 0 ]]; then
                    version=$(dpkg -s "$pkg" | awk -F': ' '/^Version/ {print $2; exit}')
                    print_line "$pkg" "installed" "$version" "apt-get"
                else
                     print_line "$pkg" "FAILED" "-" "apt-get"
                fi
            fi
            ;;
        rhel|centos|fedora)
            if rpm -q "$pkg" >/dev/null 2>&1; then
                version=$(rpm -qi "$pkg" | awk -F': ' '/^Version/ {print $2; exit}')
                print_line "$pkg" "installed" "$version" "dnf"
            else
                log_warn "$pkg not found, installing..."
                sudo dnf install -y "$pkg"
                version=$(rpm -qi "$pkg" | awk -F': ' '/^Version/ {print $2; exit}')
                print_line "$pkg" "installed" "$version" "dnf"
            fi
            ;;
        *)
            log_error "Unsupported distro: $osrelease"
            ;;
    esac
done
