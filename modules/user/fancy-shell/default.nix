{
  pkgs,
  lib,
  config,
  theming,
  ...
}@inputs:
{

  imports = [
    ./nix-or-nom
  ];

  programs.delta = {
    enable = true;
    enableGitIntegration = true;
  };

  programs.ripgrep = {
    enable = true;
  };

  programs.ripgrep-all = {
    enable = true;
  };

  programs.bat = {
    enable = true;
    #theme = TODO;
  };

  home.shellAliases = {
    cat = "bat";
  };

  programs.skim = {
    enable = true;
    enableZshIntegration = config.programs.zsh.enable;
    enableBashIntegration = config.programs.bash.enable;
    enableFishIntegration = config.programs.fish.enable;
  };
}
