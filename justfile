set shell := ["bash", "-euo", "pipefail", "-c"]

talos_dir := "talos"

default:
    @just --list

# Show what `apply` would change on a node without applying it
[group('talos')]
diff node:
    @just apply {{ node }} --dry-run

# Apply machine config to one node, e.g. `just apply worker-6` (extra args go to talosctl)
[group('talos')]
apply node *args:
    #!/usr/bin/env bash
    set -euo pipefail
    node="{{ node }}"
    role="${node%-*}"
    base="{{ talos_dir }}/$role.sops.yaml"
    patch="{{ talos_dir }}/$node-patch.yaml"
    [[ -f $base && -f $patch ]] || { echo "no config for $node (want $base + $patch)" >&2; exit 1; }
    # decrypt up front so a sops failure aborts instead of feeding talosctl an empty file
    config="$(sops -d "$base")"
    echo "== $node"
    talosctl -n "$node" apply-config --file <(printf '%s\n' "$config") --config-patch "@$patch" {{ args }}

# Apply to every node of a role one at a time, waiting for each to be Ready, e.g. `just apply-role worker`
[group('talos')]
apply-role role *args:
    #!/usr/bin/env bash
    set -euo pipefail
    for patch in {{ talos_dir }}/{{ role }}-*-patch.yaml; do
      node="$(basename "$patch" -patch.yaml)"
      just _ceph-wait
      just apply "$node" {{ args }}
      # give kubelet/reboot a moment to flip the node NotReady before gating on Ready
      sleep 10
      kubectl wait --for=condition=Ready "node/$node" --timeout=10m
    done

# Upgrade Talos on one node to the installer image in its config, e.g. `just upgrade worker-6` (extra args go to talosctl)
[group('talos')]
upgrade node *args:
    #!/usr/bin/env bash
    set -euo pipefail
    node="{{ node }}"
    role="${node%-*}"
    base="{{ talos_dir }}/$role.sops.yaml"
    patch="{{ talos_dir }}/$node-patch.yaml"
    [[ -f $base && -f $patch ]] || { echo "no config for $node (want $base + $patch)" >&2; exit 1; }
    config="$(sops -d "$base")"
    # talosctl defaults to the vanilla installer, which would drop the factory schematic's extensions
    image="$(talosctl machineconfig patch <(printf '%s\n' "$config") --patch "@$patch" -o /dev/stdout \
      | awk '/^ *install:$/ { found = 1 } found && /^ *image:/ { print $2; exit }')"
    [[ -n $image ]] || { echo "no install image in config for $node" >&2; exit 1; }
    echo "== $node -> $image"
    talosctl -n "$node" upgrade --image "$image" {{ args }}

# Upgrade every node of a role one at a time, waiting for each to be Ready, e.g. `just upgrade-role worker`
[group('talos')]
upgrade-role role *args:
    #!/usr/bin/env bash
    set -euo pipefail
    for patch in {{ talos_dir }}/{{ role }}-*-patch.yaml; do
      node="$(basename "$patch" -patch.yaml)"
      just _ceph-wait
      just upgrade "$node" {{ args }}
      kubectl wait --for=condition=Ready "node/$node" --timeout=10m
    done

# Block until every mon is in quorum, every in OSD is up and every PG is active+clean, so a
# rolling apply/upgrade never takes down a node while Ceph is still recovering from the last one
_ceph-wait:
    #!/usr/bin/env bash
    set -euo pipefail
    deadline=$((SECONDS + 1200))
    until kubectl -n rook-ceph exec deploy/rook-ceph-tools -- ceph status -f json 2>/dev/null | jq -e '
        (.quorum_names | length) == .monmap.num_mons
        and .osdmap.num_up_osds == .osdmap.num_in_osds
        and ([.pgmap.pgs_by_state[] | select(.state_name | startswith("active+clean")) | .count] | add) == .pgmap.num_pgs
      ' >/dev/null; do
      (( SECONDS < deadline )) || { echo "ceph still not settled after 20m, aborting" >&2; exit 1; }
      (( ${waited:-0} )) || { echo "waiting for ceph to settle..."; waited=1; }
      sleep 15
    done
