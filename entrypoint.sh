#!/bin/bash

set -e 

if [ -n "$MFA_TOKEN" ]; then
    LOGIN_DATA=$(cat <<EOF
{
    "name": "$USERNAME",
    "password": "$PASSWORD",
    "code": "$MFA_TOKEN",
    "authMethod": "jwt"
}
EOF
    )
    LOGIN_ENDPOINT="$MFA_LOGIN_URL"
else
    LOGIN_DATA=$(cat <<EOF
{
    "name": "$USERNAME",
    "password": "$PASSWORD",
    "ignoreCaptcha": true,
    "language": "zh",
    "authMethod": "jwt"
}
EOF
    )
    LOGIN_ENDPOINT="$LOGIN_URL"
fi

ENTRANCE_CODE=$(printf $ENTRANCE_CODE | base64)

RESPONSE=$(curl -s -X POST "$LOGIN_ENDPOINT" \
    -H "Content-Type: application/json" \
    -H "EntranceCode: $ENTRANCE_CODE" \
    -d "$LOGIN_DATA")

TOKEN=$(echo "$RESPONSE" | grep -Po '(?<="token":")[^"]*')

if [ -z "$TOKEN" ]; then
    echo "login failed, Pls check."
    echo "response: $RESPONSE"
    exit 1
fi

echo "login success"

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
    -H "PanelAuthorization: $TOKEN" \
    -H "Content-Type: application/json" \
    -d "$UPLOAD_DATA")

echo "cert upload response: $UPLOAD_RESPONSE"
