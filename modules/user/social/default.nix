{ config, pkgs, ... }:
let
  signal = pkgs.signal-desktop;
  telegram = pkgs.telegram-desktop;
in
{
  home.packages = with pkgs; [
    signal
    telegram
    discord
    dex # platform agnostic .desktop launcher
  ];

  # For the browser-only messengers, create separate chromium profiles and launch them in app mode
  # Todo: make actual chromium based browser (Chrome, ungoogled, Brave etc) configurable
  # For now, assume that chromium is installed and available as "chromium"

  userautostart.scriptInline = ''
    chromium  --app="http://web.whatsapp.com" --user-data-dir=$HOME/.messenger-browser-profiles/whatsapp &
    dex ${signal}/share/applications/*.desktop
    dex ${telegram}/share/applications/*.desktop
  '';
    #chromium  --app="http://www.facebook.com/messages/t/" --user-data-dir=$HOME/.messenger-browser-profiles/facebook &
}
