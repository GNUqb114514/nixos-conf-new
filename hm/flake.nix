{
  description = "My NixOS configuration - Home Manager modules";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    systems = {
      url = "github:nix-systems/x86_64-linux";
    };

    guiConfig = {
      url = ./gui;
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-parts.follows = "flake-parts";
      inputs.systems.follows = "systems";
    };
  };

  outputs =
    {
      nixpkgs,
      flake-parts,
      systems,
      guiConfig,
      ...
    }@inputs:
    flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:
      {
        imports = [ ];
        systems = import systems;
        flake = {
          homeModules.default =
            { lib, config, ... }:
            {
              options.user.misc.chromium = with lib; {
                enable = mkEnableOption "Chromium";
              };

              config = lib.mkIf config.user.misc.chromium.enable {
                programs.chromium.enable = true;
              };

              imports = [
                guiConfig.homeModules.gui
              ];
            };
        };
      }
    );
}
