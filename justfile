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
      just apply "$node" {{ args }}
      # give kubelet/reboot a moment to flip the node NotReady before gating on Ready
      sleep 10
      kubectl wait --for=condition=Ready "node/$node" --timeout=10m
    done
