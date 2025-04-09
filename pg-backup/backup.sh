#!/bin/bash

# Define the backup file name using current date and time
BACKUP_NAME="d11-prod-$(date +%F_%H-%M-%S)"

# Get the year and month from the current date
YEAR=$(date +%Y)
MONTH=$(date +%m)

# Create a directory structure by year and month
BACKUP_DIR="/backups/$YEAR/$MONTH"
mkdir -p "$BACKUP_DIR"

# Perform the pg_dump and create a temporary SQL dump
pg_dump -h postgres -U postgres -d d11 -c -F p > /tmp/$BACKUP_NAME.sql

# Create a tar.gz archive and store it in the year/month subdirectory
tar -czf "$BACKUP_DIR/$BACKUP_NAME.tar.gz" -C /tmp $BACKUP_NAME.sql

# Clean up the temporary SQL dump file
rm /tmp/$BACKUP_NAME.sql
