{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    systems = {
      url = "github:nix-systems/default";
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
          homeModules.qb114514 =
            { pkgs, ... }:
            {
              imports = [ (import ./qb114514.nix { inherit inputs; }) ];
            };
        };
      }
    );
}
