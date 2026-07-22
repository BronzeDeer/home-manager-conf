{
  pkgs,
  lib,
  config,
  ...
}@inputs:
{
  environment.systemPackages = with pkgs; [ android-tools ];
}
