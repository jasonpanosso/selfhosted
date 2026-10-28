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
            version = "1.13.12";
            platforms = {
              x86_64-linux = { os = "linux-amd64"; sha256 = "4ce4218764c24d6a6bd561097199b60ed8619db073792fce5b7cfce7fa8d12fc"; };
              aarch64-linux = { os = "linux-arm64"; sha256 = "35c304c378d70f241ec5d63612defde25305f8108e550256aa63f37da510b6be"; };
              x86_64-darwin = { os = "darwin-amd64"; sha256 = "54247a7f93e29e8ef81c31711645d573319e49586534aef695cf4fcfcd182353"; };
              aarch64-darwin = { os = "darwin-arm64"; sha256 = "90e392866168081897325ff1eeceec10a85476a9bc9eb4399fe741a8d7f7893d"; };
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
