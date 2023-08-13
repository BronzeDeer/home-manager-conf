# Adopted from github.com/sherubthakur/dotfiles
{ pkgs, theming, ... }: {

  home.packages = with pkgs; [
    # allow rofi to insert emojis via fake keyboard input (X11)
    xdotool
    # allow rofi to insert emojis via fake keyboard input (Wayland)
    # wtype
  ];

  programs.rofi = {
    enable = true;
    plugins = [ pkgs.rofi-emoji pkgs.rofi-calc pkgs.rofi-file-browser ];
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
    font = "${theming.font-name} ${toString theming.font-size}";
  };
  home.file.".config/rofi/colors.rasi".text = ''
    * {
      accent: ${theming.accent-primary};
      accent-secondary: ${theming.accent-secondary};
      background: ${theming.bg-primary};
      foreground: ${theming.fg-primary};
    }
  '';
  home.file.".config/rofi/grid.rasi".source = ./grid.rasi;
  home.file.".config/rofi/launcher.rasi".source = ./launcher.rasi;
}
