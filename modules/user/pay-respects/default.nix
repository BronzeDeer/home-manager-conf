{
  pkgs,
  lib,
  config,
  ...
}@inputs:
  let
    cfg = config.bd.pay-respects;
  in
{
  options.bd.pay-respects = {
    enable = lib.mkOption {
      type = lib.types.bool;
      default = true;
    };

    enableCommandNotFound = lib.mkOption {
      type = lib.types.bool;
      default = true;
      description = ''
        Register as command not found handler in shells with enabled integration (see programs.pay-respects.enable*shIntegration).
        If true, will ensure that nix-index is installed as backing provider for package searches and disable its command-not-found integration
      '';
    };
  };
  
  # If our containing flake provides the precompiled nix-index-database module, use that
  imports = lib.optionals (inputs ? "nix-index-database") [
    inputs.nix-index-database.homeModules.nix-index
  ];

  config = lib.mkIf cfg.enable {

    programs.pay-respects = {
      enable = true;
      enableZshIntegration = config.programs.zsh.enable;
      enableFishIntegration = config.programs.fish.enable;
      enableBashIntegration = config.programs.bash.enable;
      enableNushellIntegration = config.programs.nushell.enable;

      # pay-respects registers the cnf handler by default, if we do not want that we have to pass --nocnf
      options = lib.optionals (! cfg.enableCommandNotFound) [
        "--nocnf"
      ];
    };

    # nix-index is used to allow rapid searching through available nix packages for pay-respects and other command-not-found wrappers to suggest which packages provide a certain command
    programs.nix-index = lib.optionalAttrs cfg.enableCommandNotFound {
      enable = true;
      # Deactivate the nix-index command-not-found hook if we are using the pay-respects hook in that shell
      enableZshIntegration = !config.programs.pay-respects.enableZshIntegration;
      enableFishIntegration = !config.programs.pay-respects.enableFishIntegration;
      enableBashIntegration = !config.programs.pay-respects.enableBashIntegration;
    };
  };
}
