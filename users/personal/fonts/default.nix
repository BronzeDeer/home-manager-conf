# This module is for fonts that are not needed to pre-configure any applications but that the user wants to have available for document/design work
# Any font required for styling an application should be included inside of the relevant module
{
  pkgs,
  lib,
  config,
  ...
}@inputs:
{
  home.packages = with pkgs; [
    nerd-fonts.arimo
    texlivePackages.librebaskerville
    antonio-font # Impact substitute with open license
  ];
}
