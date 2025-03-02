{
  description = "Systemconfiguration flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Helper wrapper to fix OpenGL kerfuffle when running glx apps on non-nixos
    nixgl.url = "github:nix-community/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";



  };

  outputs = { self, nixpkgs, home-manager, nixgl }:
  let
    system = "x86_64-linux";

    pkgs = import nixpkgs{
      inherit system;
      config = { allowUnfree = true; };
      overlays = [
        nixgl.overlay
        (self: super : {
        # Use yet-unmerged fix for serial-no over text (https://github.com/phillipberndt/autorandr/pull/410)
        autorandr = super.autorandr.overrideAttrs (old: {
          version = "daf874efc80b6078ca96bf0b41ea09761a6afd85";
          src = super.fetchFromGitHub {
            owner = "phillipberndt";
            repo = "autorandr";
            rev = "daf874efc80b6078ca96bf0b41ea09761a6afd85";
            hash = "sha256-16agdh9dA5nyxWT+xcXiczvm6QxvS7jQBM3LPP+ucj4=";
          };
        });
      })
      ];
    };

   lib = nixpkgs.lib;

  in {
    nixosConfigurations = {
      nixos-workstation = lib.nixosSystem {
        inherit system;
        inherit pkgs;

        modules = [
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.joel = import ./users/joel;

            home-manager.extraSpecialArgs = {
              inherit nixgl;
              theming = import themes/tokyonight.nix {
                inherit pkgs;
            }; };
          }

          ./machines/workstation/configuration.nix
          ./modules/system/nvidia
          ./modules/system/docker
          ./modules/system/file-manager-support
          # Needs to be included on system level due to optional cuda Support in nixpkgs.config
          ./modules/system/blender
          ./modules/system/printing
          ./modules/system/nix-storage-optimisation
          ./modules/system/ausweisapp-firewall
          ./modules/system/cuda-maintainers-cache
          ./modules/system/fwupd
          ./modules/system/age-yubikey
          ./modules/system/coolercontrol
        ];
      };
    };
    homeConfigurations.joel = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        ./users/joel
      ];

      extraSpecialArgs = {
        inherit nixgl;
        theming = import themes/tokyonight.nix {
          inherit pkgs;
      }; };
    };
  };
}
