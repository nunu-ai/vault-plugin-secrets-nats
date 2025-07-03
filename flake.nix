{
  description = "Dev environment for vault-plugin-secrets-nats";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    pre-commit-hooks.url = "github:cachix/pre-commit-hooks.nix";
  };

  outputs = { nixpkgs, pre-commit-hooks, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    in {
      packages = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in {
          default = pkgs.buildGoModule {
            pname = "vault-plugin-secrets-nats";
            version = "1.7.0";
            src = ./.;
            vendorHash = null;
            ldflags = [ "-s" "-w" ];

            # Optional: specify the main package if it's not in the root
            # subPackages = [ "cmd/vault-plugin-secrets-nats" ];
          };
        });

      devShells = forAllSystems (system:
        let
          pkgs = import nixpkgs {
            inherit system;
            config.allowUnfree = true;
          };
        in {
          default = pkgs.mkShell {
            packages = with pkgs; [
              go
              vault
              docker
              gnumake
              just
              pre-commit
            ];

            shellHook = ''
              export VAULT_ADDR='http://127.0.0.1:8200'
              export VAULT_TOKEN='root'
            '';
          };
        });
    };
}
