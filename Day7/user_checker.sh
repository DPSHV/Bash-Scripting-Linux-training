#!/bin/bash
# ================================================================
# Script: user_checker.sh
# Description:
#   Checks whether a given user exists and displays their information.
#   Supports two modes:
#     --short : display only UID and GID
#     --full  : display shell and groups as well
#   Defaults to --short if no mode is specified.
#
# Usage:
#   ./user_checker.sh [--short|--full] <username> [--debug]
#
# Author: shovker
# ================================================================

log_error() { echo "[ERROR] $*" >&2; exit 1; }
log_warn()  { echo "[WARN]  $*" >&2; }
log_info()  { echo "[INFO]  $*"; }

short="false"
full="false"

while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --debug)
      set -x
      ;;
    --short)
      short="true"
      ;;
    --full)
      full="true"
      ;;
    --help)
      echo "Usage: $0 [--short|--full] <username>"
      exit 0
      ;;
    -*)
      log_error "Unknown option: $1"
      ;;
    *)
      username="$1"
      ;;
  esac
  shift
done

[ -z "$username" ] && log_error "No username provided"
[ "$short" = "true" ] && [ "$full" = "true" ] && log_error "Cannot use both --short and --full"
[ "$short" = "false" ] && [ "$full" = "false" ] && log_info "No mode specified, defaulting to --short" && short="true"

if ! id "$username" &>/dev/null; then
  log_warn "User '$username' does not exist"
  exit 1
fi

if [ "$short" = "true" ]; then
  id "$username"
elif [ "$full" = "true" ]; then
  id "$username"
  getent passwd "$username" | awk -F: '{print "Shell: " $NF}'
  groups "$username"
fi
