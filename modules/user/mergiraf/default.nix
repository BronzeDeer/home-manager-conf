{
  pkgs,
  lib,
  config,
  ...
}@inputs:
{
  programs.mergiraf = {
    enable = true;
    enableGitIntegration = lib.mkDefault config.programs.git.enable;
    enableJujutsuIntegration = lib.mkDefault config.programs.jujutsu.enable;
  };
}
