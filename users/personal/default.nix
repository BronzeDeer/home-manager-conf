{ config, pkgs,... }@inputs:

{
  imports = [
    ../../modules/user/nixGL
    ../../modules/user/kubernetes
    ../../modules/user/xmonad
    ../../modules/user/picom
    ../../modules/user/social
    ../../modules/user/gtk
    ../../modules/user/kitty
    ../../modules/user/betterlockscreen
    ../../modules/user/rofi
    ../../modules/user/file-manager
    ../../modules/user/vlc
    ../../modules/user/chromium
    ../../modules/user/dropbox
    ../../modules/user/vscode
    ../../modules/user/blugon
    ../../modules/user/basic-tools
    ../../modules/user/libation
    ../../modules/user/auto-start
    ../../modules/user/blueman-autostart
    ../../modules/user/deadd
    ../../modules/user/ausweisapp
    ../../modules/user/keepassxc
    ../../modules/user/libreoffice
    ../../modules/user/gwe
    ../../modules/user/xdg-portal
    ../../modules/user/email
    ../../modules/user/zsh
    ../../modules/user/neovim
    ../../modules/user/joystickwake
  ];

  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

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

  # Import allowed Yubikeys for sudo and login
  home.file.u2fkeys = {
    source = pkgs.replaceVars ./u2f_keys {user = config.home.username;};
    target = ".config/Yubico/u2f_keys";
  };

  home.file.sshKeys = {
    source = ./.ssh;
    # For some reason home-manager struggles with linking into .ssh (likely due to generating and linking .ssh/config)
    # Since we auto discover these keys anyway, inserting another subfolder should not pose a problem
    target = ".ssh/keys";
    recursive = true;
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
