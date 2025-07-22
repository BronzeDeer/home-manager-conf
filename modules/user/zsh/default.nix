{
  config,
  pkgs,
  lib,
  ...
}:
let
  sourceOmzPlugin = ( name : "source ${pkgs.oh-my-zsh}/share/oh-my-zsh/plugins/${name}/${name}.plugin.zsh");
  zsh-completion-sync = pkgs.fetchFromGitHub { #TODO: Get this into nixpkgs
    owner = "BronzeDeer";
    repo = "zsh-completion-sync";
    rev = "v0.3.1";
    hash = "sha256-XhZ7l8e2H1+W1oUkDrr8pQVPVbb3+1/wuu7MgXsTs+8=";
  };
in
{
  home.packages = [
    # We disable zsh.enableCompletion to avoid double or tripple compinit, but still want the extra zsh completions installed
    pkgs.nix-zsh-completions
    # Also install general extra completions
    pkgs.zsh-completions
  ];

  programs.zsh = {
    # Let HM manage zsh
    enable = true;

    syntaxHighlighting.enable = true;

    # Use ZAC instead of normal auto complete
    completionInit = ''
      source ${pkgs.zsh-autocomplete}/share/zsh-autocomplete/zsh-autocomplete.plugin.zsh

      source ${./post-zac-hook.zsh}
      source ${./custom-tilde-completion.zsh}
    '';

    initContent = lib.mkMerge [

      # Before compinit
      (lib.mkOrder 550 (
        ''
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


          ${sourceOmzPlugin "colored-man-pages"}
          ${sourceOmzPlugin "colorize"}
          ${sourceOmzPlugin "command-not-found"}

          ${sourceOmzPlugin "gh"} # Should probably make this one conditional on gh being installed
          ${sourceOmzPlugin "vi-mode"}
          ${sourceOmzPlugin "direnv"}
          source ${pkgs.zsh-nix-shell}/share/zsh-nix-shell/nix-shell.plugin.zsh

          # Add completion functions from the host system, but at the end so that nix installed ones can shadow them
          fpath+=("/usr/share/zsh/vendor-completions")

        ''
        + lib.optionals config.programs.fzf.enable ''
          # We need to manually load fzf before zsh-autocomplete, otherwise breakage can occur, I'm not sure why
          if [[ $options[zle] = on ]]; then
            eval "$(${config.programs.fzf.package}/bin/fzf --zsh)"
          fi
        ''
      ))
      # Normal init
      (''
        # This zstyle (support?) was either silently dropped or it is supposed to automagically work now (it doesn't)
        #zstyle ':autocomplete:tab:*' fzf-completion yes

        # Uses compdef directly instead of async compdef on autoload, therefore needs to go after compinit
        ${sourceOmzPlugin "git"}

        # Ensure that our customizations will be re-run if we reload compsys via the completion-sync plugin
        zstyle ':completion-sync:compinit:custom:post-hook' enabled true
        zstyle ':completion-sync:compinit:custom:post-hook' command 'source ${./post-zac-hook.zsh} 1; source ${./custom-tilde-completion.zsh}'

        # Prompt theme
        prompt off # Needed in case /etc/zshrc has already loaded a theme (like on nixos with `programs.zsh.enable = true;`)
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        source ${./.p10k.zsh}
      '')
      (lib.mkOrder 1500 ''
        source ${zsh-completion-sync}/zsh-completion-sync.plugin.zsh
      '')
    ];

    shellAliases = {
      ll = "ls -lah";
    };
  };
}
