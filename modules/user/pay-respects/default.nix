{pkgs, lib, config,...}@inputs:
{

  # If our containing flake provides the precompiled nix-index-database module, use that
  imports = lib.optionals (inputs ? "nix-index-database") [
    inputs.nix-index-database.hmModules.nix-index
  ];

  programs.pay-respects = {
    enable = true;
    enableZshIntegration = config.programs.zsh.enable;
    enableFishIntegration = config.programs.fish.enable;
    enableBashIntegration = config.programs.bash.enable;
    enableNushellIntegration = config.programs.nushell.enable;
  };

  # nix-index is used to allow rapid searching through available nix packages for pay-respects and other command-not-found wrappers to suggest which packages provide a certain command
  programs.nix-index = {
    enable = true;
    enableZshIntegration = config.programs.zsh.enable;
    enableFishIntegration = config.programs.fish.enable;
    enableBashIntegration = config.programs.bash.enable;
  };
}
