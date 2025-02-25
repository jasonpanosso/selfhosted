# selfhosted cluster

## local dev setup

[talos vagrant libvirt installation](https://www.talos.dev/v1.9/talos-guides/install/virtualized-platforms/vagrant-libvirt/)

```bash
# decrypt talos config files
sops --decrypt talos/local/controlplane.sops.yaml > talos/local/controlplane.yaml
sops --decrypt talos/local/worker-1.sops.yaml > talos/local/worker-1.yaml
sops --decrypt talos/local/worker-2.sops.yaml > talos/local/worker-2.yaml
sops --decrypt talos/local/worker-3.sops.yaml > talos/local/worker-3.yaml
sops --decrypt talos/local/talosconfig.sops > talos/local/talosconfig
export TALOSCONFIG=$(realpath ./talos/local/talosconfig)

vagrant up --provider=libvirt

# note ip addresses
virsh list | grep vagrant | awk '{print $2}' | xargs -t -L1 virsh domifaddr

talosctl -n CONTROL_PLANE_IP apply-config --insecure --file talos/local/controlplane.yaml
talosctl -n CONTROL_PLANE_IP bootstrap

talosctl -n WORKER_1_IP apply-config --insecure --file talos/local/worker-1.yaml
talosctl -n WORKER_2_IP apply-config --insecure --file talos/local/worker-2.yaml
talosctl -n WORKER_3_IP apply-config --insecure --file talos/local/worker-3.yaml

# with age.agekey
kubectl create ns flux-system
kubectl create secret generic sops-age --namespace=flux-system --from-file=age.agekey

# start dev oci server
docker compose up -d

just up
```
