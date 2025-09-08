{
  config,
  pkgs,
  lib,
  theming,
  ...
}:
{
  config = {
    programs.oh-my-posh = {
      enable = true;
      enableZshIntegration = config.programs.zsh.enable;
      enableBashIntegration = config.programs.bash.enable;
      enableFishIntegration = config.programs.fish.enable;
      # Personal theme originally based on the "blue-owl" theme
      settings = builtins.fromJSON (builtins.unsafeDiscardStringContext (builtins.readFile ./blue-deer.omp.json));
    };
  };
}
