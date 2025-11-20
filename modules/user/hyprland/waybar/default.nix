{
  pkgs,
  lib,
  config,
  ...
}@inputs:
let
  mechabar = pkgs.fetchFromGitHub {
    owner = "sejjy";
    repo = "mechabar";
    rev = "b3e41a23c0bdd091538b7c567f7b26fe291090e7";
    hash = "sha256-ZAnZtNLfoT3R9iHI+j/4T21DkE0o2M74rSe6wMlS7DM=";
  };
in
{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ''
      @import "${mechabar}/style.css";
    '';
    settings = {

      # Manual reproduction of the config.jsonc, because parsing jsonc is hard in nix without shelling out
      # This also fixes the includes to point to the paths in the store
      mainBar = {
        "include" = [
          # Current waybar has broken wildcard includes, so this is the expanded list
          "${mechabar}/modules/backlight.jsonc"
          "${mechabar}/modules/battery.jsonc"
          "${mechabar}/modules/bluetooth.jsonc"
          "${mechabar}/modules/clock.jsonc"
          "${mechabar}/modules/cpu.jsonc"
          "${mechabar}/modules/idle_inhibitor.jsonc"
          "${mechabar}/modules/memory.jsonc"
          "${mechabar}/modules/mpris.jsonc"
          "${mechabar}/modules/network.jsonc"
          "${mechabar}/modules/pulseaudio.jsonc"
          "${mechabar}/modules/temperature.jsonc"

          "${mechabar}/modules/custom/distro.jsonc"
          "${mechabar}/modules/custom/dividers.jsonc"
          "${mechabar}/modules/custom/power_menu.jsonc"
          "${mechabar}/modules/custom/system_update.jsonc"
          "${mechabar}/modules/custom/user.jsonc"

          "${mechabar}/modules/hyprland/windowcount.jsonc"
          "${mechabar}/modules/hyprland/window.jsonc"
          "${mechabar}/modules/hyprland/workspaces.jsonc"
        ];

        "modules-left" = [
          "group/user"
          
          "custom/left_div#1"
          "hyprland/workspaces"
          "custom/right_div#1"
          "hyprland/window"
        ];
        "modules-center" = [
          "hyprland/windowcount"
          "custom/left_div#2"
          "temperature"
          "custom/left_div#3"
          "memory"
          "custom/left_div#4"
          "cpu"
          "custom/left_inv#1"
          "custom/left_div#5"
          "custom/distro"
          "custom/right_div#2"
          "custom/right_inv#1"
          "idle_inhibitor"
          "clock#time"
          "custom/right_div#3"
          "clock#date"
          "custom/right_div#4"
          "network"
          "bluetooth"
          "custom/system_update"
          "custom/right_div#5"
          "custom/notification"
        ];
        "modules-right" = [
          "mpris"
          "custom/left_div#6"
          "group/pulseaudio"
          "custom/left_div#7"
          "backlight"
          "custom/left_div#8"
          "battery"
          "custom/left_inv#2"
          "custom/power_menu"
        ];

        "layer" = "top";
        "height" = 0;
        "width" = 0;
        "margin" = "0px";
        "spacing" = "0px";
        "mode" = "dock";
        "reload_style_on_change" = true;

        # Our overrides
        "custom/distro" = {
          #obviously
          format = "";
        };

        "hyprland/workspaces" = {
          all-outputs = true;
          format = "{icon}{id}{windows}";

          "hyprland/workspacetaskbar" = {
            enable = true;
          };
        };

        # TODO extract/make dynamic based on swaync includes
        "custom/notification" = {
          tooltip = true;
          format = "<span size='16pt'>{0} {icon} </span>";
          format-icons = {
            notification = "󱅫";
            none = "󰂜";
            dnd-notification = "󰂠";
            dnd-none = "󰪓";
            inhibited-notification = "󰂛";
            inhibited-none = "󰪑";
            dnd-inhibited-notification = "󰂛";
            dnd-inhibited-none = "󰪑";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };
      };

    };
  };
}
