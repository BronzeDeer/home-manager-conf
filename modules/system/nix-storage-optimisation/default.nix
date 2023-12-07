{
  # Regularly optimise nix store by replacing duplicates with hardlinks
  nix.optimise.automatic = true;

  # Remove older NixOS generations so old derivations can be gc'ed
  nix.gc = {
    automatic = true;
    # Trigger even if the system was powered down during the scheduled time
    persistent = true;
    dates = "weekly";
    # Retain last 5 generations for boot repair,
    # even older ones can be reconstructed from git as needed
    options = "--delete-older-than +5";
  };
}
