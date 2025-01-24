#!/bin/bash

set -euo pipefail

# Create the Buildarr user with the configured UID/GID.
deluser buildarr 2> /dev/null || true
delgroup buildarr 2> /dev/null || true
addgroup -S -g "$PGID" buildarr
adduser -S -s /bin/sh -g buildarr -u "$PUID" buildarr

# Start Buildarr under the Buildarr user, and replace the bootstrap shell
# with the Buildarr process as PID 1.
exec su-exec buildarr:buildarr buildarr "$@"
