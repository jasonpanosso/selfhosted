#!/bin/sh
# ip:  keep the myanonamouse dynamic seedbox IP current
# vip: top VIP up to the maximum with bonus points
set -eu

jar=/data/cookies.txt
seed=/data/mam-id-seed

if [ ! -f "$jar" ] || [ "$(cat "$seed" 2>/dev/null)" != "$MAM_ID" ]; then
    printf '.myanonamouse.net\tTRUE\t/\tTRUE\t0\tmam_id\t%s\n' "$MAM_ID" > "$jar"
    printf '%s' "$MAM_ID" > "$seed"
    echo "seeded cookie jar from MAM_ID"
fi

case "${1:-}" in
    ip)
        response="$(curl -sS --connect-timeout 20 --max-time 60 --retry 10 --retry-max-time 180 --retry-all-errors -b "$jar" -c "$jar" https://t.myanonamouse.net/json/dynamicSeedbox.php)"
        echo "$response"
        # "Completed": IP updated, "No change": already current; anything else fails the Job
        echo "$response" | grep -qiE '"success": *true|no change'
        ;;
    vip)
        curl -sS --connect-timeout 20 --max-time 60 --retry 10 --retry-max-time 180 --retry-all-errors -b "$jar" -c "$jar" "https://www.myanonamouse.net/json/bonusBuy.php/?spendtype=VIP&duration=max&_=$(date +%s)000"
        echo
        ;;
    *)
        echo "usage: $0 ip|vip" >&2
        exit 2
        ;;
esac
