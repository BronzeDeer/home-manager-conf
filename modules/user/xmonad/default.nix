{config, pkgs, theming, lib, ...}:
with lib;
{
  xsession.enable = true;
  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    extraPackages = haskellPackages: with haskellPackages; [
      taffybar
    ];
    # Any extra dynamic, nix-controlled config can be written here
    config = pkgs.writeText "xmonad.hs" (
      ''
        ${builtins.readFile ./config.hs}

        myFocusedBorderColor = "${theming.accent-primary}"
        myNormalBorderColor = "${theming.bg-primary-bright}"
      ''
      +
      (
        if config.userautostart.enable then ''
          autostartEntrypoint = "${config.userautostart.entrypoint}"
        '' else ''
          autostartEntrypoint = ""
        ''
      )
    );
  };

  # Ensure that PATH is propagated to user services like xdg-portal
  # Note that importedVariables is a hidden option that is used mostly internally by home-manager moduls
  xsession.importedVariables = ["PATH"];

  services.taffybar.enable = true;
}
