# Disable file path completion if paths do not belong in the current context.
complete --command nix-or-nom --condition 'not _nix_accepts_files' --no-files

complete --command nix-or-nom --arguments '(_nix)'