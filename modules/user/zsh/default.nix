{
  programs.zsh = {
    # Let HM manage zsh
    enable = true;

    enableCompletion = false;

    initExtraBeforeCompInit = ''
      # https://github.com/marlonrichert/zsh-autocomplete/issues/761
      setopt interactivecomments
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
        # { name = "plugins/"; tags = [from:oh-my-zsh]; }
        { name = "zsh-users/zsh-syntax-highlighting"; tags = []; }
        { name = "plugins/zsh-autosuggestions"; tags = [from:oh-my-zsh]; }
        { name = "marlonrichert/zsh-autocomplete"; tags= [ at:24.09.04 ];}
        { name = "kutsan/zsh-system-clipboard"; }  # IMPORTANT
        { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
        { name = "~/p10k-config/"; tags = [ from:local use:.p10k.zsh ]; }
        { name = "BronzeDeer/zsh-completion-sync"; tags = [ at:v0.2.0 defer:3 ];}
      ];
    };
  };
}
