#!/usr/bin/env bash
# renovate post-upgrade script to keep a node's initcall_blacklist pointing at the right symbol.
# utilize kernel's System.map to find new symbols after image upgrades, and update worker schematics
#
# initcalls/stubs format: __initstub__kmod_<module>__<counter>_<line>_<fn><level>
# usage: talos-initcall-blacklist.sh <node> <arch>
set -euo pipefail

node=$1
arch=$2
config=$(echo talos/nodes/*/"$node".yaml)
schematic=${config%.yaml}.schematic.yaml

image=$(grep -oE 'metal-installer/[0-9a-f]{64}:v[0-9.]+' "$config")
id=$(cut -d/ -f2 <<<"$image" | cut -d: -f1)
version=$(cut -d: -f2 <<<"$image")

# the siderolabs/pkgs tag this Talos release was built with. Find System.map from its kernel image
kernel_tag=$(curl -fsSL "https://raw.githubusercontent.com/siderolabs/talos/$version/pkg/machinery/gendata/data/pkgs")
system_map=$(crane export --platform "linux/$arch" "ghcr.io/siderolabs/kernel:$kernel_tag" - | tar -xOf - boot/System.map)

changed=false
while read -r old; do
    # same module and function, any counter and line number
    pattern=$(sed -E 's/__[0-9]+_[0-9]+_/__[0-9]+_[0-9]+_/' <<<"$old")
    new=$(grep -E " t $pattern\$" <<<"$system_map" | cut -d' ' -f3 || true)
    [[ $(wc -w <<<"$new") -eq 1 ]] || { echo "want one match for $pattern in kernel $kernel_tag, got: '$new'" >&2; exit 1; }
    [[ $new == "$old" ]] && continue
    echo "$schematic: $old -> $new"
    sed -i "s/$old/$new/" "$schematic"
    changed=true
done < <(grep -oE '__initstub__kmod_[A-Za-z0-9_]+' "$schematic")
$changed || exit 0

new_id=$(curl -fsS -X POST --data-binary "@$schematic" https://factory.talos.dev/schematics | grep -oE '[0-9a-f]{64}')
echo "$config: schematic $id -> $new_id"
sed -i "s/$id/$new_id/" "$config"
