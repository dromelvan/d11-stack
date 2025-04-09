#!/bin/bash

YEAR=$(date +%Y)
MONTH=$(date +%m)

BACKUP_DIR="/backups/$YEAR/$MONTH"
mkdir -p "$BACKUP_DIR"

pg_dump -h postgres -U d11dbuser -d d11 -c -f "$BACKUP_DIR/d11-prod-$(date +%F_%H%M%S).sql"
