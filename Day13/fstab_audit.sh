#!/bin/bash
# ================================================================
# Script: fstab_validator.sh
# Description:
#   Sprawdza wpisy w /etc/fstab i raportuje, czy pierwszy
#   identyfikator urządzenia jest zdefiniowany poprawnie (UUID= lub LABEL=).
#
# Usage:
#   ./fstab_validator.sh
#
# Output:
#   - Wypisuje linia po linii status wpisów.
#   - Kod wyjścia:
#       0 → wszystkie wpisy OK
#       1 → znaleziono wpisy niepoprawne (WARN)
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

# Pomijamy komentarze i puste linie, analizujemy tylko 3 pierwsze kolumny
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
