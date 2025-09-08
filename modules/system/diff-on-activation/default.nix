{
  pkgs,
  lib,
  config,
  ...
}@inputs:
{
  # This script runs nvd diff to compare the recently build and about to be activated system config to the upcoming one
  system.activationScripts = {
    diffGens = ''
      PATH=$PATH:${lib.makeBinPath [ pkgs.nix ]}
      echo "----- CHANGES (ROOT) -----" | ${pkgs.lolcat}/bin/lolcat -S 40
      ${pkgs.nvd}/bin/nvd diff /run/current-system "$systemConfig"
      echo "----- END OF CHANGES -----" | ${pkgs.lolcat}/bin/lolcat -S 40
    '';
  };
}
