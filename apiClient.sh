#!/bin/bash

DEFAULT_PORT=4242

IP="$1"
PORT="${2:-$DEFAULT_PORT}"

get_broadcast_address() {
    ip addr show | grep "inet " | grep -v "127.0.0.1" | head -n1 | awk '{print $2}' | sed 's/\([0-9]\+\.[0-9]\+\.[0-9]\+\.\)[0-9]\+/\1255/'
}

# Handshake Procedure:
# Client: Aloha!
# Server: Oh, no.
# Client: My name is someName
# Server: And broadcast address of your network?
# Client: *.*.*.*
# Server: Ready.
# Bye message: May the Force be with you!

exec 3<>/dev/tcp/$IP/$PORT || {
    echo "Failed to connect to $IP:$PORT"
    exit 1
}

echo "Aloha!" >&3
read -r response <&3
if [ "$response" != "Oh, no." ]; then
    echo "Handshake failed: Expected 'Oh, no.', got '$response'"
    exit 1
fi

echo "My name is $(whoami)" >&3
read -r response <&3
if [ "$response" != "And broadcast address of your network?" ]; then
    echo "Handshake failed: Unexpected response '$response'"
    exit 1
fi


broadcast=$(get_broadcast_address)
echo "$broadcast" >&3
read -r response <&3
if [ "$response" != "Ready." ]; then
    echo "Handshake failed: Expected 'Ready.', got '$response'"
    exit 1
fi

echo "May the Force be with you!"

while true; do
    echo -e "\nAvailable commands:"
    echo "1. GetCapitalOfCountry <country>"
    echo "2. GetCountriesWithCurrency <currency>"
    echo "3. exit"
    echo -n "Enter command: "
    read -r command
    
    echo "$command" >&3
    read -r response <&3
    echo "Server response: $response"
    
done

