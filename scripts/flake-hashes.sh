#!/usr/bin/env bash
# renovate post-upgrade script to bump flake.nix SHA hashes
set -euo pipefail

head=$(git show HEAD:flake.nix)

pairs=$(
    tr -s '[:space:]' ' ' <flake.nix |
    grep -oE 'url ?= ?"[^"]+" ?; ?sha256 ?= ?"[0-9a-f]{64}"' |
    sed -E 's/url ?= ?"([^"]+)" ?; ?sha256 ?= ?"([0-9a-f]{64})"/\1 \2/'
)

while read -r url old; do
    grep -qF "\"$url\"" <<<"$head" && continue # url unchanged
    grep -qF "$old" <<<"$head" || continue     # already refreshed
    new=$(curl -fsSL "$url" | sha256sum | cut -d' ' -f1)
    echo "$url: $old -> $new"
    sed -i "s/$old/$new/" flake.nix
done <<<"$pairs"
