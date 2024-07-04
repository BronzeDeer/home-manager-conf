{config, pkgs, ...}:
{
  # Enable file picker for apps with portal support
  xdg.portal = {
    enable = true;
    xdgOpenUsePortal = true;
    extraPortals = with pkgs; [
      xdg-desktop-portal
      xdg-desktop-portal-gtk
      xdg-desktop-portal-gnome
    ];
    configPackages = [ pkgs.gnome.gnome-session ];
  };
}
