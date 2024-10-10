{config,pkgs,lib,...}:
{
  programs.zsh = {
    # Let HM manage zsh
    enable = true;

    enableCompletion = false;

    initExtraBeforeCompInit = ''
      # https://github.com/marlonrichert/zsh-autocomplete/issues/761
      setopt interactivecomments

      # Insert unambigous prefix first before completing
      # all widgets
      zstyle ':autocomplete:*' insert-unambiguous yes
      # Insert longest prefix instead of insert all common parts of the string
      # foo.{1,2,3}.bar will complete to "foo." instead of "foo..bar"
      zstyle ':completion:*:*' matcher-list 'm:{[:lower:]-}={[:upper:]_}' '+r:|[.]=**'

      # Do not try to match previous path segments, this interferes with the unambiguous completion
      zstyle ':completion:*' path-completion false

      # Add completion functions from the host system, but at the end so that nix installed ones can shadow them
      fpath+=("/usr/share/zsh/vendor-completions")

    '' + lib.optionals config.programs.fzf.enable ''
      # We need to manually load fzf before zsh-autocomplete, otherwise breakage can occur, I'm not sure why
      if [[ $options[zle] = on ]]; then
        eval "$(${config.programs.fzf.package}/bin/fzf --zsh)"
      fi
    '';

    initExtra = ''
      # This zstyle (support?) was either silently dropped or it is supposed to automagically work now (it doesn't)
      #zstyle ':autocomplete:tab:*' fzf-completion yes

      source ${./post-zac-hook.zsh}
      source ${./custom-tilde-completion.zsh}

      # Ensure that our customizations will be re-run if we reload compsys via the completion-sync plugin
      zstyle ':completion-sync:compinit:custom:post-hook' enabled true
      zstyle ':completion-sync:compinit:custom:post-hook' command 'source ${./post-zac-hook.zsh} "true"; source ${./custom-tilde-completion.zsh}'
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
        { name = "chisui/zsh-nix-shell"; tags= [ "at:82ca15e638cc208e6d8368e34a1625ed75e08f90" ];}
        { name = "zsh-users/zsh-syntax-highlighting"; tags = []; }
        { name = "plugins/zsh-autosuggestions"; tags = [from:oh-my-zsh]; }
        { name = "marlonrichert/zsh-autocomplete"; tags= [ at:24.09.04 ];}
        { name = "kutsan/zsh-system-clipboard"; }  # IMPORTANT
        { name = "romkatv/powerlevel10k"; tags = [ as:theme depth:1 ]; }
        { name = "~/p10k-config/"; tags = [ from:local use:.p10k.zsh ]; }
        { name = "BronzeDeer/zsh-completion-sync"; tags = [ at:v0.3.0 defer:3 ];}
      ];
    };
  };
}
