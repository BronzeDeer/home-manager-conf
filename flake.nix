{
  description = "Systemconfiguration flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixos-unstable";
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

      confAndOverlays = {
        nixpkgs = {
          config = {
            allowUnfree = true;
          };
          overlays = [
            nixgl.overlay
            (self: super: {
              # Use yet-unreleased fix for serial-no over text (https://github.com/phillipberndt/autorandr/pull/410)
              autorandr = super.autorandr.overrideAttrs (old: {
                version = "daf874efc80b6078ca96bf0b41ea09761a6afd85";
                src = super.fetchFromGitHub {
                  owner = "phillipberndt";
                  repo = "autorandr";
                  rev = "daf874efc80b6078ca96bf0b41ea09761a6afd85";
                  hash = "sha256-16agdh9dA5nyxWT+xcXiczvm6QxvS7jQBM3LPP+ucj4=";
                };
              });
              zsh-nix-shell = super.zsh-nix-shell.overrideAttrs (old: {
                version = "pr-44";
                src = super.fetchFromGitHub {
                  owner = "chisui";
                  repo = "zsh-nix-shell";
                  rev = "dd9b27b4b54bef0392395a8606d33a9942d0dbf6";
                  hash = "sha256-/B7TRMs5zbPW7vtkJvlAS++N0m3qY0zqCHjRPwXiXPI=";
                };
              });
              # Hacky workaround until https://github.com/NixOS/nixpkgs/pull/549732 lands in unstable
              zsh-autocomplete = super.zsh-autocomplete.overrideAttrs (old: {
                src =
                  (super.fetchFromGitHub {
                    owner = "marlonrichert";
                    repo = "zsh-autocomplete";
                    rev = old.version;
                    sha256 = "sha256-XKreHmT3vkvYWk8IbGWv9RR/V5nIohcE/ck1SPjI++U=";
                    fetchSubmodules = true;
                  }).overrideAttrs
                    (oldAttrs: {
                      env = oldAttrs.env or { } // {
                        GIT_CONFIG_COUNT = 1;
                        GIT_CONFIG_KEY_0 = "url.https://github.com/.insteadOf";
                        GIT_CONFIG_VALUE_0 = "git@github.com:";
                      };
                    });
                installPhase = old.installPhase + ''
                  cp -R z-async $out/share/zsh-autocomplete/z-async
                '';
              });
            })
          ];
        };
      };

      hmSpecialArgs = {
        inherit nixgl;
        theming = import themes/tokyonight.nix;
        inherit nix-index-database;

      };
      hmSpecialArgsNixOS = {
        home-manager.extraSpecialArgs = hmSpecialArgs;
      };

      lib = nixpkgs.lib;

    in
    {
      # TODO: Replace with multi-system config
      formatter.${system} = nixpkgs.legacyPackages.${system}.nixfmt-tree;
      nixosConfigurations = {
        nixos-workstation = lib.nixosSystem {

          modules = [
            confAndOverlays
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.joel = import ./users/personal;
            }
            hmSpecialArgsNixOS

            ./machines/workstation/configuration.nix
            ./modules/system/nvidia
            ./modules/system/cuda-support-and-cache
            ./modules/system/docker
            ./modules/system/file-manager-support
            ./modules/system/printing
            ./modules/system/nix-storage-optimisation
            ./modules/system/ausweisapp-firewall
            ./modules/system/fwupd
            ./modules/system/age-yubikey
            ./modules/system/coolercontrol
            ./modules/system/gdk-pixbuf
            ./modules/system/diff-on-activation
            ./modules/system/hyprland
            ./modules/system/makemkv
            ./modules/system/android
          ];
        };

        nixos-laptop = lib.nixosSystem {

          modules = [
            confAndOverlays
            home-manager.nixosModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.users.joel = import ./users/personal;

            }
            hmSpecialArgsNixOS

            ./machines/laptop/configuration.nix
            ./modules/system/nvidia
            ./modules/system/docker
            ./modules/system/file-manager-support
            ./modules/system/printing
            ./modules/system/nix-storage-optimisation
            ./modules/system/ausweisapp-firewall
            ./modules/system/fwupd
            ./modules/system/age-yubikey
            ./modules/system/coolercontrol
            ./modules/system/gdk-pixbuf
            ./modules/system/diff-on-activation
            ./modules/system/hyprland
            ./modules/system/android
          ];
        };
      };

      homeConfigurations.joel = home-manager.lib.homeManagerConfiguration {
        modules = [
          ./users/personal

          confAndOverlays
          {
            # When imported via the nixos module those values get set automatically based on how the host is configured
            # For the standalone version we need to specify username and home path
            home.username = "joel";
            home.homeDirectory = "/home/joel";
          }
        ];

        extraSpecialArgs = hmSpecialArgs;
      };

      homeConfigurations.jpe = home-manager.lib.homeManagerConfiguration {

        modules = [
          ./users/work
          {
            # When imported via the nixos module those values get set automatically based on how the host is configured
            # For the standalone version we need to specify username and home path
            home.username = "jpe";
            home.homeDirectory = "/home/jpe";
          }
        ];

        extraSpecialArgs = hmSpecialArgs;
      };
    };
}
