{
  description = "My NixOS configuration - GUI configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    systems = {
      url = "github:nix-systems/x86_64-linux";
    };

    niri-flake = {
      url = "github:sodiboo/niri-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    {
      nixpkgs,
      flake-parts,
      systems,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:
      {
        imports = [ ];
        systems = import systems;
        flake = {
          homeModules.gui =
            { ... }:
            {
              imports = [
                inputs.niri-flake.homeModules.niri

                ./wm.nix
              ];

              config = {
                xdg.portal.enable = true;
              };
            };
        };
      }
    );
}
