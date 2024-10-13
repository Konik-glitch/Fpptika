#!/usr/bin/env bash
# entrypoint.sh

# Start Tor in the background
tor &

# Wait for Tor to start
sleep 5

# Ensure user permissions are correct
[[ "$USER_ID" == "$(id -u whoami)" && "$GROUP_ID" == "$(id -g whoami)" ]] || usermod --uid "$USER_ID" --gid "$GROUP_ID" whoami

# Configure the environment to always use Tor
export http_proxy="socks5h://127.0.0.1:9050"
export https_proxy="socks5h://127.0.0.1:9050"
export all_proxy="socks5h://127.0.0.1:9050"

# Redirect DNS requests through Tor
echo "nameserver 127.0.0.1" > /etc/resolv.conf

# Execute the command as 'whoami' user
exec sudo --user whoami -- "$@"