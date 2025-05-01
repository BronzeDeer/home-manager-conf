# Adopted from https://github.com/sherubthakur/dotfiles/

{
  config,
  pkgs,
  theming,
  ...
}:

{
  # Allow importing and "nerdyfing" fonts for p10k
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # Install a nerdfont patches version of our desired Font (FiraCode)
    nerd-fonts.fira-code
  ];

  programs.kitty = {
    enable = true;

    package = (config.lib.nixGL.wrap pkgs.kitty);

    font.name = "FiraCode Nerd Font Mono";
    font.size = 10;
    shellIntegration.enableZshIntegration = true;
    #theme = "${theming.kitty-theme}";
    settings = {
      scrollback_lines = 10000;
      input_delay = 1;

      foreground = "${theming.fg-primary}";
      background = "${theming.bg-primary}";

      color0 = "${theming.black}";
      color1 = "${theming.red}";
      color2 = "${theming.green}";
      color3 = "${theming.yellow}";
      color4 = "${theming.blue}";
      color5 = "${theming.magenta}";
      color6 = "${theming.cyan}";
      color7 = "${theming.white}";
      color8 = "${theming.bright-black}";
      color9 = "${theming.bright-red}";
      color10 = "${theming.bright-green}";
      color11 = "${theming.bright-yellow}";
      color12 = "${theming.bright-blue}";
      color13 = "${theming.bright-magenta}";
      color14 = "${theming.bright-cyan}";
      color15 = "${theming.bright-white}";
    };
  };
}
