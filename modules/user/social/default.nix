{ config, pkgs, ... }:
let
  signal = pkgs.signal-desktop;
  telegram = pkgs.telegram-desktop;
  # For the browser-only messengers, create separate chromium profiles and launch them in app mode
  # TODO: make actual chromium based browser (Chrome, ungoogled, Brave etc) configurable
  # For now, assume that chromium is installed and available as "chromium"
  # TODO: icons as fixed output derivations
  whatsapp = pkgs.makeDesktopItem {
    name = "WhatsApp";
    desktopName = "WhatsApp";
    comment = "Running WhatsApp in chromium app mode";
    exec = ''chromium --app="http://web.whatsapp.com" --user-data-dir=${config.home.homeDirectory}/.messenger-browser-profiles/whatsapp'';
    terminal = false;
  };
  fb-messenger = pkgs.makeDesktopItem {
    name = "fb-messenger";
    desktopName = "Facebook Messenger";
    comment = "Running Facebook Messenger in chromium app mode";
    exec = ''chromium --app="http://www.facebook.com/messages/t/" --user-data-dir=${config.home.homeDirectory}/.messenger-browser-profiles/facebook'';
    terminal = false;
  };
in
{
  home.packages = with pkgs; [
    signal
    telegram
    discord
    whatsapp
    fb-messenger
    dex # platform agnostic .desktop launcher
  ];

  userautostart.scriptInline = ''
    #dex ${fb-messenger}/share/applications/*.desktop
    dex ${whatsapp}/share/applications/*.desktop
    dex ${signal}/share/applications/*.desktop
    dex ${telegram}/share/applications/*.desktop
  '';
    #chromium  --app="http://web.whatsapp.com" --user-data-dir=$HOME/.messenger-browser-profiles/whatsapp &
    #chromium  --app="http://www.facebook.com/messages/t/" --user-data-dir=${config.home.homeDirectory}/.messenger-browser-profiles/facebook &
}
