#!/bin/bash
# ================================================
#  Script: txt_backup.sh
#  Description:
#    Creates backup copies of all *.txt files
#    in a given directory by appending a suffix
#    before the .txt extension.
#
#    - Validates directory and suffix input.
#    - Iterates over all *.txt files in directory.
#    - Copies each file with new name (suffix + .txt).
#
#  Usage:
#    ./txt_backup.sh
#    (script will prompt for directory and suffix)
#
#  Author: shovker
# ================================================
[ $# -gt 0 ] || { echo "[ERROR] no files provided" >&2; exit 1; }

total=0

for file in "$@"; do
  if [ -f "$file" ]; then
    lines=$(wc -l < "$file")
    printf "FILE=%s LINES=%s\n" "$file" "$lines"
    ((total += lines))
  else
    echo "[WARN] '$file' is not a regular file, skipping" >&2
  fi
done

echo "TOTAL LINES = $total"

