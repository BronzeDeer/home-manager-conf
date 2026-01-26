{
  pkgs,
  lib,
  config,
  ...
}@inputs:
{
  # Note: make sure that the user you want to use makemkv from is also part of the "cdrom" group, otherwise they cannot access the /dev/ entry of the drive
  boot.kernelModules = [ "sg" ]; # Needed for makemkv to access the drive

  environment.systemPackages = with pkgs; [
    makemkv
  ];
}
