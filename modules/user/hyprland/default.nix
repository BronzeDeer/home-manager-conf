{
  pkgs,
  lib,
  config,
  theming,
  osConfig ? null,
  ...
}:
let
  # Migration code and helper function adopted from https://git.aquaticservers.com/aqua/AquaticOS/commit/1622b14151e13b94f2d1f81b9e8a3841098eb1cf#diff-6ef6d4045aa3c10fbbd77cc9013c2393e76ac1a7
  # After hyprconf is fully deprecated, let's hope home-manager gets better support for the conf format
  lua = lib.generators.mkLuaInline;
  mainMod = "SUPER";

  dsp = {
    exec = cmd: lua ''hl.dsp.exec_cmd("${cmd}")'';
    close = lua "hl.dsp.window.close()";
    fullscreen = lua "hl.dsp.window.fullscreen()";
    layoutmsg = msg: lua ''hl.dsp.layout("${msg}")'';
    killactive = lua "hl.dsp.window.kill(activewindow)";
    moveToWorkspaceSilent =
      ws: lua ''hl.dsp.window.move({ workspace = "${toString ws}", follow = false })'';
    focusWorkSpaceOnCurrentMonitor =
      ws: lua ''hl.dsp.focus({ workspace = "${toString ws}", on_current_monitor = true })'';
  };

  bind = keys: dispatcher: {
    _args = [
      keys
      dispatcher
    ];
  };
in

