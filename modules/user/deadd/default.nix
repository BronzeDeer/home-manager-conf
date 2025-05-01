#FIXME: autostart deadd-notification-center
{ pkgs, theming, ... }:
{
  home.packages = with pkgs; [ deadd-notification-center ];

  home.file.".config/deadd/deadd.css".source = theming.deadd-css-file;

  userautostart.scriptInline = ''
    deadd-notification-center &
  '';
}
