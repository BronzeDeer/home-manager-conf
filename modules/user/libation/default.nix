{ config, pkgs, ... }:
{
  home.packages = with pkgs; [
    libation # audible ripper
  ];
}
