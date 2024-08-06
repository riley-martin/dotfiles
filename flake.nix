{
  description = "Nixos and Home-manager config";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    # You can access packages and modules from different nixpkgs revs
    # at the same time. Here's an working example:
    # nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    # Also see the 'unstable-packages' overlay at 'overlays/default.nix'.

    # Home manager
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # TODO: Add any other flake you might need
    # hardware.url = "github:nixos/nixos-hardware";

    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";
    # agenix.inputs.darwin.follows = "";

    snm.url = "gitlab:simple-nixos-mailserver/nixos-mailserver";
    snm.inputs.nixpkgs.follows = "nixpkgs";

    nix-snapd.url = "github:io12/nix-snapd";
    nix-snapd.inputs.nixpkgs.follows = "nixpkgs";

    ironbar.url = "github:JakeStanger/ironbar";
    ironbar.inputs.nixpkgs.follows = "nixpkgs";

    hyprland.url = "git+https://github.com/hyprwm/Hyprland?submodules=1";
    hyprland-plugins = {
      url = "github:hyprwm/hyprland-plugins";
      inputs.hyprland.follows = "hyprland";
    };
    hyprland-nix.url = "github:hyprland-community/hyprland-nix";
    hyprland-nix.inputs = {
      hyprland.follows = "hyprland";
    };

    nix-alien.url = "github:thiagokokada/nix-alien";

    gestures.url = "github:riley-martin/gestures";

    nixos-cosmic = {
      url = "github:lilyinstarlight/nixos-cosmic";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Shameless plug: looking for a way to nixify your themes and make
    # everything match nicely? Try nix-colors!
    # nix-colors.url = "github:misterio77/nix-colors";
  };

  outputs = { self, nixpkgs, snm, home-manager, agenix, nix-snapd, hyprland, hyprland-plugins, nixos-cosmic, ... }@inputs:
    let
      inherit (self) outputs;
      forAllSystems = nixpkgs.lib.genAttrs [
        # "aarch64-linux"
        # "i686-linux"
        "x86_64-linux"
        # "aarch64-darwin"
        # "x86_64-darwin"
      ];
    in rec {
      # Your custom packages
      # Acessible through 'nix build', 'nix shell', etc
      customPackages = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./pkgs { inherit pkgs; }
      );
      # Devshell for bootstrapping
      # Acessible through 'nix develop' or 'nix-shell' (legacy)
      devShells = forAllSystems (system:
        let pkgs = nixpkgs.legacyPackages.${system};
        in import ./shell.nix { inherit pkgs; }
      );

      # Your custom packages and modifications, exported as overlays
      overlays = import ./overlays { inherit inputs; };
      # Reusable nixos modules you might want to export
      # These are usually stuff you would upstream into nixpkgs
      nixosModules = import ./modules/nixos;
      # Reusable home-manager modules you might want to export
      # These are usually stuff you would upstream into home-manager
      homeManagerModules = import ./modules/home-manager;

      # NixOS configuration entrypoint
      # Available through 'nixos-rebuild --flake .#your-hostname'
      nixosConfigurations = with nixpkgs.lib; {
        denali = nixosSystem {
          # system = "x86_64";
          specialArgs = { inherit inputs outputs self agenix home-manager customPackages; system = "x86_64-linux"; };
          modules = [
            # > Our main nixos configuration file <
            ./hosts/denali/default.nix
            # (import ./hosts/denali{}).homeManagerConfiguration
            agenix.nixosModules.default
            nix-snapd.nixosModules.default
            nixos-cosmic.nixosModules.default
          ];
        };

        elias = nixosSystem {
          specialArgs = { inherit inputs outputs self agenix home-manager customPackages; system = "x86_64-linux"; };
          modules = [
            ./hosts/elias/default.nix
            agenix.nixosModules.default
          ];
        };

        foraker = nixosSystem {
          specialArgs = { inherit snm inputs outputs self agenix home-manager customPackages; system = "x86_64-linux"; };
          modules = [
            ./hosts/foraker/default.nix
            agenix.nixosModules.default
          ];
        };
      };
    };
}
