# Adopted from https://github.com/sherubthakur/dotfiles/

{ config, pkgs, lib, theming, ... }:
{
  home.packages = with pkgs; [
    lxappearance
    dracula-theme
    moka-icon-theme
    numix-icon-theme-square
    whitesur-icon-theme
    palenight-theme
  ];

  gtk = {
    enable = true;
    font = { name = theming.font-name;};
    iconTheme = { name = theming.gtk-icon-name; };
    theme = { name = theming.gtk-theme-name; };
  };
}
