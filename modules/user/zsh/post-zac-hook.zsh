# This file bundles zstyle and bindkey settings that need to be applied after ever sourcing of zsh-autocomplete

# First arg: if set to true, do not add eval override as precmd hook, but run it directly
# This is useful when called from another precmd hook (like zsh-completion-sync's post-hook)
no_hook="$1"

# The overriden completion from zsh-autocomplete does not produce consistent behaviour, especially with unambiguous completion
# fzf-completions does, so we override the keybinding after loading zsh-autocomplete
# zsh-autocomplete still contributes most of its features through general configuration of the zsh completion system
# especially through
bindkey "^I" fzf-completion

  # include "." and ".." in completion output (this needs to go after zsh-autocomplete init, because for historical reasons it disables it during init)
zstyle ':completion:*:paths' special-dirs true

# Use down arrow to jump into the possible selections
bindkey '^[OB' menu-select
# When inside menuselection, use tab and shift tab to cycle
bindkey -M menuselect '\t' menu-complete "$terminfo[kcbt]" reverse-menu-complete

# Fix pos1, end etc. for terminal emulator
bindkey  "^[OH"   beginning-of-line #pos1
bindkey  "^[OF"   end-of-line #end
bindkey  "^[[3~"  delete-char #del
bindkey "^[[1;5C" forward-word # Ctrl-RArrow
bindkey "^[[1;5D" backward-word # Ctrl-LArrow

# Replace _expand completer with our wrapper
# Normally this should be accomplished via zstyles, however ZAC's _expand ignores all compsys zstyles...
# We also have to normally do this as a precmd hook since ZAC only overwrites the completer as a hook as well
_expand_patcher_precmd_hook(){
  zstyle -a ':completion:*' completer OLD_COMPLETER
  expand_completer_idx=${OLD_COMPLETER[(Ie)_expand]}
  if (($expand_completer_idx)); then
    OLD_COMPLETER[$expand_completer_idx]="_expand_wrapper_ignore_tilde"
    zstyle ':completion:*' completer "${OLD_COMPLETER[@]}"
    # reset original state of array for later debugging
    OLD_COMPLETER[$expand_completer_idx]="_expand"
  fi

  # If registered as hook, remove self
  add-zsh-hook -d precmd ${0}
}


if (($no_hook)); then
  _expand_patcher_precmd_hook
else
  add-zsh-hook precmd _expand_patcher_precmd_hook
fi

_expand_wrapper_ignore_tilde(){

  # Do not expand leading tilde
  # Since tilde is normally in the IPREFIX,
  # ZAC does not see it as part of the unambigous prefix and would drop it,
  # which has the effect of ~/foo -> /foo, which is obviously buggy
  local word="$words[CURRENT]"
  if [[ "$word" =~ "^\~.*" ]]; then
    return 1
  fi

  _expand
}
