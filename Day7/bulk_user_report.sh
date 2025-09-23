#!/bin/bash
# ================================================================
# Script: bulk_user_report.sh
# Description:
#   Reports information about a predefined list of users.
#   Supports:
#     --short : display UID and GID (default)
#     --full  : display shell and groups too
#     --debug : show command trace
#
# Usage:
#   ./bulk_user_report.sh [--short|--full] [--debug]
#
# Author: shovker
# ================================================================

log_error() { echo "[ERROR] $*" >&2; exit 1; }
log_warn()  { echo "[WARN]  $*" >&2; }
log_info()  { echo "[INFO]  $*"; }

short="true"
full="false"

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --debug)
      set -x
      ;;
    --short)
      short="true"
      full="false"
      ;;
    --full)
      full="true"
      short="false"
      ;;
    --help)
      echo "Usage: $0 [--short|--full] [--debug]"
      exit 0
      ;;
    -*)
      log_error "Unknown flag: $1"
      ;;
  esac
  shift
done

[ "$short" = "true" ] && [ "$full" = "true" ] && log_error "Cannot use both --short and --full"

users=(nginx root nobody)

for user in "${users[@]}"; do
  if id "$user" &>/dev/null; then
    if [ "$short" = "true" ]; then
      id "$user"
    elif [ "$full" = "true" ]; then
      id "$user"
      getent passwd "$user" | awk -F: '{print "Shell: " $NF}'
      groups "$user"
    fi
  else
    log_warn "User '$user' does not exist"
  fi
done
