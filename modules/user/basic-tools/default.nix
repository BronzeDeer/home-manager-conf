{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    evince # Gnome document viewer
    loupe # image viewer

    dig # dns tools
    traceroute

    zip
    unzip

    file # file identifier
    ncdu # ncurses disk usage explorer

    gnome-screenshot

    btop

    magic-wormhole-rs
  ];
}
