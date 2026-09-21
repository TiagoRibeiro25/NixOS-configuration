{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-cachyos-kernel.url =
      "github:xddxdd/nix-cachyos-kernel/release";

    sls-steam = {
      url = "github:AceSLS/SLSsteam";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };

  outputs = { self, nixpkgs, nix-cachyos-kernel, sls-steam, spicetify-nix, ... }:
    {
      nixosConfigurations.my-nixos =
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = {
            inherit sls-steam spicetify-nix;
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
