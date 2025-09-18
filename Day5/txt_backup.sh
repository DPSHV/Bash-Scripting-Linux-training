#!/bin/bash
# ============================================================================
#  Script: txt_backup.sh
#  Author: shovker
#  Description:
#    Creates backups of all non-empty .txt files in the current directory
#    (and subdirectories) by appending the current date to the filename.
#
#    Supports --dry-run for previewing actions, and --help for usage info.
#
#    Usage:
#      ./txt_backup.sh [--dry-run]
#
#    Example:
#      ./txt_backup.sh            → Copies files with date suffix
#      ./txt_backup.sh --dry-run → Shows what would be copied
#
# ============================================================================


log_error() { echo "[ERROR] $*" >&2; exit 1; }
log_warn()  { echo "[WARN]  $*" >&2; }
log_info()  { echo "[INFO]  $*"; }

dryrun=false
date=$(date +%Y-%m-%d)

while [[ $# -gt 0 ]]; do 
    case "$1" in
        --dry-run)
            dryrun=true
            shift
            ;;
        --help)
            log_info "Usage: $0 [--dry-run] [--help]"
            exit 0
            ;;
        *)
            log_error "Unknown option: $1"
            ;;
    esac
done

find . -name "*.txt" -type f -size +0c | while read -r item; do
    base="${item%.txt}"
    newname="${base}_${date}.txt"

    if [[ "$dryrun" == true ]]; then 
        log_info "[DRY-RUN] Would copy '$item' → '$newname'"
    else 
        log_info "Copying '$item' → '$newname'"
        cp "$item" "$newname"
    fi
done
