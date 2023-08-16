{config, pkgs, ...}:
{
  home.packages = with pkgs; [
    # Thunar is a simple but fully-featured gtk based file manager
    xfce.thunar
    # Support to automatic volume management of drives and media (like mtp)
    xfce.thunar-volman
  ];
}
