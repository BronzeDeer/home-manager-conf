{
  config,
  pkgs,
  lib,
  ...
}@inputs:
{
  home.packages = [
    pkgs.jetbrains.pycharm-community
  ];
}
