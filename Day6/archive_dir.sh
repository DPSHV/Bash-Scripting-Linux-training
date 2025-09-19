#!/bin/bash
# ================================================
#  Script: archive_dir.sh
#  Description:
#    Archives a directory to .tar.gz
#
#    - Supports: --debug, --keep-temp
#    - Auto-cleans archive file unless --keep-temp
#    - Uses trap to cleanup on exit
#
#  Usage:
#    ./archive_dir.sh [--debug] [--keep-temp] <dir>
#
#  Author: shovker
# ================================================
set -euo pipefail

log_info()  { echo "[INFO] $*"; }
log_error() { echo "[ERROR] $*" >&2; exit 1; }

debug=false
keeptemp=false

while [[ $# -gt 0 ]]; do
  case "$1" in
    --debug)
      debug=true
      shift
      ;;
    --keep-temp)
      keeptemp=true
      shift
      ;;
    --help)
      echo "Usage: $0 [--debug] [--keep-temp] <dir>"
      exit 0
      ;;
    *)
      dir="$1"
      shift
      ;;
  esac
done

[ -n "${dir:-}" ] || log_error "Missing directory"
[ -d "$dir" ]     || log_error "'$dir' is not a directory"

[[ "$debug" == true ]] && set -x

archive="${dir}_$(date +%F).tar.gz"

cleanup() {
  if [[ "$keeptemp" == false && -f "$archive" ]]; then
    log_info "Removing temp archive: $archive"
    rm -f "$archive"
  fi
}
trap cleanup EXIT

log_info "Creating archive: $archive"
tar -czf "$archive" "$dir"
log_info "Done."

[[ "$keeptemp" == true ]] && log_info "--keep-temp enabled"
