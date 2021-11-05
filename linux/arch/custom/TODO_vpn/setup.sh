#!/bin/sh

# TODO ipv6

interface_tmpl()
{
    # MTU = 1420
    echo "\
[Interface]
Address = $1
ListenPort = $2
PrivateKey = $3"
}

CONF_FILE=/etc/wireguard/wg0.conf

[ ! "$(id -u)" -eq 0 ] && echo "must run as root" && exit 1

echo "Configuring wireguard"

if [ -e "$CONF_FILE" ]; then
    exit
fi

ADDRESS=$(while true; do
    read -p "Address (CIDR): "
    [ ! -z "$REPLY" ] && echo $REPLY && break
done)
LISTEN_PORT=$(while true; do
    read -p "ListenPort: "
    [ ! -z "$REPLY" ] && echo $REPLY && break
done)
PRIVKEY="$(wg genkey)"
(umask 0077 && interface_tmpl "$ADDRESS" "$LISTEN_PORT" "$PRIVKEY" > "$CONF_FILE")

groupadd -f wireguard_users
sudo systemctl enable --now wg-quick@wg0
