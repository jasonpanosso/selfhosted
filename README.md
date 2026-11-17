# selfhosted cluster

## upgrading talos

1. update the installer images in talos/nodes (renovate should handle this)

2. sanity check a few diffs:
```sh
just diff controlplane-1
just diff worker-5
```

3. upgrade, then apply so the node configs match git:
```sh
just upgrade-role controlplane
just upgrade-role worker
just apply-role controlplane
just apply-role worker
```

## upgrading kubernetes

1. update the kubernetes images in talos/common.yaml and talos/controlplane.yaml (renovate should handle this):

2. dry run, then upgrade (don't `just apply` before this, it'd skip upgrade-k8s's checks):
```sh
just upgrade-k8s --dry-run
just upgrade-k8s
```

3. git and the cluster should now match:
```sh
just diff controlplane-1
just diff worker-5
```

4. run apply-role
```sh
just apply-role controlplane
just apply-role worker
```
