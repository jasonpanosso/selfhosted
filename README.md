# selfhosted cluster

## upgrading

update image installs in the talos/*.yaml files:
```sh
# change versions
sed -i 's|\(factory\.talos\.dev/metal-installer/[0-9a-f]*\):v1\.42\.42|\1:v1.67.67|' talos/*.yaml
```

sanity check a few diffs:
```sh
just diff controlplane-1
just diff worker-5
```

apply:
```sh
just apply-role controlplane
just apply-role worker
```

upgrade:
```sh
just upgrade-role controlplane
just upgrade-role worker
```
