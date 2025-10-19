#!/bin/bash
# ================================================================
# Script: process_limiter.sh
# Description:
#   Run a command with a specified "nice" value (CPU scheduling priority).
#
# Usage:
#   ./process_limiter.sh --command "<command>" --nice <value>
#   - command: program or command with optional arguments
#   - nice: integer between -20 (highest priority) and 19 (lowest priority)
#
# Notes:
#   - Logs execution info to ./nice.txt
#   - Requires appropriate permissions to set negative nice values
#
# Author: shovker
# ================================================================
set -euo pipefail

log_error(){ echo "[ERROR] $*" >&2; exit 1; }
log_info(){ echo "[INFO]  $*"; }

command=""
nice_val=0


while [[ $# -gt 0 ]]; do 
    case "$1" in 
        --command)
            shift
            if [[ $# -eq 0 ]]; then
                log_error "Missing value for --command"
            fi
            command="$1"
            shift
            while [[ $# -gt 0 && "$1" != --* ]]; do
                command="$command $1"
                shift
            done
            ;;
        --nice)
            shift
            if [[ $# -eq 0 ]]; then
                log_error "Missing value for --nice"
            fi
            nice_val="$1"
            shift
            ;;
        *)
            log_error "Unknown argument: $1"
            ;;
    esac
done


if [[ -z "$command" ]]; then
    log_error "No command provided (--command)"
fi

if ! [[ "$nice_val" =~ ^-?[0-9]+$ ]]; then
    log_error "Nice value must be an integer"
fi

if [[ "$nice_val" -lt -20 || "$nice_val" -gt 19 ]]; then
    log_error "Nice value must be between -20 and 19"
fi

log_info "Running: $command with nice=$nice_val"
nice -n "$nice_val" bash -c "$command"

echo "<$(date '+%F %T')> Ran '$command' with nice=$nice_val" >> nice.txt
