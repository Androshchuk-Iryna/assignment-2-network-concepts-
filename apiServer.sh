#!/bin/bash

PORT=4242
DB_FILE="/usr/bin/db.txt"

handshake() {
    local line
    
    read -r line
    log "Client message: $line"
    if [[ "$line" != "Aloha!" ]]; then
        log "Handshake failed: Expected 'Aloha!', got '$line'"
        return 1
    fi
    echo "Oh, no."
    
    read -r line
    log "Client message: $line"
    if [[ ! "$line" =~ ^"My name is ".+ ]]; then
        log "Handshake failed: Expected 'My name is <name>', got '$line'"
        return 1
    fi
    echo "And broadcast address of your network?"
    
    read -r line
    log "Client message: $line"
    if [[ ! "$line" =~ ^[0-9*]+\.[0-9*]+\.[0-9*]+\.[0-9*]+$ ]]; then
        log "Handshake failed: Invalid broadcast address format"
        return 1
    fi
    echo "Ready."
    return 0
}

commands() {
    local line
    while read -r line; do
        log "Received command: $line"
        
        case "$line" in
            "GetCapitalOfCountry "*)
                country="${line#GetCapitalOfCountry }"
                result=$(get_capital_of_country "$country")
                if [ -n "$result" ]; then
                    echo "$result"
                else
                    echo "Error: Country not found"
                fi
                ;;
            "GetCountriesWithCurrency "*)
                currency="${line#GetCountriesWithCurrency }"
                result=$(get_countries_with_currency "$currency")
                if [ -n "$result" ]; then
                    echo "$result"
                else
                    echo "Error: Currency not found"
                fi
                ;;
            "exit")
                echo "May the Force be with you!"
                return 0
                ;;
            *)
                echo "Error: Unknown command"
                ;;
        esac
    done
}

main() {
    socat TCP-LISTEN:$PORT,reuseaddr,fork EXEC:"$0 handle",pty,raw,echo=0
}

