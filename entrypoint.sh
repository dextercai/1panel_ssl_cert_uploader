#!/bin/bash

set -e 

generate_token() {
    local api_key="$1"
    local timestamp=$(date +%s)
    local token_string="1panel${api_key}${timestamp}"
    if command -v md5sum &>/dev/null; then
        local token=$(echo -n "$token_string" | md5sum | awk '{print $1}')
    else
        local token=$(echo -n "$token_string" | md5)
    fi
    echo "$timestamp $token"
}

read TIMESTAMP TOKEN < <(generate_token "$API_KEY")

PRIVATE_KEY_CONTENT=$(cat "$PRIVATE_KEY_PATH" | awk '{printf "%s\\n", $0}' | sed 's/\\n$//')
CERTIFICATE_CONTENT=$(cat "$CERTIFICATE_PATH" | awk '{printf "%s\\n", $0}' | sed 's/\\n$//')

UPLOAD_DATA=$(cat <<EOF
{
    "privateKey": "$PRIVATE_KEY_CONTENT",
    "certificate": "$CERTIFICATE_CONTENT",
    "privateKeyPath": "",
    "certificatePath": "",
    "type": "paste",
    "sslID": $SSL_ID,
    "description": "$DESCRIPTION"
}
EOF
)

UPLOAD_RESPONSE=$(curl -s -X POST "$UPLOAD_URL" \
    -H "1Panel-Token: $TOKEN" \
    -H "1Panel-Timestamp: $TIMESTAMP" \
    -H "Content-Type: application/json" \
    -d "$UPLOAD_DATA")

echo "cert upload response: $UPLOAD_RESPONSE"