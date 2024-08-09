{config, pkgs, ...}:
{
  home.packages = with pkgs; [
    (config.lib.nixGL.wrap vlc)
  ];
}
