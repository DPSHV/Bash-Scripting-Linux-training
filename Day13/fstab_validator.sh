#!/bin/bash
# ================================================================
# Script: fstab_validator.sh
# Description:
#   Validate entries in /etc/fstab and check if the first field
#   uses UUID= or LABEL= instead of raw device paths.
#
# Usage:
#   ./fstab_validator.sh
#
# Output:
#   - Prints each fstab entry with status [INFO] or [WARN].
#   - Exit codes:
#       0 → all entries valid
#       1 → at least one invalid entry found
#
# Author: shovker
# ================================================================


set -euo pipefail

bc=0

log_info() {
    echo "< $(date '+%F %T') > [INFO] $*"
}

log_warn() {
    echo "< $(date '+%F %T') > [WARN] $*"
}


awk '!/^\s*#/ && NF >= 3 {print $1, $2, $3}' /etc/fstab | \
while read -r DEV MOUNT FS; do
    if [[ "$DEV" == UUID=* || "$DEV" == LABEL=* ]]; then
        log_info "Valid entry: $DEV -> $MOUNT ($FS)"
    else
        log_warn "Non-UUID/LABEL entry: $DEV -> $MOUNT ($FS)"
        ((bc++))
    fi
done

if (( bc > 0 )); then
    exit 1
else
    exit 0
fi
