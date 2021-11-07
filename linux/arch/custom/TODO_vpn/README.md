# VPN

## Wireguard setup

### Server

- `wireguard_peer_daemon`
- `echo '{"endpoint_host": "example.com"}' | sudo tee /usr/local/etc/wireguard_peer_daemon.json`
- `groupadd -f wireguard_users`
- `useradd -m -G wireguard_users wireguard_user_1`

### Client

- `wireguard_peer_daemon`
- `wireguard_add_remote_peer wireguard_user_1@example.com`

done
