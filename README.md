# selfhosted cluster

## upgrading talos

update the installer images in talos/nodes (renovate should handle this):
```sh
sed -i 's|\(factory\.talos\.dev/metal-installer/[0-9a-f]*\):v1\.42\.42|\1:v1.67.67|' talos/nodes/*/*.yaml
```

sanity check a few diffs:
```sh
just diff controlplane-1
just diff worker-5
```

upgrade, then apply so the node configs match git:
```sh
just upgrade-role controlplane
just upgrade-role worker
just apply-role controlplane
just apply-role worker
```

on a new minor, bump talosctl in flake.nix once every node runs it, then `just diff` to see the new defaults.

## upgrading kubernetes

update the kubernetes images in talos/common.yaml and talos/controlplane.yaml (renovate should handle this):
```sh
sed -i 's#\(ghcr\.io/siderolabs/kubelet\|registry\.k8s\.io/kube-[a-z-]*\):v1\.42\.42#\1:v1.67.67#' talos/common.yaml talos/controlplane.yaml
```

dry run, then upgrade (don't `just apply` before this, it'd skip upgrade-k8s's checks):
```sh
just upgrade-k8s --dry-run
just upgrade-k8s
```

git and the cluster should now match:
```sh
just diff controlplane-1
just diff worker-5
```
