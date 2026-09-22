{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    # Used for accela and samrewritten
    nix-tools-steam = {
      url = "github:HANDZCZ/nix-tools-steam";
      inputs.nixpkgs.follows = "nixpkgs";
    };

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
    sls-steam,
    spicetify-nix,
    ...
  }:
    {
      nixosConfigurations.my-nixos =
        nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          specialArgs = {
            inherit nix-tools-steam sls-steam spicetify-nix;
          };

          modules = [
            ./configuration.nix
          ];
        };
    };
}
