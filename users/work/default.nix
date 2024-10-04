{ config, pkgs, theming, ... }:

{

  imports = [
    ../../modules/user/nixGL
    ../../modules/user/kubernetes
    ../../modules/user/kitty
    ../../modules/user/vlc
    ../../modules/user/basic-tools
    ../../modules/user/libreoffice
    ../../modules/user/gwe
    ../../modules/user/auto-start
    ../../modules/user/chromium-webappify
    ../../modules/work/webapps
    ../../modules/user/zsh
    ../../modules/user/azure
    ../../modules/user/keepassxc
  ];


  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.vim = {
    enable = true;
    settings = {
      expandtab = true;
      shiftwidth = 2;
      tabstop = 2;
    };
    extraConfig = ''
      filetype plugin indent on
      set sts=2
    '';
  };

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
    aliases = {
      quicklog = "log --oneline --graph --decorate";
      fpush = "push --force-with-lease --force-if-includes";
      ffmerge = "merge --ff-only";
      fap = "fetch --all --prune";
    };

    # TODO: doesn't work correctly yet
    includes = (builtins.map (urlGlob:
      # Conditionally overwrite user when commiting to my own repos
      {
        condition = "hasconfig:remote.*.url:${urlGlob}";
        contents = {
          user.email = "pepper@bronze-deer.de";
          user.name = "Joel Pepper";
        };
      })
      [
        "git@github.com/BronzeDeer/**"
        "git@github.com:BronzeDeer/**"
        "git+ssh://git@github.com/BronzeDeer/**"
        "ssh://git@github.com:BronzeDeer/**"
        "git+ssh://github.com/BronzeDeer/**"
        "ssh://github.com:BronzeDeer/**"
        "https://github.com/BronzeDeer/**"
      ]
    );

    extraConfig = {
      pull.rebase = true;
      rerere.enabled = true;
      core.editor = "vim";

      user = {
        email = "joel.pepper@colenio.com";
        name = "Joel Pepper";
      };
    };
  };

  # Configure direnv and nix-direnv
  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };

  # Import allowed Yubikeys for sudo and login
  home.file.u2fkeys = {
    source = pkgs.replaceVars ../personal/u2f_keys {user = config.home.username;}; #same keys as private machine
    target = ".config/Yubico/u2f_keys";
  };

  home.file.sshKeys = {
    source = ../personal/.ssh; #same keys as private machine, since they are bound to a yubikey on my person
    # For some reason home-manager struggles with linking into .ssh (likely due to generating and linking .ssh/config)
    # Since we auto discover these keys anyway, inserting another subfolder should not pose a problem
    target = ".ssh/keys";
    recursive = true;
  };

  programs.ssh = {
    enable = true;
    controlMaster = "auto";
    # Force the path to use the hash of %r%h%p, this avoids overrunning the 108 byte limite for the control path with expecially long hosts
    controlPath = "~/.ssh/master-%C";

    matchBlocks = {
      "github.com" = {
        user = "git";
      };
    };
  };

  programs.zsh.initExtra = ''
    # Load all _sk ssh keys at shell start
    # they don't need passwords to unlock since they are used interactively with the security key
    # This allows us to use multiple alternative ssh keys depending on which security key is plugged in
    find ~/.ssh/ -name '*_sk' | xargs ssh-add
  '';

  # This value determines the Home Manager release that your
  # configuration is compatible with. This helps avoid breakage
  # when a new Home Manager release introduces backwards
  # incompatible changes.
  #
  # You can update Home Manager without changing this value. See
  # the Home Manager release notes for a list of state version
  # changes in each release.
  home.stateVersion = "22.05";
}
