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
                url = "https://github.com/opentofu/opentofu/releases/download/v1.13.10/tofu_1.13.10_linux_amd64.zip";
                sha256 = "c1f0d6b34d8328f963d3b1ad10896fae30a6c6890596190ffef477dab991090f";
              };
              aarch64-linux = {
                url = "https://github.com/opentofu/opentofu/releases/download/v1.13.10/tofu_1.13.10_linux_arm64.zip";
                sha256 = "e8febf96590c59f40bda6a3ea152847eebea8ec5efe7a39ba1d53a979e230cb3";
              };
              x86_64-darwin = {
                url = "https://github.com/opentofu/opentofu/releases/download/v1.13.10/tofu_1.13.10_darwin_amd64.zip";
                sha256 = "a730409490e1c7e7be358d2a247be7d19406821677ebd75a24ac78bbef1f9276";
              };
              aarch64-darwin = {
                url = "https://github.com/opentofu/opentofu/releases/download/v1.13.10/tofu_1.13.10_darwin_arm64.zip";
                sha256 = "fa2f3380ed2f1735bb0527a6ee431d8656e8d301e09a969cfc6c5f2885a7b190";
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
                url = "https://dl.k8s.io/release/v1.36.7/bin/linux/amd64/kubectl";
                sha256 = "b08f96b43904747897fe569b3c51056b00ddfc67847f6db1bf9fe0c9583a2d26";
              };
              aarch64-linux = {
                url = "https://dl.k8s.io/release/v1.36.7/bin/linux/arm64/kubectl";
                sha256 = "4e83edb4cc75beae9dc7cfb42be71899d5397a7b6a2384fbe1ae163d4f544aaf";
              };
              x86_64-darwin = {
                url = "https://dl.k8s.io/release/v1.36.7/bin/darwin/amd64/kubectl";
                sha256 = "ca582ece9c1156578698c903ea6c3da015da753b3206e1274cbaa2be86d1545b";
              };
              aarch64-darwin = {
                url = "https://dl.k8s.io/release/v1.36.7/bin/darwin/arm64/kubectl";
                sha256 = "a6d4cd1d1b3806b152595637d3925f9cf349ce40e1809298829aba7670f6d4e9";
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
        packages.kubeconform = pkgs.kubeconform;
        packages.crane = pkgs.crane;

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
            crane
            deadvalues
            fluxcd
            hubble
            jq
            just
            kopia
            kube-linter
            kubecolor
            kubeconform
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
