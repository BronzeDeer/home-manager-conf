{
  pkgs,
  lib,
  config,
  ...
}@inputs:
{
  services.swaync = {
    enable = true;

    # Adopted from github.com/lvntcnylmz/dotfiles/@1661fd00e398de7f9778463c35f92e141f0a898d
    settings = builtins.fromJSON (builtins.readFile ./config.json );
    style = ./style.css;
  };
}