{
  home.packages = with pkgs; [
    grimblast # screenshot tool
    kooha # screen recording tool
    brightnessctl # needed for screen dimming via hypridle
    wl-clipboard-rs # terminal clipboard tools
  ];

  wayland.windowManager.hyprland = {
    configType = "lua";
    enable =
      lib.warnIfNot (osConfig == null || osConfig.programs.hyprland.enable)
        "When using hyprland via the home-manager module on nixos, programs.hyperland.enable should be set in the nixos config as well"
        true;

    systemd.enableXdgAutostart = true;

    settings = {
      config = {
        general = {
          layout = "master";
          gaps_out = 2;
          #"col.active_border" = "rgb(29315A)";
        };
        decoration = {
          active_opacity = 1;
          inactive_opacity = 0.95;
          rounding = 5;
        };

        misc = {
          mouse_move_enables_dpms = true;
          key_press_enables_dpms = true;
        };

        # TODO: should be machine relative/read from xkb
        input = {
          kb_layout = "de";
          kb_variant = "nodeadkeys";
          kb_options = (lib.join "," config.home.keyboard.options);
          numlock_by_default = true;
        };

        # Force xwayland apps (like steam) to not be a blurry wrong scaled mess
        xwayland = {
          force_zero_scaling = true;
        };
      };

      # TODO: parse from machine config field if available (need to create that module first)
      monitor = [
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

      bind = [
        # Mouse Bindings
        # Move/resize windows with mainMod + LMB/RMB and dragging
        {
          _args = [
            "${mainMod} + mouse:272"
            (lua "hl.dsp.window.drag()")
            (lua "{ mouse = true, drag = true }")
          ];
        }
        {
          _args = [
            "${mainMod} + mouse:273"
            (lua "hl.dsp.window.resize()")
            (lua "{ mouse = true, drag = true }")
          ];
        }

        # General Bindings
        (bind "${mainMod} + F" (dsp.fullscreen))
        (bind "CTRL + ALT + T" (dsp.exec "kitty")) # TODO: make terminal dynamic
        (bind "Print" (dsp.exec "grimblast copy area"))
        (bind "SHIFT + Print" (dsp.exec "kooha"))
        (bind "${mainMod} + TAB" (dsp.exec "rofi -show drun -theme grid"))
        (bind "${mainMod} + SHIFT + C" (dsp.killactive))
        (bind "${mainMod} + J" (dsp.layoutmsg "cycleprev"))
        (bind "${mainMod} + K" (dsp.layoutmsg "cyclenext"))
        (bind "${mainMod} + SHIFT + J" (dsp.layoutmsg "swapprev"))
        (bind "${mainMod} + SHIFT + K" (dsp.layoutmsg "swapnext"))
        (bind "${mainMod} + H" (dsp.layoutmsg "mfact -0.025"))
        (bind "${mainMod} + L" (dsp.layoutmsg "mfact +0.025"))
        (bind "${mainMod} + SPACE" (dsp.layoutmsg "orientationcycle left top center"))
        (bind "${mainMod} + Return" (dsp.layoutmsg "swapwithmaster ignoremaster auto"))

        (bind "CTRL + ALT + L" (dsp.exec "hyprlock --no-fade-in")) # If the lock is user triggered it should look and feel immediate, the slow fade is only for the idle

      ]
      ++ (
        # workspaces
        # binds ${mainMod} + [shift +] {1..9} to [move to] workspace {1..9}
        builtins.concatLists (
          builtins.genList (
            i:
            let
              ws = i + 1;
            in
            [
              # Xmonad style switching instead of the default which leaves workspaces on the monitor where they were last
              (bind "${mainMod} + code:1${toString i}" (dsp.focusWorkSpaceOnCurrentMonitor "${toString ws}"))
              (bind "${mainMod} + SHIFT + code:1${toString i}" (dsp.moveToWorkspaceSilent "${toString ws}"))
            ]
          ) 9
        )
      )
      # Workspace movement with Numpad keys (sadly the KP_n aliases do not work, but the aliases for numlock=false work in both state)
      ++ [
        (bind "${mainMod} + KP_End" (dsp.focusWorkSpaceOnCurrentMonitor "1"))
        (bind "${mainMod} + KP_Down" (dsp.focusWorkSpaceOnCurrentMonitor "2"))
        (bind "${mainMod} + KP_Next" (dsp.focusWorkSpaceOnCurrentMonitor "3"))
        (bind "${mainMod} + KP_Left" (dsp.focusWorkSpaceOnCurrentMonitor "4"))
        (bind "${mainMod} + KP_Begin" (dsp.focusWorkSpaceOnCurrentMonitor "5"))
        (bind "${mainMod} + KP_Right" (dsp.focusWorkSpaceOnCurrentMonitor "6"))
        (bind "${mainMod} + KP_Home" (dsp.focusWorkSpaceOnCurrentMonitor "7"))
        (bind "${mainMod} + KP_Up" (dsp.focusWorkSpaceOnCurrentMonitor "8"))
        (bind "${mainMod} + KP_Prior" (dsp.focusWorkSpaceOnCurrentMonitor "9"))

        (bind "${mainMod} + SHIFT + KP_End" (dsp.moveToWorkspaceSilent "1"))
        (bind "${mainMod} + SHIFT + KP_Down" (dsp.moveToWorkspaceSilent "2"))
        (bind "${mainMod} + SHIFT + KP_Next" (dsp.moveToWorkspaceSilent "3"))
        (bind "${mainMod} + SHIFT + KP_Left" (dsp.moveToWorkspaceSilent "4"))
        (bind "${mainMod} + SHIFT + KP_Begin" (dsp.moveToWorkspaceSilent "5"))
        (bind "${mainMod} + SHIFT + KP_Right" (dsp.moveToWorkspaceSilent "6"))
        (bind "${mainMod} + SHIFT + KP_Home" (dsp.moveToWorkspaceSilent "7"))
        (bind "${mainMod} + SHIFT + KP_Up" (dsp.moveToWorkspaceSilent "8"))
        (bind "${mainMod} + SHIFT + KP_Prior" (dsp.moveToWorkspaceSilent "9"))
      ];
      env = [
        {
          _args = [
            "LIBVA_DRIVER_NAME"
            "nvidia"
          ];
        }
        {
          _args = [
            "__GLX_VENDOR_LIBRARY_NAME"
            "nvidia"
          ];
        }
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
            animation = "fade, 1, 50, default, default";
          };
          fade_out = {
            animation = "fade, 1, 5, default, default";
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
          # avoid starting multiple hyprlock instances.
          lock_cmd = "pidof hyprlock || hyprlock --grace 5"; # give a 5 second grace to keep the screen alive without needing prompting. Aligns with the hyprlock fade-in time
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
