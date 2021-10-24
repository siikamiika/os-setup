#!/bin/sh

echo "Configuring backup"
sudo cp ./rsync-inc-backup.sh /usr/local/bin/

cat ./crontab | crontab -

echo "Remember to set the BACKUP_HOST and BACKUP_HOST_DIR variables"

sudo systemctl enable cronie.service
sudo systemctl restart cronie.service
