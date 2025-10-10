#!/bin/bash
# ================================================================
# Script: system_security_report.sh
# Description:
#   Generate a quick security report of the system with sections:
#   - umask (value + comment)
#   - /tmp sticky bit check
#   - ufw status
#   - sudoers NOPASSWD scan
#   - top 5 SUID files
#
# Usage:
#   ./system_security_report.sh
#
# Output:
#   report_sec.txt
#
# Author: shovker
# ================================================================

set -euo pipefail

REPORT="report_sec.txt"
> "$REPORT"

{
  echo "========== System Security Report =========="
  echo
  echo "Generated: $(date)"
  echo
  echo "============================================"
} >> "$REPORT"


echo "===== UMASK =====" >> "$REPORT"
umask_value=$(umask)
case "$umask_value" in
  0022) echo "Umask: Standard ($umask_value)" >> "$REPORT" ;;
  0077) echo "Umask: Strict ($umask_value)"   >> "$REPORT" ;;
  *)    echo "Umask: $umask_value"            >> "$REPORT" ;;
esac
echo >> "$REPORT"


echo "===== TMP STICKY BIT =====" >> "$REPORT"
tmp_perms=$(stat -c '%A' /tmp)
if [[ "${tmp_perms: -1}" == "t" ]]; then
  echo "/tmp Perms: $tmp_perms" >> "$REPORT"
  echo "STICKY BIT PRESENT" >> "$REPORT"
else
  echo "/tmp Perms: $tmp_perms" >> "$REPORT"
  echo "STICKY BIT >NOT< PRESENT" >> "$REPORT"
fi
echo >> "$REPORT"


echo "===== UFW =====" >> "$REPORT"
if command -v ufw >/dev/null 2>&1; then
  ufw status >> "$REPORT" 2>&1 || echo "ufw installed but inactive" >> "$REPORT"
else
  echo "ufw not installed" >> "$REPORT"
fi
echo >> "$REPORT"


echo "===== SUDOERS (NOPASSWD check) =====" >> "$REPORT"
if [ -f /etc/sudoers ]; then
  grep -r "NOPASSWD" /etc/sudoers /etc/sudoers.d/ 2>/dev/null >> "$REPORT" || \
    echo "No NOPASSWD entries found" >> "$REPORT"
else
  echo "/etc/sudoers not found" >> "$REPORT"
fi
echo >> "$REPORT"


echo "===== SUID TOP 5 =====" >> "$REPORT"
find /usr /bin /sbin -perm -4000 -type f -printf "%p %U\n" 2>/dev/null | head -n 5 >> "$REPORT"
echo >> "$REPORT"

echo "Report generated: $REPORT"
