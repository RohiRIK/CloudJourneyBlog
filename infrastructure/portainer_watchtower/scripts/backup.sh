#!/bin/bash

# Define backup directory and filename
BACKUP_DIR="../n8n/backups"
BACKUP_FILE="backup_$(date +'%Y%m%d_%H%M%S').sql"

# Create backup directory if it doesn't exist
mkdir -p $BACKUP_DIR

# Command to backup PostgreSQL database
pg_dump -U $POSTGRES_USER -h localhost -d $POSTGRES_DB > $BACKUP_DIR/$BACKUP_FILE

# Check if the backup was successful
if [ $? -eq 0 ]; then
    echo "Backup successful! File saved to $BACKUP_DIR/$BACKUP_FILE"
else
    echo "Backup failed!"
fi