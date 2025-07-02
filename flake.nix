{
  description = "Dev environment for vault-plugin-secrets-nats";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = { nixpkgs, ... }:
    let
      forAllSystems = nixpkgs.lib.genAttrs [ "x86_64-linux" "aarch64-linux" "x86_64-darwin" "aarch64-darwin" ];
    in {
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
            ];
            
            shellHook = ''
              export VAULT_ADDR='http://127.0.0.1:8200'
              export VAULT_TOKEN='root'
            '';
          };
        });
    };
}