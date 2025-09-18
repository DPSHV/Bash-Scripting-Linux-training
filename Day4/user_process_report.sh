#!/bin/bash
# ================================================
#  Script: user_process_report.sh
#  Description:
#    Lists all processes owned by the current user
#    and counts the total number of them.
#
#    - Uses ps to list PID and CMD.
#    - Iterates through processes with while/read.
#    - Prints each process and increments counter.
#
#  Usage:
#    ./user_process_report.sh
#
#  Author: shovker
# ================================================
sum=0

while IFS= read -r line; do
  [ -n "$line" ] || continue
  pid="${line%% *}"     # first token
  cmd="${line#* }"      # rest of the line
  printf "PID=%s CMD=%s\n" "$pid" "$cmd"
  ((sum++))
done < <(ps -u "${USER:-$(id -un)}" -o pid= -o args=)

echo "TOTAL PROCESSES = $sum"