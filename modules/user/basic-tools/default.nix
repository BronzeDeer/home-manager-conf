{config, pkgs, ...}:
{
  home.packages = with pkgs; [
    evince # Gnome document viewer
    loupe # image viewer
  ];
}
