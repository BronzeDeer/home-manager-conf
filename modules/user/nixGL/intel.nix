{ config, pkgs, ... }:
let
  nixGLPackage = pkgs.nixgl.nixGLIntel;
in
{
  imports = [ ./common.nix ];
  home.packages = [
    nixGLPackage
  ];

  targets.genericLinux.nixGL = {
    defaultWrapper = "mesa"; # choose from options
  };
}
