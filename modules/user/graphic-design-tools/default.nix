{
  pkgs,
  lib,
  config,
  ...
}@inputs:
{
  home.packages = with pkgs; [
    gimp
    inkscape
  ];
}
