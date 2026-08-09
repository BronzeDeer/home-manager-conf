# Adopted from https://github.com/sherubthakur/dotfiles/

{
  config,
  pkgs,
  lib,
  theming,
  ...
}:
let
  themeConfig = theming { inherit pkgs; };
in
{
  home.packages = with pkgs; [
    lxappearance
    moka-icon-theme
    numix-icon-theme-square
    whitesur-icon-theme
    palenight-theme
  ];

  gtk = {
    enable = true;
    font = {
      name = themeConfig.font-name;
    };
    iconTheme = {
      name = themeConfig.gtk-icon-name;
    };
    theme = {
      name = themeConfig.gtk-theme-name;
    };
    colorScheme = themeConfig.gtk-color-scheme;

    gtk4.theme = config.gtk.theme;
  };
}
