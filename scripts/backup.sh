#!/bin/bash

set -euo pipefail

PROJECT_DIR="$HOME/projects/employee-management-system"
BACKUP_DIR="$PROJECT_DIR/backups"
CONTAINER_NAME="employee-postgres"
DB_NAME="employee_db"
DB_USER="employee_admin"

mkdir -p "$BACKUP_DIR"

TIMESTAMP=$(date +"%Y-%m-%d_%H-%M-%S")
BACKUP_FILE="$BACKUP_DIR/${DB_NAME}_${TIMESTAMP}.sql"

echo "Starting PostgreSQL database backup..."

if ! docker inspect -f '{{.State.Running}}' "$CONTAINER_NAME" 2>/dev/null | grep -qx true; then
    echo "ERROR: PostgreSQL container is not running."
    exit 1
fi

if docker exec "$CONTAINER_NAME" pg_dump \
    -U "$DB_USER" \
    -d "$DB_NAME" \
    > "$BACKUP_FILE"; then

    if [ -s "$BACKUP_FILE" ]; then
        echo "Backup completed successfully."
        echo "Backup file: $BACKUP_FILE"
        ls -lh "$BACKUP_FILE"
    else
        echo "ERROR: Backup file is empty."
        rm -f "$BACKUP_FILE"
        exit 1
    fi
else
    echo "ERROR: Database backup failed."
    rm -f "$BACKUP_FILE"
    exit 1
fi
