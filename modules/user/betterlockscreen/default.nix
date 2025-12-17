{
  services.betterlockscreen = {
    enable = true;
    inactiveInterval = 30;
  };

  # Since Xorg was historically the only type of graphical-session most Xorg dependent services
  #   target _any_ graphical-session, including wayland sessions.
  # Wayland services have a separate target to avoid launching under X but not vice versa
  # Since in our setup the X11 DE is launched by hm we can use the hm-graphical-session
  #   to target to only target non-wayland sessions
  systemd.user.services.xautolock-session = {
    Unit = {
      After = [ "hm-graphical-session.target" ];
      PartOf = [ "hm-graphical-session.target" ];
      Requisite = [ "hm-graphical-session.target" ];
    };
  };

  systemd.user.services.xss-lock = {
    Unit = {
      After = [ "hm-graphical-session.target" ];
      PartOf = [ "hm-graphical-session.target" ];
      Requisite = [ "hm-graphical-session.target" ];
    };
  };
}
