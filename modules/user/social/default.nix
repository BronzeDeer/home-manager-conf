{config, pkgs, ...}:
{
  home.packages = with pkgs; [
    signal-desktop
    telegram-desktop
    discord
  ];

  # For the browser-only messengers, create separate chromium profiles and launch them in app mode
  # Todo: make actual chromium based browser (Chrome, ungoogled, Brave etc) configurable
  # For now, assume that chromium is installed and available as "chromium"

  userautostart.scriptInline = ''
    chromium  --app="http://web.whatsapp.com" --user-data-dir=$HOME/.messenger-browser-profiles/whatsapp &
    chromium  --app="http://www.facebook.com/messages/t/" --user-data-dir=$HOME/.messenger-browser-profiles/facebook &
  '';
}
