{
  description = "Systemconfiguration flake";

  inputs = {
    nixpkgs.url = "nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # Helper wrapper to fix OpenGL kerfuffle when running glx apps on non-nixos
    nixgl.url = "github:nix-community/nixGL";
    nixgl.inputs.nixpkgs.follows = "nixpkgs";

    # Agenix allows for secrets management in a "GitOps" way
    # agenix-rekey allows using a single master identity (backed by a yubikey) and transparent cached rekeying for every host
    agenix.url = "github:ryantm/agenix";
    agenix.inputs.nixpkgs.follows = "nixpkgs";

    agenix-rekey.url = "github:oddlama/agenix-rekey";
    # Make sure to override the nixpkgs version to follow your flake,
    # otherwise derivation paths can mismatch (when using storageMode = "derivation"),
    # resulting in the rekeyed secrets not being found!
    agenix-rekey.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, nixgl, agenix, agenix-rekey }:
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
        agenix-rekey.overlays.default
      ];
    };

   lib = nixpkgs.lib;

  in {
    nixosConfigurations = {
      nixos-workstation = lib.nixosSystem {
        inherit system;
        inherit pkgs;

        modules = [
          agenix.nixosModules.default
          agenix-rekey.nixosModules.default

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
        ./modules/user/neovim
        ./modules/user/passage
      ];

      extraSpecialArgs = {
        inherit nixgl;
        theming = import themes/tokyonight.nix {
          inherit pkgs;
      }; };
    };

    # Expose the necessary information in your flake so agenix-rekey
    # knows where it has too look for secrets and paths.
    #
    # Make sure that the pkgs passed here comes from the same nixpkgs version as
    # the pkgs used on your hosts in `nixosConfigurations`, otherwise the rekeyed
    # derivations will not be found!
    agenix-rekey = agenix-rekey.configure {
      userFlake = self;
      nodes = self.nixosConfigurations;
      # Example for colmena:
      # inherit ((colmena.lib.makeHive self.colmena).introspect (x: x)) nodes;
    };


    # TODO: Make OS/ARCH independent via flake-utils
    devShells.${system}.default = pkgs.mkShell {
      packages = [
        # Expose the wrapped agenix-rekey cli needed for encrypting and rekeying
        pkgs.agenix-rekey

        pkgs.passage
      ];

      shellHook = ''
        # Override PASSAGE ENV VARs to point to the read/write-able store in repo copy on disk
        # shellHooks always run with PWD=<flake root>

        # TODO: Unify with agenix-conf (have module dispense modules for home-manager, devShell, and systemConfig)

        # TODO: add in path of flake root to construct correct path, PWD might be a sub directory when cding directly
        export PASSAGE_DIR="$PWD/secrets/passage/joel"
        export PASSAGE_IDENTITIES_FILE="$PWD/age-identities/age-yubikey-5c-primary-identity-c8d44732.pub"

        # scan in identities from age-identities (i.e. encrypt to master and backup)
        export PASSAGE_RECIPIENTS=`cat $PWD/age-identities/* | grep Recipient: | cut -d ':' -f2 | tr -d ' ' | tr "\n" ' '`
      '';
    };
  };
}
