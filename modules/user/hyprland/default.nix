{
  pkgs,
  lib,
  config,
  theming,
  osConfig ? null,
  ...
}:
{
  home.packages = with pkgs; [
    grimblast # screenshot tool
    brightnessctl # needed for screen dimming via hypridle
  ];

  wayland.windowManager.hyprland = {
    enable =
      lib.warnIfNot (osConfig == null || osConfig.programs.hyprland.enable)
        "When using hyprland via the home-manager module on nixos, programs.hyperland.enable should be set in the nixos config as well"
        true;

    systemd.enableXdgAutostart = true;

    settings = {
      general = {
        layout = "master";
        gaps_out = 2;
        #"col.active_border" = "rgb(29315A)";
      };
      decoration = {
        active_opacity = 1;
        inactive_opacity = 0.9;
        rounding = 5;
      };
      # TODO: parse from machine config field if available (need to create that module first)
      monitorv2 = [
        {
          output = "DP-3";
          # output = "serial:LKK0W0144340"; #Acer's goddamn cloned serial numbers really screw with this again (apparently ALTSERIAL field contains the correct ones, but that would need to be patched into hyprland)
          mode = "1920x1080@60";
          position = "-1920x0";
          scale = 1;
        }
        {
          output = "DP-2";
          #output = "serial:0x0002293D";
          mode = "3840x2160@60";
          position = "0x0";
          #scale = 1.25;
          scale = 1;
        }
        {
          output = "HDMI-A-1";
          #output = "serial:LKK0W0144340";
          mode = "1920x1080@60";
          position = "3840x0";
          #position = "3072x0"; # 3840/1.25
          scale = 1;
        }
      ];
      # TODO: should be machine relative/read from xkb
      input = {
        kb_layout = "de";
        kb_variant = "nodeadkeys";
        kb_options = config.home.keyboard.options;
        numlock_by_default = true;
      };

      # Force xwayland apps (like steam to not be a blurry wrong scaled mess)
      xwayland = {
        force_zero_scaling = true;
      };

      "$mod" = "SUPER";
      bind = [
        "$mod, F, fullscreen"
        "CTRL ALT, T, exec, kitty" # TODO: make terminal dynamic
        ", Print, exec, grimblast copy area"
        "$mod, TAB, exec, rofi -show drun -theme grid"
        "$mod SHIFT, C, killactive"
        "$mod, J, layoutmsg, cycleprev"
        "$mod, K, layoutmsg, cyclenext"
        "$mod SHIFT, J, layoutmsg, swapprev"
        "$mod SHIFT, K, layoutmsg, swapnext"
        "$mod, H, layoutmsg, mfact -0.025"
        "$mod, L, layoutmsg, mfact +0.025"
        "$mod, SPACE, layoutmsg, orientationcycle left top center"
        "$mod, Return, layoutmsg, swapwithmaster ignoremaster auto"

        "CTRL ALT, L, exec, hyprlock"

      ]
      ++ (
        # workspaces
        # binds $mod + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
            in
            [
              # Xmonad style switching instead of the default which leaves workspaces on the monitor where they were last
              "$mod, code:1${toString i}, focusworkspaceoncurrentmonitor, ${toString ws}"
              "$mod SHIFT, code:1${toString i}, movetoworkspacesilent, ${toString ws}"
            ]
          ) 9
        )
      )
      # Workspace movement with Numpad keys (sadly the KP_n aliases do not work, but the aliases for numlock=false work in both state)
      ++ [
        "$mod, KP_End, focusworkspaceoncurrentmonitor, 1"
        "$mod, KP_Down, focusworkspaceoncurrentmonitor, 2"
        "$mod, KP_Next, focusworkspaceoncurrentmonitor, 3"
        "$mod, KP_Left, focusworkspaceoncurrentmonitor, 4"
        "$mod, KP_Begin, focusworkspaceoncurrentmonitor, 5"
        "$mod, KP_Right, focusworkspaceoncurrentmonitor, 6"
        "$mod, KP_Home, focusworkspaceoncurrentmonitor, 7"
        "$mod, KP_Up, focusworkspaceoncurrentmonitor, 8"
        "$mod, KP_Prior, focusworkspaceoncurrentmonitor, 9"

        "$mod SHIFT, KP_End, movetoworkspacesilent, 1"
        "$mod SHIFT, KP_Down, movetoworkspacesilent, 2"
        "$mod SHIFT, KP_Next, movetoworkspacesilent, 3"
        "$mod SHIFT, KP_Left, movetoworkspacesilent, 4"
        "$mod SHIFT, KP_Begin, movetoworkspacesilent, 5"
        "$mod SHIFT, KP_Right, movetoworkspacesilent, 6"
        "$mod SHIFT, KP_Home, movetoworkspacesilent, 7"
        "$mod SHIFT, KP_Up, movetoworkspacesilent, 8"
        "$mod SHIFT, KP_Prior, movetoworkspacesilent, 9"
      ];
      env = [
        "LIBVA_DRIVER_NAME,nvidia"
        "__GLX_VENDOR_LIBRARY_NAME,nvidia"
      ];
    };
  };
  programs = {
    kitty.enable = true; # required for default hyprland config

    hyprlock = {
      enable = true;
      settings = {
        general = {
          hide_cursor = true;
          ignore_empty_input = true;
        };

        animations = {
          enabled = true;
          fade_in = {
            duration = 300;
            bezier = "easeOutQuint";
          };
          fade_out = {
            duration = 300;
            bezier = "easeOutQuint";
          };
        };

        background = [
          {
            path = "screenshot";
            blur_passes = 3;
            blur_size = 8;
          }
        ];

        input-field = [
          {
            size = "200, 50";
            position = "0, -80";
            monitor = "";
            dots_center = true;
            fade_on_empty = false;
            font_color = "rgb(202, 211, 245)";
            inner_color = "rgb(91, 96, 120)";
            outer_color = "rgb(24, 25, 38)";
            outline_thickness = 5;
            placeholder_text = "'Password...'";
            shadow_passes = 2;
          }
        ];
      };
    };
  };

  services = {
    hyprpaper.enable = true;
    hyprsunset.enable = true;
    hypridle = {
      enable = true;
      settings = {
        general = {
          lock_cmd = "pidof hyprlock || hyprlock"; # avoid starting multiple hyprlock instances.
          before_sleep_cmd = "loginctl lock-session"; # lock before suspend.
          after_sleep_cmd = "hyprctl dispatch dpms on"; # to avoid having to press a key twice to turn on the display.
        };

        listener = [
          {
            timeout = 1500; # 25min.
            on-timeout = "brightnessctl -s set 10"; # set monitor backlight to minimum, avoid 0 on OLED monitor.
            on-resume = "brightnessctl -r"; # monitor backlight restore.
          }

          ## turn off keyboard backlight, comment out this section if you dont have a keyboard backlight.
          # {
          #     timeout = 1500;                                             # 25min.
          #     on-timeout = "brightnessctl -sd rgb:kbd_backlight set 0"; # turn off keyboard backlight.
          #     on-resume = "brightnessctl -rd rgb:kbd_backlight";        # turn on keyboard backlight.
          # }

          {
            timeout = 1800; # 30min
            on-timeout = "loginctl lock-session"; # lock screen when timeout has passed
          }

          {
            timeout = 1830; # 30.5min
            on-timeout = "hyprctl dispatch dpms off"; # screen off when timeout has passed
            on-resume = "hyprctl dispatch dpms on && brightnessctl -r"; # screen on when activity is detected after timeout has fired.
          }

          # {
          #     timeout = 1800;                                # 30min
          #     on-timeout = "systemctl suspend";                # suspend pc
          # }
        ];
      };

    };
  };

  # Optional, hint Electron apps to use Wayland:
  home.sessionVariables.NIXOS_OZONE_WL = "1";
}
