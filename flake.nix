{
  description = "kubernetes cluster utils devshell";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1"; # unstable
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          system = system;
          config.allowUnfree = true;
        };

        opentofu =
          let
            version = "1.13.2";
            platforms = {
              x86_64-linux = { os = "linux_amd64"; sha256 = "723bebb0df8411daff1e5fc3862e28ff5581fe5634087f4c29a9aa41d78208b5"; };
              aarch64-linux = { os = "linux_arm64"; sha256 = "6e815c58a09ee957de606ff48cefad082942e70afc43b737ff975654c54ec453"; };
              x86_64-darwin = { os = "darwin_amd64"; sha256 = "2093d0f881d911eb133cf51d2d7e09f22da71b1e6465c60826a314d217b0b84e"; };
              aarch64-darwin = { os = "darwin_arm64"; sha256 = "cb46112c095f1c4da721b6a18c8368f67341896a62205d1c117299e85993af61"; };
            };
            platform = platforms.${system};
          in
          pkgs.stdenvNoCC.mkDerivation {
            pname = "opentofu";
            inherit version;
            src = pkgs.fetchurl {
              url = "https://github.com/opentofu/opentofu/releases/download/v${version}/tofu_${version}_${platform.os}.zip";
              inherit (platform) sha256;
            };
            nativeBuildInputs = [ pkgs.unzip ];
            sourceRoot = ".";
            installPhase = "install -Dm755 tofu $out/bin/tofu";
          };

        talosctl =
          let
            version = "1.14.5";
            platforms = {
              x86_64-linux = { os = "linux-amd64"; sha256 = "ff432b68986709e6b69c563a08a2ced4232d5196b0dccd6d2e783e9d714d7d7d"; };
              aarch64-linux = { os = "linux-arm64"; sha256 = "dfd3aa33c3159810e216fc39afb685d4d120c8f2728e017d8c7f7635d3139382"; };
              x86_64-darwin = { os = "darwin-amd64"; sha256 = "cf994f2f9b3b24941f331124bade278eb6bd84e9f2c2b1bb0cfb5f7cb49db13c"; };
              aarch64-darwin = { os = "darwin-arm64"; sha256 = "c865077bdfc99c38d70b377708682eec1a8febab987f0623206e7139d9013096"; };
            };
            platform = platforms.${system};
          in
          pkgs.stdenvNoCC.mkDerivation {
            pname = "talosctl";
            inherit version;
            src = pkgs.fetchurl {
              url = "https://github.com/siderolabs/talos/releases/download/v${version}/talosctl-${platform.os}";
              inherit (platform) sha256;
            };
            dontUnpack = true;
            installPhase = "install -Dm755 $src $out/bin/talosctl";
          };

        kubectl =
          let
            version = "1.36.6";
            platforms = {
              x86_64-linux = { os = "linux/amd64"; sha256 = "29818b6729dc9262b692307470d0558d027725e738be5dd47c760261868a2634"; };
              aarch64-linux = { os = "linux/arm64"; sha256 = "35507ef408c3d38849e5d3203e18f8e861db822aa664101a9ced0869edd06046"; };
              x86_64-darwin = { os = "darwin/amd64"; sha256 = "2e22d382f2423c88d9d076246f860bb3d5c743dd279ca63e113474bb88382426"; };
              aarch64-darwin = { os = "darwin/arm64"; sha256 = "1cf735c3d35ccfec28d0618784cb06a4614d2c42aade28b6be0eab76a2ffb623"; };
            };
            platform = platforms.${system};
          in
          pkgs.stdenvNoCC.mkDerivation {
            pname = "kubectl";
            inherit version;
            src = pkgs.fetchurl {
              url = "https://dl.k8s.io/release/v${version}/bin/${platform.os}/kubectl";
              inherit (platform) sha256;
            };
            dontUnpack = true;
            installPhase = "install -Dm755 $src $out/bin/kubectl";
          };
      in
      {
        devShells.default = pkgs.mkShell {
          env = {
            TF_CLI_ARGS_plan = "-parallelism=2";
            TF_CLI_ARGS_apply = "-parallelism=2";
          };

          buildInputs = with pkgs; [
            actionlint
            age
            awscli2
            bws # bitwarden cli
            cilium-cli
            cmctl # cert-manager
            fluxcd
            jq
            just
            kopia
            kubectl
            kubernetes-helm
            kube-linter
            kustomize
            opentofu
            sops
            talosctl
            yq-go
          ];
        };
      });
}
