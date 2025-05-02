{
  description = "Systemconfiguration flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Helper wrapper to fix OpenGL kerfuffle when running glx apps on non-nixos
    nixgl.url = "github:nix-community/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";

    nix-index-database.url = "github:nix-community/nix-index-database";
    nix-index-database.inputs.nixpkgs.follows = "nixpkgs";

  };

  outputs =
    {
      self,
      nixpkgs,
      home-manager,
      nixgl,
      nix-index-database,
    }:
    let
      system = "x86_64-linux";

      pkgs = import nixpkgs {
        inherit system;
        config = {
          allowUnfree = true;
        };
        overlays = [
          nixgl.overlay
          (self: super: {
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
            picom = super.picom.overrideAttrs (old: {
              # Temporary fix for #1398
              version = "v12";
              src = super.fetchFromGitHub {
                owner = "yshui";
                repo = "picom";
                rev = "0f3784f3069d9f949af3cd43d1d34b170adf6b4d"; # PR#1415
                hash = "sha256-VRL82w+e2yIBP1tFO4XbmqnqVU8gFgMXo68WuVV7ix0=";
              };
            });
          })
        ];
      };

      lib = nixpkgs.lib;

    in
    {
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
      nixosConfigurations = {
        nixos-workstation = lib.nixosSystem {
          inherit system;
          inherit pkgs;

          modules = [
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.joel = import ./users/personal;

              home-manager.extraSpecialArgs = {
                inherit nixgl;
                theming = import themes/tokyonight.nix {
                  inherit pkgs;
                };
                inherit nix-index-database;

              };
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
            ./modules/system/gdk-pixbuf
          ];
        };
      };
      homeConfigurations.joel = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./users/personal
          {
            # When imported via the nixos module those values get set automatically based on how the host is configured
            # For the standalone version we need to specify username and home path
            home.username = "joel";
            home.homeDirectory = "/home/joel";
          }
        ];

        extraSpecialArgs = {
          inherit nixgl;
          theming = import themes/tokyonight.nix {
            inherit pkgs;
          };
        };
      };

      homeConfigurations.jpe = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          ./users/work
          {
            # When imported via the nixos module those values get set automatically based on how the host is configured
            # For the standalone version we need to specify username and home path
            home.username = "jpe";
            home.homeDirectory = "/home/jpe";
          }
        ];

        extraSpecialArgs = {
          inherit nixgl;
          theming = import themes/tokyonight.nix {
            inherit pkgs;
          };
          inherit nix-index-database;
        };
      };
    };
}
