{
  config,
  pkgs,
  theming,
  lib,
  ...
}:
with lib;
{
  xsession.enable = true;
  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;

    haskellPackages =
      if (pkgs.haskellPackages.xmonad.version < "0.18") then
        pkgs.haskellPackages.extend (
          final: prev: {
            xmonad = prev.xmonad_0_18_0 or prev.xmonad; # it is incredibly unlikely that nixpkgs will remove _0_18_0 inf favour of a _0_18_x or _0_19_0 without bumping xmonad to >= 0.18.0, but just in case fallback to xmonad if the special package is not available
          }
        )
      else
        pkgs.haskellPackages;

    extraPackages =
      haskellPackages: with haskellPackages; [
        taffybar
      ];
    # Any extra dynamic, nix-controlled config can be written here
    config = pkgs.writeText "xmonad.hs" (
      ''
        ${builtins.readFile ./config.hs}

        myFocusedBorderColor = "${theming.accent-primary}"
        myNormalBorderColor = "${theming.bg-primary-bright}"
      ''
      + (
        if config.userautostart.enable then
          ''
            autostartEntrypoint = "${config.userautostart.entrypoint}"
          ''
        else
          ''
            autostartEntrypoint = ""
          ''
      )
    );
  };

  # Ensure that PATH is propagated to user services like xdg-portal
  # Note that importedVariables is a hidden option that is used mostly internally by home-manager moduls
  xsession.importedVariables = [ "PATH" ];

  services.taffybar.enable = true;
}
