#!/bin/sh

set -e

usage() {
    echo "Usage: $0 <url> <json-file>"
    echo "  <url>       The API endpoint used to configure the download client"
    echo "  <json-file> The JSON file containing the data to modify."
    exit 1
}

if [ $# -ne 2 ]; then
    usage
fi

URL="$1"
JSON_FILE="$2"

if [ ! -f "$JSON_FILE" ]; then
    echo "Error: JSON file '$JSON_FILE' not found."
    exit 1
fi

if [ -z "${QBITTORRENT_PASSWORD:-}" ]; then
    echo "Error: QBITTORRENT_PASSWORD environment variable is not set."
    exit 1
fi

if [ -z "${API_KEY:-}" ]; then
    echo "Error: API_KEY environment variable is not set."
    exit 1
fi

INPUT_NAME=$(jq -r '.name' "$JSON_FILE")
if [ -z "$INPUT_NAME" ]; then
    echo "Error: No 'name' field found in the input JSON."
    exit 1
fi

RESPONSE_BODY=$(mktemp)
HTTP_STATUS=$(curl -L -s -o "$RESPONSE_BODY" \
        -w "%{http_code}" \
        -X GET "$URL" \
        -H "Accept: application/json" \
    -H "X-Api-Key: $API_KEY")
if [ "$HTTP_STATUS" -lt 200 ] || [ "$HTTP_STATUS" -ge 300 ]; then
    echo "Error: Failed to fetch DownloadClients (HTTP $HTTP_STATUS)"
    exit 1
fi

RESOURCES=$(cat "$RESPONSE_BODY")
if ! echo "$RESOURCES" | jq empty; then
    echo "Error: Malformed JSON in DownloadClients GET response."
    echo "$RESPONSE_BODY"
    exit 1
fi

echo "$RESOURCES" | jq -r --arg name "$INPUT_NAME" '.[] | select(.name != $name) | .id' | while read -r ID; do
    echo "Deleting download client with ID $ID"
    curl -L -s -o /dev/null "$URL/$ID" -X DELETE -H "X-Api-Key: $API_KEY"
done


MATCHING_RESOURCE=$(echo "$RESOURCES" | jq --arg name "$INPUT_NAME" '.[] | select(.name == $name)')
if [ -n "$MATCHING_RESOURCE" ]; then
    MATCHING_ID=$(echo "$MATCHING_RESOURCE" | jq -r '.id')

    MODIFIED_JSON=$(jq --arg id "$MATCHING_ID" --arg newPassword "$QBITTORRENT_PASSWORD" '
      .id = $id |
      .fields |= map(if .name == "password" then .value = $newPassword else . end)
    ' "$JSON_FILE")

    RESPONSE=$(curl -L -s -o /dev/null -w "%{http_code}" \
            -X PUT "$URL/$MATCHING_ID" \
            -H "Content-Type: application/json" \
            -H "X-Api-Key: $API_KEY" \
        --data "$MODIFIED_JSON")

    if [ "$RESPONSE" -ge 200 ] && [ "$RESPONSE" -lt 300 ]; then
        echo "Successfully updated DownloadClient (HTTP $RESPONSE)"
    else
        echo "Failed to update DownloadClient (HTTP $RESPONSE)"
        exit 1
    fi
else
    MODIFIED_JSON=$(jq --arg newPassword "$QBITTORRENT_PASSWORD" '
      .fields |= map(if .name == "password" then .value = $newPassword else . end)
    ' "$JSON_FILE")

    RESPONSE=$(curl -L -s -o /dev/null -w "%{http_code}" \
            -X POST "$URL" \
            -H "Content-Type: application/json" \
            -H "X-Api-Key: $API_KEY" \
        --data "$MODIFIED_JSON")
    if [ "$RESPONSE" -ge 200 ] && [ "$RESPONSE" -lt 300 ]; then
        echo "Successfully created new DownloadClient (HTTP $RESPONSE)"
    else
        echo "Failed to create new DownloadClient (HTTP $RESPONSE)"
        exit 1
    fi
fi
