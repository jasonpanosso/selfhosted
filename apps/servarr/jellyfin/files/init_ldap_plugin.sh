#!/bin/sh

LDAP_PLUGIN_BASE_URL=${LDAP_PLUGIN_BASE_URL:-"https://repo.jellyfin.org/releases/plugin/ldap-authentication/"}
LDAP_PLUGIN_DIRECTORY=${LDAP_DIRECTORY:-"/config/plugins/ldap"}
CONFIG_DIRECTORY=${CONFIG_DIRECTORY:-"/config/plugins/configurations"}
LDAP_CONFIG_FILE_PATH=${LDAP_CONFIG_FILE_PATH:-"/secrets/LDAP-Auth.xml"}
LDAP_ARCHIVE=${LDAP_ARCHIVE:-"ldap-authentication_19.0.0.0.zip"}

# cleanup old ldap plugin install(make updating easier)

if [ -n "$LDAP_PLUGIN_DIRECTORY" ]; then
    rm -rf "$LDAP_PLUGIN_DIRECTORY"
fi

mkdir -p "$LDAP_PLUGIN_DIRECTORY" && mkdir -p "$CONFIG_DIRECTORY"

cd "$LDAP_PLUGIN_DIRECTORY" || exit
wget -q "$LDAP_PLUGIN_BASE_URL$LDAP_ARCHIVE" || { echo "Error downloading LDAP plugin archive"; exit 1; }
unzip "$LDAP_ARCHIVE" && rm "$LDAP_ARCHIVE"

cp "$LDAP_CONFIG_FILE_PATH" "$CONFIG_DIRECTORY"
