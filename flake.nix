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
      ];
    };

   lib = nixpkgs.lib;

  in {
    nixosConfigurations = {
      nixos-workstation = lib.nixosSystem {
        inherit system;

        modules = [
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
        ];
      };
    };
    homeConfigurations.joel = home-manager.lib.homeManagerConfiguration {
      inherit pkgs;

      modules = [
        ./home.nix
        ./modules/user/nixGL
        ./modules/user/kubernetes
        ./modules/user/xmonad
        ./modules/user/picom
        ./modules/user/social
        ./modules/user/gtk
        ./modules/user/kitty
        ./modules/user/betterlockscreen
        ./modules/user/rofi
        ./modules/user/file-manager
        ./modules/user/vlc
        ./modules/user/chromium
        ./modules/user/dropbox
        ./modules/user/vscode
        ./modules/user/blugon
        ./modules/user/basic-tools
        ./modules/user/libation
        ./modules/user/auto-start
        ./modules/user/blueman-autostart
        ./modules/user/deadd
        ./modules/user/ausweisapp
        ./modules/user/keepassxc
        ./modules/user/libreoffice
        ./modules/user/gwe
        ./modules/user/xdg-portal
        ./modules/user/email
        ./modules/user/zsh
      ];

      extraSpecialArgs = { theming = import themes/tokyonight.nix; };
    };
  };
}
