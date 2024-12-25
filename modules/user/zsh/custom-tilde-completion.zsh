# This file overrides the behaviour for the -tilde- case, i.e. where a word starts with a tilde '~'
# A leading tilde has one of 3 meanings in zsh:
# - '~<user>', reffering to the home directory of user $user, expanding to $userdirs[<user>]
# - '~<name>', referring to a named dir, serving as shorthand for $nameddirs[<name>]
# - '~', a convenience short hand for the home directory of the current user
# The last use case is the most common and it overlaps with similar expansions in most shells
# But it can be really useful to harness the named directoies in specific usecases
# Therefore the most ergonomics could be gained by enabling '~' to directly complete to '~/'
# while maintaining normal insertion-completion behaviour for any prefix longer than '~'


# This allows us to insert on exact matches of the command-line to the current prefix
# Concretely this means that we need to ensure that '~' is a valid match body with a suffix of '/'
zstyle ':completion:*:-tilde-:*' accept-exact true
zstyle ':completion:*:-tilde-:*' completer _tilde


# customize which categories of completions should be used and in which order they should be displayed
# This will first display the home short cut, then named directories and finaly a list of all users
# If you want to exclude a certain categories, put it into a string prefixed with '! '
# Example: display home, then named-dirs, and do not display users
# Note: ZAC interferes with this, it might be sensitive to load order and still not work depending on overwritten functions
#zstyle ':completion:*:-tilde-:*' tag-order home tilde-named-dirs '! tilde-users'

# In the default zsh setup and _tilde() (atleast as used by zsh-autocomplete) ~[/] is never compadded
# And "~" can never be a valid prefix, because as of zsh-5.9-0-g73d3173, _main_complete hardcodes
# shifting the leading '~' into the ignored prefix (IPREFIX), which makes the rest of the
# completion system ignore the '~' case for completion.
# This function overrides the normal behaviour and prepares all relevant completions in one shot
_tilde(){
  if [[ $IPREFIX != '' ]] then
    # as of 5.9 zsh hardcodes IPREFIX='~' in the tilde case,
    # which keeps us from auto completing '~' to '~/', because the common string is empty for '~'
    PREFIX="${IPREFIX}${PREFIX}"
    IPREFIX=""
    # Unsetting restore forces the rest of the completion system to work on the new values for IPREFIX and others
    compstate["restore"]=""
  fi

  # Adapted from _users
  local expl users

  # We want our home directory to be part of the completions, so just add it directly
  # We want it to complete to "~/", but match on just "~", hence -S to add a suffix that is not part of the match
  # -Q is necessary to disable automatically quoting "~", which normally is escaped to avoid weird shell behaviour,
  # but here we actually want the shell meaning of "~"
  _wanted home expl "home directory" compadd "$@" -Q -qS'/' "~"

  # Add all named dirs to the completion options
  # We read the nameddirs from the keys of the associative array "$nameddirs"
  # Since they don't include leading tildes, we need to add "~" to the match body, to ensure that "~" becomes a common prefix, hence "-p" instead of "-P"
  # Normally, the tilde subsystem set "~" as ignored prefix (-i) before entering the completer functions
  # This we needed to change to get the common prefix to work, so we can (and need to) re-add the prefix as hidden, but included again
  _wanted tilde-named-dirs expl "named directory" compadd "$@" -Q -p'~' -qS'/' -k nameddirs

  # Copied from _users, respect curcontext's users tag to limit which users are offered for autocompletion
  # Originally this was introduced to speed up autocompletion with lots of users, but on modern systems that is likely not a concern
  # However this allows users to provide an evaluated style (i.e. a function) which can dynamically filter out users that "pollute" the output
  if zstyle -a ":completion:''${curcontext}:users" users users
  then
    # If set, autocomplete from the array
    _wanted tilde-users expl user compadd "$@" -Q -p'~' -qS'/' -a users
  fi
  # Otherwise, load all keys from $userdirs
  # For flags, see nameddirs above
  _wanted tilde-users expl user compadd "$@" -Q -p'~' -qS'/' -k userdirs

  return 0
}
