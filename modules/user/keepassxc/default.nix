{ config, pkgs, ... }:
let
  kxc = pkgs.keepassxc;
in
{
  home.packages = with pkgs; [
    kxc
    dex # platform agnostic .desktop launcher
  ];

  userautostart.scriptInline = ''
    dex ${kxc}/share/applications/*.desktop
  '';
}
