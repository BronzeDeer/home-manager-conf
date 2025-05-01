{
  config,
  pkgs,
  lib,
  ...
}@inputs:
{
  home.packages = with pkgs; [
    terraform
  ];

  home.shellAliases = {
    tf = "terraform";
  };
}
