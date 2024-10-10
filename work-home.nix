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
      rip = ''!f() { git rebase -i --autosquash --autostash `git merge-base HEAD ''${1:-origin/HEAD}`; }; f'';
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
      core.autocrlf = "input";

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
    # Force the path to use the hash of %r%h%p, this avoids overrunning the 108 byte limite for the control path with expecially long hosts
    controlPath = "~/.ssh/master-%C";

    matchBlocks = {
      "github.com" = {
        user = "git";
      };
    };
  };

  programs.zsh = {
  # Let HM manage zsh
  enable = true;

  # Note: this will cause home-manager to add an extraneous compinit, because it doesn't detect the zplug one,
  # but we need this option to get completions for the rest of the system like sysctl etc to be put on the fpath
  # However, since we are using zsh-autocomplete, we can be certain that compinit is already tombstoned with a no-op anyway
  enableCompletion = true;

  initExtraBeforeCompInit = ''
    # Add completion functions from the host system, but at the end so that nix installed ones can shadow them
    fpath+=("/usr/share/zsh/vendor-completions")
  '';

  initExtra = ''
    zstyle ':autocomplete:*' fzf-completion yes

    # Use down arrow to jump into the possible selections
    bindkey '^[OB' menu-select
    # When inside menuselection, use tab and shift tab to cycle
    bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete

    # Insert unambigous prefix first before completing
    # all Tab widgets
    zstyle ':autocomplete:*complete*:*' insert-unambiguous yes
    # all history widgets
    zstyle ':autocomplete:*history*:*' insert-unambiguous yes
    # ^S
    zstyle ':autocomplete:menu-search:*' insert-unambiguous yes

    # include "." and ".." in completion output
    zstyle ':completion:*:paths' special-dirs true

    # Fix pos1, end etc. for terminal emulator
    bindkey  "^[OH"   beginning-of-line #pos1
    bindkey  "^[OF"   end-of-line #end
    bindkey  "^[[3~"  delete-char #del
    bindkey "^[[1;5C" forward-word # Ctrl-RArrow
    bindkey "^[[1;5D" backward-word # Ctrl-LArrow

    # Load all _sk ssh keys at shell start
    # they don't need passwords to unlock since they are used interactively with the security key
    # This allows us to use multiple alternative ssh keys depending on which security key is plugged in
    find ~/.ssh/ -name '*_sk' | xargs ssh-add
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
      { name = "plugins/gradle";            tags = [from:oh-my-zsh]; }
      { name = "plugins/nix-shell";            tags = [from:oh-my-zsh]; }
      # { name = "plugins/"; tags = [from:oh-my-zsh]; }
      { name = "zsh-users/zsh-syntax-highlighting"; tags = []; }
      { name = "plugins/zsh-autosuggestions"; tags = [from:oh-my-zsh]; }
      { name = "marlonrichert/zsh-autocomplete"; tags= [ at:23.07.13 ];}
      { name = "chisui/zsh-nix-shell"; tags= [ "at:82ca15e638cc208e6d8368e34a1625ed75e08f90" ];}
      { name = "kutsan/zsh-system-clipboard"; }  # IMPORTANT
      { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
      { name = "~/p10k-config/"; tags = [ from:local use:.p10k.zsh ]; }
    ];
    };
  };

  # Home Manager needs a bit of information about you and the
  # paths it should manage.
  home.username = "jpe";
  home.homeDirectory = "/home/jpe";

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
