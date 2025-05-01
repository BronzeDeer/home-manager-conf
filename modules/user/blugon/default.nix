{ config, pkgs, ... }:
{
  #FIXME: Add blugon to autostart hook
  home.packages = with pkgs; [ blugon ];

  home.file.blugonConfig = {
    source = ./config;
    target = ".config/blugon/config";
  };
}
