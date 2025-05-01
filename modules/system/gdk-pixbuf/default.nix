# Allow loading pixmap icons from cache
{
  pkgs,
  lib,
  config,
  ...
}@inputs:
{
  programs.gdk-pixbuf.modulePackages = with pkgs; [
    librsvg
    webp-pixbuf-loader
  ];
  gtk.iconCache.enable = true;

}
