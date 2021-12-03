#!/bin/sh

# rsync-inc-backup.sh \
#     ~/SomeLocalDir/ \
#     username@host \
#     ~/SomeRemoteDir/ \
#     [max amount]

LOCAL_PATH="$1"
REMOTE_HOST="$2"
REMOTE_PATH="$3"
ROTATE="${4:-10}"

function sshrun()
{
    ssh "$REMOTE_HOST" -- "$@"
}

function find_start_pos()
{
    # in case there are not yet $ROTATE backups or previous run was interrupted
    for ((i=0; i<=ROTATE; i++)); do
        if ! sshrun test -e "$REMOTE_PATH/backup.$i"; then
            echo "$i"
            return
        fi
    done
    echo $ROTATE
}

function incremental_backup()
{
    # idea: http://www.mikerubel.org/computers/rsync_snapshots/#Incremental
    sshrun mkdir -p "$REMOTE_PATH"
    local start="$(find_start_pos)"
    if ((start == $ROTATE)) && sshrun test -e "$REMOTE_PATH/backup.$ROTATE"; then
        sshrun rm -rf "$REMOTE_PATH/backup.$ROTATE"
    fi
    for ((i=start; i>=1; i--)); do
        local j="$((i-1))"
        local from="$REMOTE_PATH/backup.$j"
        local to="$REMOTE_PATH/backup.$i"
        sshrun mv "$from" "$to"
    done
    if sshrun test -e "$REMOTE_PATH/backup.1"; then
        sshrun cp -al "$REMOTE_PATH/backup.1/." "$REMOTE_PATH/backup.0"
    fi
    rsync \
        -a \
        --delete \
        --itemize-changes \
        --exclude=/.cache \
        --exclude=*.qcow2 \
        "$LOCAL_PATH/" \
        "$REMOTE_HOST:$REMOTE_PATH/backup.0"
    if [ ! $? -eq 0 ]; then
        sshrun rm -rf "$REMOTE_PATH/backup.0"
    fi
}

incremental_backup
