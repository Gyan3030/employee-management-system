#!/bin/bash
set -euo pipefail

BACKUP_DIR="$HOME/projects/employee-management-system/backups"

echo "Checking backups older than 7 days..."

find "$BACKUP_DIR" -maxdepth 1 -type f \
  -name 'employee_db_*.sql' -mtime +7 -print -delete

echo "Backup cleanup completed."
