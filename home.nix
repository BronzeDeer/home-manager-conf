{ config, pkgs, ... }:

{
  # Let Home Manager install and manage itself.
  programs.home-manager.enable = true;

  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
  };

  programs.git = {
    enable = true;
  };

  # Configure direnv and nix-direnv
  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };

  # Allow importing fonts for p10k
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # Install a nerdfont patches verison of our desired Font (FiraCode)
    (nerdfonts.override { fonts = ["FiraCode"];})
  ];

  programs.gnome-terminal = {
    enable = true;
    profile = {
      # Gnome Terminal expects UUIDs for the profiles
      "3ba303cf-768b-42e1-854f-bccf272bcddd" = {

        default = true;
        # Format is "<FontName> <FontSize>"
        font = "FiraCode Nerd Font Mono 12";
        visibleName = "ZSH Powerlevel10k";
        };
    };
  };

  # Import p10k config
  home.file.p10kconf = {
    source = ./.p10k.zsh;
    target ="p10k-config/.p10k.zsh";
  };

  programs.zsh = {
  # Let HM manage zsh
  enable = true;

  enableCompletion = false;

  initExtraBeforeCompInit = ''
    zstyle ':autocomplete:*' fzf-completion yes
    zstyle ':autocomplete:*' insert-unambiguous yes
    zstyle ':autocomplete:*' widget-style menu-select
  '';

  initExtra = ''
    source <(kubectl completion zsh)
  '';

  shellAliases = {
    ll = "ls -lah";
  };

  zplug = {
    enable = true;
    
    plugins = [
      { name = "plugins/colored-man-pages"; tags = [from:oh-my-zsh]; }
      { name = "plugins/colorize";          tags = [from:oh-my-zsh]; }
      { name = "plugins/command-not-found"; tags = [from:oh-my-zsh]; }
      { name = "plugins/fd";                tags = [from:oh-my-zsh]; }
      { name = "plugins/fzf";               tags = [from:oh-my-zsh]; }
      { name = "plugins/git";               tags = [from:oh-my-zsh]; }
      { name = "plugins/gh";               tags = [from:oh-my-zsh]; }
      { name = "plugins/ripgrep";           tags = [from:oh-my-zsh]; }
      { name = "plugins/vi-mode";           tags = [from:oh-my-zsh]; }
      { name = "plugins/direnv";            tags = [from:oh-my-zsh]; }
      # { name = "plugins/"; tags = [from:oh-my-zsh]; }
      { name = "zsh-users/zsh-syntax-highlighting"; tags = []; }
      { name = "plugins/zsh-autosuggestions"; tags = [from:oh-my-zsh]; }
      { name = "marlonrichert/zsh-autocomplete"; }
      { name = "kutsan/zsh-system-clipboard"; }  # IMPORTANT
      { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
      { name = "~/p10k-config/"; tags = [ from:local use:.p10k.zsh ]; }
    ];
    };
  };

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
