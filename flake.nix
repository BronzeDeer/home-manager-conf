{
  description = "Systemconfiguration flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs{
      inherit system;
      config = { allowUnfree = true; };
    };

   lib = nixpkgs.lib;

  in {
    nixosConfigurations = {
      nixos-workstation = lib.nixosSystem {
        inherit system;

        modules = [
          ./machines/workstation/configuration.nix
        ];
      };
    };
    homeConfigurations.joel = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        ./home.nix
        ./modules/user/kubernetes
        ./modules/user/xmonad
        ./modules/user/picom
        ./modules/user/social
        ./modules/user/gtk
        ./modules/user/kitty
        ./modules/user/betterlockscreen
      ];

      extraSpecialArgs = { theming = import themes/tokyonight.nix; };
    };
  };
}
