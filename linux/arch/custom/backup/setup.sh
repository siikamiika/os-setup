#!/bin/sh

echo "Configuring backup"
sudo cp ./rsync-inc-backup.sh /usr/local/bin/

CRONTAB="/var/spool/cron/$USER"
sudo cp ./crontab "$CRONTAB"
sudo chown "$USER:$USER" "$CRONTAB"
sudo chmod 600 "$CRONTAB"

echo "Remember to set the BACKUP_HOST and BACKUP_HOST_DIR variables"

sudo systemctl enable cronie.service
sudo systemctl restart cronie.service
