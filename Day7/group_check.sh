#!/bin/bash
# ================================================================
# Script: group_check.sh
# Description:
#   Lists all users that belong (or not) to a given group.
#   Flags:
#     --negate : show users NOT in the group
#     --debug  : enable set -x for debugging
#
# Usage:
#   ./group_check.sh <groupname> [--negate] [--debug]
#
# Notes:
#   - Uses /etc/passwd to get local users
#   - Validates group existence
#
# Author: shovker
# ================================================================

log_error() { echo "[ERROR] $*" >&2; exit 1; }
log_warn()  { echo "[WARN]  $*" >&2; }
log_info()  { echo "[INFO]  $*"; }

negate=false
group=""


while [[ "$#" -gt 0 ]]; do
  case "$1" in
    --debug)
      set -x
      ;;
    --negate)
      negate=true
      ;;
    --help)
      echo "Usage: $0 <groupname> [--negate] [--debug]"
      exit 0
      ;;
    -*)
      log_error "Unknown flag: $1"
      ;;
    *)
      if [ -z "$group" ]; then
        group="$1"
      else
        log_error "Too many arguments (already got group name: $group)"
      fi
      ;;
  esac
  shift
done


[ -z "$group" ] && log_error "Missing group name"
getent group "$group" >/dev/null || log_error "Group '$group' not found"

log_info "Analyzing group membership for group '$group'..."
log_info "Negate mode: $negate"


mapfile -t users < <(awk -F: '{ print $1 }' /etc/passwd)

for user in "${users[@]}"; do
  if id "$user" &>/dev/null; then
    user_groups=$(id -nG "$user")
    if echo "$user_groups" | grep -qw "$group"; then
      [ "$negate" = false ] && echo "$user"
    else
      [ "$negate" = true ] && echo "$user"
    fi
  fi
done
