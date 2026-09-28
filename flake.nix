{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Used for accela and samrewritten
    nix-tools-steam = {
      url = "github:HANDZCZ/nix-tools-steam";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    nix-tools-steam,
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
            inherit nix-tools-steam rivalcfg-gui sls-steam spicetify-nix;
          };

          modules = [
            ./configuration.nix

            rivalcfg-gui.nixosModules.default
          ];
        };
    };
}
