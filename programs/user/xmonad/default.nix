{config, pkgs, ...}:
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
    '';
  };

  services.taffybar.enable = true;
}
