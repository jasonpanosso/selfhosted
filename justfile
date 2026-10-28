set shell := ["bash", "-euo", "pipefail", "-c"]

talos_dir := "talos"
# optional: Talos version whose defaults `gen config` generates, e.g. `just talos_version=v1.13 diff worker-3`;
# empty uses the defaults of the talosctl pinned in flake.nix
talos_version := ""

default:
    @just --list

# Show what `apply` would change on a node without applying it
[group('talos')]
diff node:
    @just talos_version="{{ talos_version }}" apply {{ node }} --dry-run

# Apply machine config to one node, e.g. `just apply worker-6` (extra args go to talosctl)
[group('talos')]
apply node *args:
    #!/usr/bin/env bash
    set -euo pipefail
    node="{{ node }}"
    # render up front so a failure aborts instead of feeding talosctl an empty file
    config="$(just talos_version="{{ talos_version }}" _render "$node")"
    echo "== $node"
    talosctl -n "$node" apply-config --file <(printf '%s\n' "$config") {{ args }}

# Apply to every node of a role one at a time, waiting for each to be Ready, e.g. `just apply-role worker`
[group('talos')]
apply-role role *args:
    #!/usr/bin/env bash
    set -euo pipefail
    for file in {{ talos_dir }}/nodes/{{ role }}/*.yaml; do
      node="$(basename "$file" .yaml)"
      just _ceph-wait
      just talos_version="{{ talos_version }}" apply "$node" {{ args }}
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
    config="$(just talos_version="{{ talos_version }}" _render "$node")"
    # talosctl defaults to the vanilla installer, which would drop the factory schematic's extensions
    image="$(printf '%s\n' "$config" | yq 'select(document_index == 0) | .machine.install.image')"
    [[ -n $image && $image != null ]] || { echo "no install image in config for $node" >&2; exit 1; }
    echo "== $node -> $image"
    talosctl -n "$node" upgrade --image "$image" {{ args }}

# Upgrade every node of a role one at a time, waiting for each to be Ready, e.g. `just upgrade-role worker`
[group('talos')]
upgrade-role role *args:
    #!/usr/bin/env bash
    set -euo pipefail
    for file in {{ talos_dir }}/nodes/{{ role }}/*.yaml; do
      node="$(basename "$file" .yaml)"
      just _ceph-wait
      just talos_version="{{ talos_version }}" upgrade "$node" {{ args }}
      kubectl wait --for=condition=Ready "node/$node" --timeout=10m
    done

# Upgrade Kubernetes to the version pinned in the patches (extra args go to talosctl, e.g. --dry-run)
[group('talos')]
upgrade-k8s *args:
    #!/usr/bin/env bash
    set -euo pipefail
    version="$(just _kubernetes-version)"
    echo "== kubernetes -> $version"
    talosctl -n controlplane-1 upgrade-k8s --to "${version#v}" {{ args }}

# Render a node's machine config: `talosctl gen config` from the secrets bundle and role patches,
# then the node's own patch on top
_render node:
    #!/usr/bin/env bash
    set -euo pipefail
    node="{{ node }}"
    # the node's directory under nodes/ is its role
    files=({{ talos_dir }}/nodes/*/"$node".yaml)
    [[ ${#files[@]} -eq 1 && -f ${files[0]} ]] || { echo "no config for $node (want {{ talos_dir }}/nodes/<role>/$node.yaml)" >&2; exit 1; }
    patch="${files[0]}"
    role="$(basename "$(dirname "$patch")")"
    [[ $role == controlplane || $role == worker ]] || { echo "unknown role '$role' for $node ($patch)" >&2; exit 1; }
    # without one, gen config falls back to the plain installer and the node would lose its extensions
    yq -e 'select(document_index == 0) | .machine.install.image' "$patch" >/dev/null 2>&1 \
      || { echo "$patch must set machine.install.image" >&2; exit 1; }
    # a gpg passphrase prompt during `sops -d` can leave the terminal without newline translation
    # (staircased output); put it back however we exit
    if [[ -t 0 ]]; then tty_state="$(stty -g)"; trap 'stty "$tty_state"' EXIT; fi
    # gen config takes these as arguments; they're kept in common.yaml like any other field
    cluster_name="$(yq -e 'select(document_index == 0) | .cluster.clusterName' "{{ talos_dir }}/common.yaml")"
    endpoint="$(yq -e 'select(document_index == 0) | .cluster.controlPlane.endpoint' "{{ talos_dir }}/common.yaml")"
    kubernetes_version="$(just _kubernetes-version)"
    # decrypt up front so a sops failure aborts instead of feeding talosctl an empty file
    secrets="$(sops -d {{ talos_dir }}/secrets/secrets.sops.yaml)"
    talos_version_flag=()
    [[ -z "{{ talos_version }}" ]] || talos_version_flag=(--talos-version "{{ talos_version }}")
    # remove-persist must come after common.yaml, which deletes HostnameConfig: JSON patches only
    # work while the config is a single document
    base="$(talosctl gen config "$cluster_name" "$endpoint" \
      --with-secrets <(printf '%s\n' "$secrets") \
      "${talos_version_flag[@]}" --kubernetes-version "${kubernetes_version#v}" \
      --config-patch "@{{ talos_dir }}/common.yaml" \
      --config-patch "@{{ talos_dir }}/remove-persist.json" \
      --config-patch-control-plane "@{{ talos_dir }}/controlplane.yaml" \
      --config-patch-worker "@{{ talos_dir }}/worker.yaml" \
      --output-types "$role" -o - 2> >(grep -v '^generating PKI and tokens$' >&2))"
    talosctl machineconfig patch <(printf '%s\n' "$base") --patch "@$patch" -o /dev/stdout

# Print the Kubernetes version pinned in the patches, refusing if the pinned images disagree
_kubernetes-version:
    #!/usr/bin/env bash
    set -euo pipefail
    images="$(yq 'select(document_index == 0) | .machine.kubelet.image' "{{ talos_dir }}/common.yaml"
      yq 'select(document_index == 0) | (.cluster.apiServer.image, .cluster.controllerManager.image, .cluster.scheduler.image, .cluster.proxy.image)' "{{ talos_dir }}/controlplane.yaml")"
    versions="$(printf '%s\n' "$images" | sed 's/.*://' | sort -u)"
    [[ $(printf '%s\n' "$versions" | wc -l) -eq 1 && $versions != null ]] || { printf 'Kubernetes images in %s disagree:\n%s\n' "{{ talos_dir }}" "$images" >&2; exit 1; }
    echo "$versions"

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
