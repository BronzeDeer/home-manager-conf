# Adopted from github.com/sherubthakur/dotfiles
{ pkgs, theming, ... }:
let
  themeConfig = theming { inherit pkgs; };
in
{

  home.packages = with pkgs; [
    # allow rofi to insert emojis via fake keyboard input (X11)
    xdotool
    # allow rofi to insert emojis via fake keyboard input (Wayland)
    # wtype
  ];

  programs.rofi = {
    enable = true;
    plugins = [
      pkgs.rofi-emoji
      pkgs.rofi-calc
      pkgs.rofi-file-browser
    ];
    extraConfig = {
      modes = [
        "window"
        "drun"
        "run"
        "ssh"
        "filebrowser"
        "calc"
        "emoji"
      ];
    };
    font = "${themeConfig.font-name} ${toString themeConfig.font-size}";
  };
  home.file.".config/rofi/colors.rasi".text = ''
    * {
      accent: ${themeConfig.accent-primary};
      accent-secondary: ${themeConfig.accent-secondary};
      background: ${themeConfig.bg-primary};
      foreground: ${themeConfig.fg-primary};
    }
  '';
  home.file.".config/rofi/grid.rasi".source = ./grid.rasi;
  home.file.".config/rofi/launcher.rasi".source = ./launcher.rasi;
}
