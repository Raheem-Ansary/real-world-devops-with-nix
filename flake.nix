{
  description = "Real world DevOps with Nix - enhanced, multi-platform showcase";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-utils.url = "github:numtide/flake-utils";
  };

  outputs = { self, nixpkgs, flake-utils, ... }:
    flake-utils.lib.eachSystem [
      "x86_64-linux"
      "aarch64-linux"
      "x86_64-darwin"
      "aarch64-darwin"
    ] (system:
      let
        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        isLinux = pkgs.stdenv.isLinux;

        todos = pkgs.buildGoModule {
          pname = "todos";
          version = "1.0.0";

          src = ./.;
          subPackages = [ "cmd/todos" ];

          vendorHash = "sha256-fwJTg/HqDAI12mF1u/BlnG52yaAlaIMzsILDDZuETrI=";
        };
      in
      {
        ############################
        # Dev shell (per system)
        ############################
        devShells.default = pkgs.mkShell {
          buildInputs = with pkgs; [
            go

            docker
            docker-compose

            kubectl
            kubectx
            kustomize
            helm

            terraform
            tflint

            doctl
            jq
            git
            gnumake
          ];

          shellHook = ''
            echo "[${system}] DevShell ready: Go + Docker + K8s + Terraform + Nix"
          '';
        };

        ############################
        # Packages (per system)
        ############################
        packages =
          {
            inherit todos;
            default = todos;
          }
          // (if isLinux then {
            dockerImage = pkgs.dockerTools.buildImage {
              name = "todos";
              tag = "latest";

              # Include only the compiled todos binary in /bin
              copyToRoot = pkgs.buildEnv {
                name = "todos-root";
                paths = [ todos ];
              };

              config = {
                Cmd = [ "/bin/todos" ];
                ExposedPorts."8080/tcp" = {};
              };
            };
          } else { });
      }
    );
}
