# Adopted from https://github.com/sherubthakur/dotfiles/

{ config, pkgs, ... }:
let
  # Regex that matches all strings starting with 'eww' that don't end in 'bg'
  non-background-eww-stuff = "^eww(?!.+-bg$).+$";
in
{
  services.picom = {
    enable = true;
    backend = "glx";
    vSync = true;

    # Transparency/Opacity
    inactiveOpacity = 0.80;
    activeOpacity = 0.95;
    opacityRules = [
      "100:class_g   *?= 'Firefox'"
      "100:class_g   *?= 'Deadd-notification-center'"
      "100:class_g   *?= 'Rofi'"
      "100:fullscreen"
    ];

    # Fading
    fade = true;
    fadeDelta = 10;

    # Shadows
    shadow = true;
    shadowExclude = [
      "class_g = 'eww-topbar-btw'"
      "class_g ~= '${non-background-eww-stuff}'"
    ];

    settings = {
      # Blur
      blur-method = "dual_kawase";
      blur-strength = 8;
      blur-backgroud-exclude = [
        "class_g = 'eww-topbar-btw'"
      ];

      # Radius
      corner-radius = 10;
      round-borders = 1;
      rounded-corners-exclude = [
        "class_g = 'Custom-taffybar'"
      ];

      # Use compositor to avoid tearing in "normal" windows
      # This allows us to not resort to force composition pipeline or similar in xsettings
      vsync = true;

      # Allow fullscreen windows to directly paint to the screen, especially useful for games
      unredir-if-possible = true;
    };

  };

  # Since Xorg was historically the only type of graphical-session most Xorg dependent services
  #   target _any_ graphical-session, including wayland sessions.
  # Wayland services have a separate target to avoid launching under X but not vice versa
  # Since in our setup the X11 DE is launched by hm we can use the hm-graphical-session
  #   to target to only target non-wayland sessions
  systemd.user.services.picom = {
    Unit = {
      After = [ "hm-graphical-session.target" ];
      PartOf = [ "hm-graphical-session.target" ];
      Requisite = [ "hm-graphical-session.target" ];
    };
  };
}
