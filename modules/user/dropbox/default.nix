{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    # maestral is lightweight linux and mac client for dropbox
    maestral
    maestral-gui
  ];

  userautostart.scriptInline = ''
    maestral start &
  '';
}
