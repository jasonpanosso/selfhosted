call_recipe := just_executable() + " --justfile=" + justfile()

up:
  #!/usr/bin/env bash

  set -o errexit

  docker-compose up -d

  {{call_recipe}} push

  helm -n flux-system upgrade \
    --install flux-operator oci://ghcr.io/controlplaneio-fluxcd/charts/flux-operator \
    --create-namespace \
    --wait

  cat <<EOF | helm -n flux-system upgrade --install flux oci://ghcr.io/controlplaneio-fluxcd/charts/flux-instance --values -
  instance:
    componentspub:
      - source-controller
      - kustomize-controller
      - helm-controller
      - notification-controller
    sync:
      kind: OCIRepository
      url: oci://192.168.121.1:5000/flux-cluster-sync
      ref: local
      path: ./
    kustomize:
      patches:
        - target:
            kind: OCIRepository
          patch: |
            - op: add
              path: /spec/insecure
              value: true
        - target:
            kind: Deployment
            name: "(kustomize-controller|helm-controller)"
          patch: |
            - op: add
              path: /spec/template/spec/containers/0/args/-
              value: --concurrent=10
            - op: add
              path: /spec/template/spec/containers/0/args/-
              value: --requeue-dependency=5s
  EOF

  echo "Waiting for Flux controllers to be ready"
  kubectl -n flux-system wait --for=condition=Ready fluxinstance/flux --timeout=5m
  flux check
  echo "✔ Flux is ready"

  echo "Waiting for cluster addons sync to complete"
  kubectl -n flux-system wait --for=condition=Ready kustomization/infra-controllers --timeout=5m
  flux tree kustomization infra-controllers

  echo "Waiting for apps sync to complete"
  kubectl -n flux-system wait --for=condition=Ready kustomization/apps-sync --timeout=5m
  flux tree kustomization apps-sync

  echo "✔ Cluster is ready"

diff_push arg1 arg2:
  #!/usr/bin/env bash

  artifact_name={{arg1}}
  artifact_path={{arg2}}

  flux diff artifact oci://${artifact_name} \
    --path="${artifact_path}" &>/dev/null || diff_exit_code=$?

  if [[  ${diff_exit_code} -ne 0 ]]; then
    flux_output=$(flux push artifact oci://${artifact_name} \
      --path="${artifact_path}" \
      --source="$(git config --get remote.origin.url)" \
      --revision="$(git rev-parse HEAD)" 2>&1) || exit_code=$?

     oci_url=$(echo ${flux_output} | tail -n1 | awk '/to/{print $NF}')
  else
    echo "✔ no changes detected in ${artifact_path}"
    exit 0
  fi

  if [[  ${exit_code} -ne 0 ]]; then
    echo ${flux_output}
    exit 1
  fi

  echo "✔ pushed to ${oci_url}"

push:
  #!/usr/bin/env bash

  set -o errexit

  registry='localhost:5000'

  {{call_recipe}} diff_push "${registry}/flux-cluster-sync:local" "clusters/local"
  {{call_recipe}} diff_push "${registry}/flux-infra-sync:local" "infra"
  {{call_recipe}} diff_push "${registry}/flux-apps-sync:local" "apps"

  helm package charts/lldap
  helm push lldap-*.tgz "oci://${registry}/flux-charts"
  rm lldap-*.tgz

sync:
  #!/usr/bin/env bash

  set -o errexit

  echo "Waiting for cluster addons sync to complete"
  flux reconcile kustomization infra-controllers --with-source

  echo "Waiting for apps sync to complete"
  flux reconcile kustomization apps-sync --with-source
  flux tree kustomization apps-sync

  echo "✔ Cluster is in sync"
