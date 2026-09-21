{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-cachyos-kernel.url =
      "github:xddxdd/nix-cachyos-kernel/release";

    nix-tools-steam = {
      url = "github:HANDZCZ/nix-tools-steam";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };

  outputs = {
    self,
    nixpkgs,
    nix-cachyos-kernel,
    nix-tools-steam,
    spicetify-nix,
    ...
  }:
    {
      nixosConfigurations.my-nixos =
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = {
            inherit nix-tools-steam spicetify-nix;
          };

          modules = [
            ./configuration.nix

            {
              nixpkgs.overlays = [
                nix-cachyos-kernel.overlays.pinned
              ];
            }
          ];
        };
    };
}
