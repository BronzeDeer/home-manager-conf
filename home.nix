{ config, pkgs, theming, ... }:

{
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
    extraConfig = {
      pull.rebase = true;
      rerere.enabled = true;
      core.editor = "vim";

      user = {
        email = "pepper@bronze-deer.de";
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

  xsession.numlock.enable = true;

  # Import p10k config
  home.file.p10kconf = {
    source = ./.p10k.zsh;
    target ="p10k-config/.p10k.zsh";
  };

  # Import allowed Yubikeys for sudo and login
  home.file.u2fkeys = {
    source = ./u2f_keys;
    target = ".config/Yubico/u2f_keys";
  };

  home.file.sshKeys = {
    source = ./.ssh;
    # For some reason home-manager struggles with linking into .ssh (likely due to generating and linking .ssh/config)
    # Since we auto discover these keys anyway, inserting another subfolder should not pose a problem
    target = ".ssh/keys";
    recursive = true;
  };

  home.file.i3Config = {
    source = ./i3/config;
    target = ".config/i3/config";
  };

  programs.ssh = {
    enable = true;
    controlMaster = "auto";
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

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "joel";
  home.homeDirectory = "/home/joel";

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
