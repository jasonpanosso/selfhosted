{
  description = "kubernetes in docker devshell flake";

  inputs.nixpkgs.url = "https://flakehub.com/f/NixOS/nixpkgs/0.1.*.tar.gz";
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs = { self, nixpkgs, flake-utils }:
    flake-utils.lib.eachDefaultSystem (system:
      let
        pkgs = import nixpkgs {
          system = system;
          config.allowUnfree = true;
        };

        vagrant-docker = pkgs.writeShellScriptBin "vagrant" ''
          docker run -it --rm \
            -e LIBVIRT_DEFAULT_URI \
            -v /var/run/libvirt/:/var/run/libvirt/ \
            -v ~/.vagrant.d:/.vagrant.d \
            -v $(realpath "''${PWD}"):''${PWD} \
            -w "''${PWD}" \
            --network host \
            vagrantlibvirt/vagrant-libvirt:latest \
              vagrant $@
        '';
      in
      {
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            age
            docker
            fluxcd
            just
            kubectl
            kubernetes-helm
            sops
            talosctl
            terraform
            vagrant-docker
          ];
        };
      });
}
