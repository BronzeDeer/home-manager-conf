{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    keepassxc
  ];

  userautostart.scriptInline = ''
    keepassxc &
  '';
}
