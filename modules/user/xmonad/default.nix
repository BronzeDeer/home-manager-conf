{config, pkgs, theming,  ...}:
{
  xsession.enable = true;
  xsession.windowManager.xmonad = {
    enable = true;
    enableContribAndExtras = true;
    extraPackages = haskellPackages: with haskellPackages; [
      taffybar
    ];
    # Any extra dynamic, nix-controlled config can be written here
    config = pkgs.writeText "xmonad.hs" ''
      ${builtins.readFile ./config.hs}

      myFocusedBorderColor = "${theming.accent-primary}"
      myNormalBorderColor = "${theming.bg-primary-bright}"
    '';
  };

  services.taffybar.enable = true;
}
