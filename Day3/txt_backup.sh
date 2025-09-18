#!/bin/bash
# ================================================
#  Script: txt_backup.sh
#  Description:
#    Read a target directory and a suffix from stdin, then create
#    backup copies of all *.txt files in that directory by appending
#    the suffix before the .txt extension.
#    Example: notes.txt + "_backup" -> notes_backup.txt
#
#  Details:
#    - Reads inputs using: read -r dir ; read -r suffix
#    - Iterates over "$dir"/*.txt (glob), skipping non-existing matches.
#    - Builds new names with parameter expansion: ${path%.txt}${suffix}.txt
#    - Counts and prints how many files were copied.
#
#  Output example:
#    Copied 7 files.
#
#  Author: shovker
# ================================================

log_info()  { echo "[INFO] $*"; }
log_warn()  { echo "[WARN] $*" >&2; }
log_error() { echo "[ERROR] $*" >&2; exit 1; }

echo "Enter directory path:"
read -r catalog
[ -d "$catalog" ] || log_error "Directory '$catalog' does not exist"

echo "Enter suffix to append (e.g., _backup):"
read -r suffix
[ -n "$suffix" ] || log_error "Suffix cannot be empty"

copied=0

for item in $catalog/*.txt; do
    if [ -f "$item" ]; then
        base="${item%.txt}"  # strip .txt extension
        newfile="${base}${suffix}.txt" # add suffix before .txt
        cp "$item" "$newfile"
        log_info "Copied: $item -> $newfile"
        ((copied++))
    fi
done


echo "Copied $copied file(s)."
