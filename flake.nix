{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    rivalcfg-gui.url = "github:TiagoRibeiro25/rivalcfg/rivalcfg-gui";

    # Official SLSsteam flake
    sls-steam = {
      url = "github:AceSLS/SLSsteam";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    spicetify-nix.url = "github:Gerg-L/spicetify-nix";
  };

  outputs = {
    self,
    nixpkgs,
    rivalcfg-gui,
    sls-steam,
    spicetify-nix,
    ...
  }:
    {
      nixosConfigurations.my-nixos =
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = {
            inherit rivalcfg-gui sls-steam spicetify-nix;
          };

          modules = [
            ./configuration.nix

            rivalcfg-gui.nixosModules.default
          ];
        };
    };
}
