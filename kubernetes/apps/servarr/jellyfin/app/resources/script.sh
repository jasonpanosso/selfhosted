#!/bin/sh

API_KEY=$JELLYFIN_API_KEY
BASE_URL=$JELLYFIN_URL
USER=$JELLYFIN_ADMIN_USERNAME
# Go to https://jellyfin.example.com/web/#/dashboard/users and "rightclick > copy link" on your portrait to get your user ID
USERID=$JELLYFIN_ADMIN_USER_ID
# Fetch all persons
response=$(curl -s "${BASE_URL}/emby/Persons?api_key=${API_KEY}")

# Filter persons with empty ImageTags, sort by Id, and remove duplicates
ids=$(echo "$response" | /tools/jq -r '.Items[] | select(.ImageTags == null or .ImageTags == {}) | .Id' | sort -u)

# Fetch details for each person
for id in $ids; do
    curl -s "${BASE_URL}/Users/${USERID}/Items/${id}?api_key=${API_KEY}"
done
