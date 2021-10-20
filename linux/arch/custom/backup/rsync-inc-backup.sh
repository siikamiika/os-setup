#!/bin/sh

# rsync-inc-backup.sh \
#     ~/SomeLocalDir/ \
#     username@host \
#     ~/SomeRemoteDir/ \
#     [max amount]

LOCAL_PATH="$1"
REMOTE_HOST="$2"
REMOTE_PATH="$3"
ROTATE="$4"

function sshrun()
{
    ssh "$REMOTE_HOST" -- "$@"
}

function incremental_backup()
{
    # idea: http://www.mikerubel.org/computers/rsync_snapshots/#Incremental
    sshrun mkdir -p "$REMOTE_PATH"
    local max_backups=$1
    sshrun mv "$REMOTE_PATH/backup.$max_backups" "$REMOTE_PATH/backup.tmp"
    for ((i=max_backups; i>=1; i--)); do
        local j="$((i-1))"
        sshrun mv "$REMOTE_PATH/backup.$j" "$REMOTE_PATH/backup.$i"
    done
    sshrun mv "$REMOTE_PATH/backup.tmp" "$REMOTE_PATH/backup.0"
    sshrun cp -al "$REMOTE_PATH/backup.1/." "$REMOTE_PATH/backup.0"
    rsync -a --delete "$LOCAL_PATH/" "$REMOTE_HOST:$REMOTE_PATH/backup.0"
}

incremental_backup "${ROTATE:-10}"
