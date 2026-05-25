{
  description = "My NixOS configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs";

    # Flake organizing tool; reused in many flakes
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };

    # The so-called "system pattern";
    # detail at https://github.com/nix-systems/nix-systems
    systems = {
      # No other systems or architectures are necessary.
      url = "github:nix-systems/x86_64-linux";
    };

    # Disk management
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Power management
    watt = {
      url = "github:NotAShelf/watt";
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
    # Normal flake-parts structure;
    # see their documents for detail.
    flake-parts.lib.mkFlake { inherit inputs; } (
      { ... }:
      {
        imports = [ ];
        flake = {
          nixosConfigurations.laptop = nixpkgs.lib.nixosSystem {
            system = "x86_64-linux";
            specialArgs = {
              inherit inputs;
            };
            modules = [
              ./hosts/laptop.nix
            ];
          };
        };
        perSystem =
          { pkgs, ... }:
          {
            # Development environment; loaded by direnv
            devShells.default = pkgs.mkShell {
              packages = with pkgs; [
                nil # Nix LSP
              ];
            };
            formatter = pkgs.nixfmt-tree;
          };
        systems = import systems;
      }
    );
}
