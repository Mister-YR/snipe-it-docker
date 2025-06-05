#!/bin/bash
# docker exec snipeit php artisan snipeit:backup
# Cron job example:
# 0 1 * * * /bin/bash /docker-inventory/scripts/snipeit_backup_rotation.sh
# vars
CONTAINER_NAME="snipeit"
Backup_DIR="/docker-inventory/files/backups"
LOG_FILE="/docker-inventory/log/snipeit_backup.log"
DATE=$(date +"%Y-%m-%d %H:%M:%S")

# run artisan backup
echo "[$DATE] Starting Snipe-IT backup..." >> "$LOG_FILE"
docker exec "$CONTAINER_NAME" php artisan snipeit:backup >> "$LOG_FILE" 2>&1

STATUS=$?
if [ $STATUS -eq 0 ]; then
  echo "[$DATE] ✅ Backup completed successfully." >> "$LOG_FILE"
else
  echo "[$DATE] ❌ Backup failed with status $STATUS." >> "$LOG_FILE"
fi
# remove bkpk older then 7 days
find "$Backup_DIR" - type f -name "*.zip" -mtime +7 exec rm -v {} \; >> "$LOG_FILE"
# detacher
echo "--------------------------------------------------------" >> "$LOG_FILE"
