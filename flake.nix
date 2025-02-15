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
        };
        mkScript = name: text:
          let
            script = pkgs.writeShellScriptBin name text;
          in
          script;

        scripts = [
          (mkScript "k" ''kubecolor "$@"'')
          (mkScript "vagrant" ''docker run -it --rm \
              -e LIBVIRT_DEFAULT_URI \
              -v /var/run/libvirt/:/var/run/libvirt/ \
              -v ~/.vagrant.d:/.vagrant.d \
              -v $(realpath "''${PWD}"):''${PWD} \
              -w "''${PWD}" \
              --network host \
              vagrantlibvirt/vagrant-libvirt:latest \
                vagrant $@
          '')
        ];
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            docker
            kubectl
            kubecolor
            terraform
            sops
            kubernetes-helm
            talosctl
            fluxcd
            just
            age
          ] ++ scripts;
        };
      });
}
