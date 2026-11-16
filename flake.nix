{
  description = "kubernetes cluster utils devshell";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    {
      self,
      nixpkgs,
      flake-utils,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = import nixpkgs {
          system = system;
          config.allowUnfree = true;
        };

        opentofu = pkgs.stdenvNoCC.mkDerivation {
          name = "opentofu";
          src = pkgs.fetchurl (
            {
              x86_64-linux = {
                url = "https://github.com/opentofu/opentofu/releases/download/v1.13.9/tofu_1.13.9_linux_amd64.zip";
                sha256 = "bc44eb6b06446ba83bd4072114891987f590f66cca712737a7f1147c50c539ce";
              };
              aarch64-linux = {
                url = "https://github.com/opentofu/opentofu/releases/download/v1.13.9/tofu_1.13.9_linux_arm64.zip";
                sha256 = "04f7c93828b859d420269ed30f923ffebf09157b5d7fb95bf8d88a4d208b7fa3";
              };
              x86_64-darwin = {
                url = "https://github.com/opentofu/opentofu/releases/download/v1.13.9/tofu_1.13.9_darwin_amd64.zip";
                sha256 = "ac5505dd19d896f327d0ab727d4b853413c694931a7602b31f93c3a3e9d46d00";
              };
              aarch64-darwin = {
                url = "https://github.com/opentofu/opentofu/releases/download/v1.13.9/tofu_1.13.9_darwin_arm64.zip";
                sha256 = "29ba2f4c78556a8d25476e5070fe4745495ef649c4a3b827170eb7436d23feb3";
              };
            }
            .${system}
          );
          nativeBuildInputs = [ pkgs.unzip ];
          sourceRoot = ".";
          installPhase = "install -Dm755 tofu $out/bin/tofu";
        };

        tofu = pkgs.writeShellApplication {
          name = "tofu";
          runtimeInputs = [
            pkgs.git
            pkgs.sops
          ];
          text = ''
            dir="$(git rev-parse --show-toplevel)/terraform"
            tfvars="$dir/terraform.sops.tfvars"
            chdir=("-chdir=$dir")
            for arg in "$@"; do
              case "$arg" in -chdir=*) chdir=() ;; esac
            done
            args=("$@")
            for i in "''${!args[@]}"; do
              case "''${args[i]}" in
                -*) ;;
                plan | apply | destroy | import | refresh | console)
                  exec ${opentofu}/bin/tofu "''${chdir[@]}" "''${args[@]:0:i+1}" -var-file=<(sops decrypt "$tfvars") "''${args[@]:i+1}"
                  ;;
                *) break ;;
              esac
            done
            exec ${opentofu}/bin/tofu "''${chdir[@]}" "$@"
          '';
        };

        talosctl = pkgs.stdenvNoCC.mkDerivation {
          name = "talosctl";
          src = pkgs.fetchurl (
            {
              x86_64-linux = {
                url = "https://github.com/siderolabs/talos/releases/download/v1.14.6/talosctl-linux-amd64";
                sha256 = "11acde7f7578ffe9cbe6fb8349b34595065f597de0842615982e350b365de987";
              };
              aarch64-linux = {
                url = "https://github.com/siderolabs/talos/releases/download/v1.14.6/talosctl-linux-arm64";
                sha256 = "fd22e0678d783105646d824c23ee45cf7a57f737edae274ca41376d03a4def65";
              };
              x86_64-darwin = {
                url = "https://github.com/siderolabs/talos/releases/download/v1.14.6/talosctl-darwin-amd64";
                sha256 = "cb460e388de00628d7d42beb6ca037603025195c05115de9ec25442a870aa1ed";
              };
              aarch64-darwin = {
                url = "https://github.com/siderolabs/talos/releases/download/v1.14.6/talosctl-darwin-arm64";
                sha256 = "dd290798702d60ce8c1f59f4c223d5bdbc9c0638db45a9827d7f6cb4bd4a3f39";
              };
            }
            .${system}
          );
          dontUnpack = true;
          installPhase = "install -Dm755 $src $out/bin/talosctl";
        };

        kubectl = pkgs.stdenvNoCC.mkDerivation {
          name = "kubectl";
          src = pkgs.fetchurl (
            {
              x86_64-linux = {
                url = "https://dl.k8s.io/release/v1.36.6/bin/linux/amd64/kubectl";
                sha256 = "29818b6729dc9262b692307470d0558d027725e738be5dd47c760261868a2634";
              };
              aarch64-linux = {
                url = "https://dl.k8s.io/release/v1.36.6/bin/linux/arm64/kubectl";
                sha256 = "35507ef408c3d38849e5d3203e18f8e861db822aa664101a9ced0869edd06046";
              };
              x86_64-darwin = {
                url = "https://dl.k8s.io/release/v1.36.6/bin/darwin/amd64/kubectl";
                sha256 = "2e22d382f2423c88d9d076246f860bb3d5c743dd279ca63e113474bb88382426";
              };
              aarch64-darwin = {
                url = "https://dl.k8s.io/release/v1.36.6/bin/darwin/arm64/kubectl";
                sha256 = "1cf735c3d35ccfec28d0618784cb06a4614d2c42aade28b6be0eab76a2ffb623";
              };
            }
            .${system}
          );
          dontUnpack = true;
          installPhase = "install -Dm755 $src $out/bin/kubectl";
        };

        deadvalues = pkgs.stdenvNoCC.mkDerivation {
          name = "deadvalues";
          src = pkgs.fetchurl (
            {
              x86_64-linux = {
                url = "https://github.com/guarnz/deadvalues/releases/download/v0.1.9/deadvalues_linux_amd64.tar.gz";
                sha256 = "1505dd03d7f5c78b3f26f5008611e0735da149193489067452ff62d7a30326e0";
              };
              aarch64-linux = {
                url = "https://github.com/guarnz/deadvalues/releases/download/v0.1.9/deadvalues_linux_arm64.tar.gz";
                sha256 = "24bb2ec63fec652eadb350fa2313081f590bf49e117114e125cbe5be411aee9c";
              };
              x86_64-darwin = {
                url = "https://github.com/guarnz/deadvalues/releases/download/v0.1.9/deadvalues_darwin_amd64.tar.gz";
                sha256 = "6aa8913160161da1a0e6683f0d7bd47c2b6e8e21cca9f21b33ef8022e3c86450";
              };
              aarch64-darwin = {
                url = "https://github.com/guarnz/deadvalues/releases/download/v0.1.9/deadvalues_darwin_arm64.tar.gz";
                sha256 = "b2de8a2658b84eb8491e9d857a046a9a1b0562a353e28d4e4ea2377bf164cf57";
              };
            }
            .${system}
          );
          sourceRoot = ".";
          installPhase = "install -Dm755 deadvalues $out/bin/deadvalues";
        };
      in
      {
        formatter = pkgs.nixfmt;

        # for CI
        packages.opentofu = opentofu;
        packages.tflint = pkgs.tflint;

        devShells.default = pkgs.mkShell {
          env = {
            TF_CLI_ARGS_plan = "-parallelism=1";
            TF_CLI_ARGS_apply = "-parallelism=1";
          };

          buildInputs = with pkgs; [
            actionlint
            age
            awscli2
            bws # bitwarden cli
            cilium-cli
            cmctl # cert-manager
            deadvalues
            fluxcd
            hubble
            jq
            just
            kopia
            kube-linter
            kubecolor
            kubectl
            kubectl-cnpg
            kubectl-df-pv
            kubectl-doctor
            kubectl-example
            kubectl-neat
            kubectl-node-shell
            kubectl-view-secret
            kubectl-tree
            kubernetes-helm
            kustomize
            tflint
            tofu
            sops
            talosctl
            yq-go
          ];
        };
      }
    );
}
