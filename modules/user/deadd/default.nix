#FIXME: autostart deadd-notification-center
{ pkgs, theming, ... }:
let
  themeConfig = theming { inherit pkgs; };
in
{
  home.packages = with pkgs; [ deadd-notification-center ];

  home.file.".config/deadd/deadd.css".source = themeConfig.deadd-css-file;

  userautostart.scriptInline = ''
    deadd-notification-center &
  '';
}
