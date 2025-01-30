{
  description = "kubernetes in docker devshell flake";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          config.allowUnfree = true;
          overlays = [
            (final: prev: {
              kubernetes-helm-wrapped = prev.wrapHelm prev.kubernetes-helm {
                plugins = with prev.kubernetes-helmPlugins; [
                  helm-diff
                  helm-secrets
                ];
              };
            })
          ];
        };

        mkScript = name: text:
          let
            script = pkgs.writeShellScriptBin name text;
          in
          script;
        scripts = [
          (mkScript "k" ''kubectl "$@"'')
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            docker
            minikube
            kubectl
            terraform
            sops
            kubernetes-helm-wrapped
            helmfile-wrapped
          ] ++ scripts;
        };
      });
}
