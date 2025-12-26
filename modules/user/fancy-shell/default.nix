{
  pkgs,
  lib,
  config,
  theming,
  ...
}@inputs:
{
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

  home.packages = with pkgs; [
    nix-output-monitor
  ];

  home.shellAliases = {

    cat = "bat";

    # nom aliases
    nix = "nom";
    nix-shell = "nom-shell";
    nix-build = "nom-build";
  };

  programs.skim = {
    enable = true;
    enableZshIntegration = config.programs.zsh.enable;
    enableBashIntegration = config.programs.bash.enable;
    enableFishIntegration = config.programs.fish.enable;
  };
}
