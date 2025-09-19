#!/bin/bash
# ================================================
#  Script: pipe_debug.sh
#  Description:
#    Demonstrates a simple data pipeline:
#      grep → cut → sort
#
#    - Logs output via `tee` to output.log
#    - Supports --debug
#    - Reads from stdin or optional file
#
#  Usage:
#    ./pipe_debug.sh [--debug] [file]
#
#  Author: shovker
# ================================================
set -euo pipefail

log_info()  { echo "[INFO] $*"; }
log_error() { echo "[ERROR] $*" >&2; exit 1; }

debug=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --debug)
      debug=true
      shift
      ;;
    --help)
      echo "Usage: $0 [--debug] [file]"
      exit 0
      ;;
    -*)
      log_error "Unknown flag: $1"
      ;;
    *)
      input="$1"
      shift
      ;;
  esac
done

[[ "$debug" == true ]] && set -x

if [[ -n "${input:-}" ]]; then
  [ -f "$input" ] || log_error "File '$input' not found"
  cat "$input"
else
  cat
fi | grep -i "error" | cut -d':' -f2 | sort | tee output.log
