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
                url = "https://github.com/opentofu/opentofu/releases/download/v1.13.2/tofu_1.13.2_linux_amd64.zip";
                sha256 = "723bebb0df8411daff1e5fc3862e28ff5581fe5634087f4c29a9aa41d78208b5";
              };
              aarch64-linux = {
                url = "https://github.com/opentofu/opentofu/releases/download/v1.13.2/tofu_1.13.2_linux_arm64.zip";
                sha256 = "6e815c58a09ee957de606ff48cefad082942e70afc43b737ff975654c54ec453";
              };
              x86_64-darwin = {
                url = "https://github.com/opentofu/opentofu/releases/download/v1.13.2/tofu_1.13.2_darwin_amd64.zip";
                sha256 = "2093d0f881d911eb133cf51d2d7e09f22da71b1e6465c60826a314d217b0b84e";
              };
              aarch64-darwin = {
                url = "https://github.com/opentofu/opentofu/releases/download/v1.13.2/tofu_1.13.2_darwin_arm64.zip";
                sha256 = "cb46112c095f1c4da721b6a18c8368f67341896a62205d1c117299e85993af61";
              };
            }
            .${system}
          );
          nativeBuildInputs = [ pkgs.unzip ];
          sourceRoot = ".";
          installPhase = "install -Dm755 tofu $out/bin/tofu";
        };

        # tofu that passes terraform.sops.tfvars to commands taking -var-file,
        # decrypted into a pipe so plaintext never hits disk
        tofu = pkgs.writeShellApplication {
          name = "tofu";
          runtimeInputs = [
            pkgs.git
            pkgs.sops
          ];
          text = ''
            dir="$(git rev-parse --show-toplevel)/terraform"
            tfvars="$dir/terraform.sops.tfvars"
            # run against terraform/ from anywhere, unless -chdir is given
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
                url = "https://github.com/siderolabs/talos/releases/download/v1.14.5/talosctl-linux-amd64";
                sha256 = "ff432b68986709e6b69c563a08a2ced4232d5196b0dccd6d2e783e9d714d7d7d";
              };
              aarch64-linux = {
                url = "https://github.com/siderolabs/talos/releases/download/v1.14.5/talosctl-linux-arm64";
                sha256 = "dfd3aa33c3159810e216fc39afb685d4d120c8f2728e017d8c7f7635d3139382";
              };
              x86_64-darwin = {
                url = "https://github.com/siderolabs/talos/releases/download/v1.14.5/talosctl-darwin-amd64";
                sha256 = "cf994f2f9b3b24941f331124bade278eb6bd84e9f2c2b1bb0cfb5f7cb49db13c";
              };
              aarch64-darwin = {
                url = "https://github.com/siderolabs/talos/releases/download/v1.14.5/talosctl-darwin-arm64";
                sha256 = "c865077bdfc99c38d70b377708682eec1a8febab987f0623206e7139d9013096";
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
                url = "https://dl.k8s.io/release/v1.37.2/bin/linux/amd64/kubectl";
                sha256 = "c04487523e7aa7d1493f7808174c899db93d7a9cf57531420cd76b9bd415f8f4";
              };
              aarch64-linux = {
                url = "https://dl.k8s.io/release/v1.37.2/bin/linux/arm64/kubectl";
                sha256 = "fcc16f63186659d9722014b7e02d5fdd2d4e669cb8c0ab66365d7d3b8ba03509";
              };
              x86_64-darwin = {
                url = "https://dl.k8s.io/release/v1.37.2/bin/darwin/amd64/kubectl";
                sha256 = "88379aff5c8111de6be0a394adffba2819e44cde269f3ab23cef76de1a48eaa8";
              };
              aarch64-darwin = {
                url = "https://dl.k8s.io/release/v1.37.2/bin/darwin/arm64/kubectl";
                sha256 = "55701af0d51815ee335f240e48acf0959c3c23017ed3fa816e880c4a92bae581";
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
        # `nix fmt flake.nix`; also run on Renovate PRs by .github/workflows/nixfmt.yaml
        formatter = pkgs.nixfmt;

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
            kube-linter
            kustomize
            tofu
            sops
            talosctl
            yq-go
          ];
        };
      }
    );
}
