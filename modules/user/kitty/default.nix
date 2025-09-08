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
    nerd-fonts.symbols-only
  ];

  programs.kitty = {
    enable = true;

    package = (config.lib.nixGL.wrap pkgs.kitty);

    font.name = "Fira Mono";
    font.package = pkgs.fira-mono;
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
    extraConfig = ''
      # - Use additional nerd symbols
      # See https://github.com/be5invis/Iosevka/issues/248
      # See https://github.com/ryanoasis/nerd-fonts/wiki/Glyph-Sets-and-Code-Points
      # Seti-UI + Custom
      symbol_map U+E5FA-U+E62B Symbols Nerd Font
      # Devicons
      symbol_map U+E700-U+E7C5 Symbols Nerd Font
      # Font Awesome
      symbol_map U+F000-U+F2E0 Symbols Nerd Font
      # Font Awesome Extension
      symbol_map U+E200-U+E2A9 Symbols Nerd Font
      # Material Design Icons
      symbol_map U+F500-U+FD46 Symbols Nerd Font
      # Weather
      symbol_map U+E300-U+E3EB Symbols Nerd Font
      # Octicons
      symbol_map U+F400-U+F4A8,U+2665,U+26A1,U+F27C Symbols Nerd Font
      # Powerline Extra Symbols
      symbol_map U+E0A3,U+E0B4-U+E0C8,U+E0CC-U+E0D2,U+E0D4 Symbols Nerd Font
      # IEC Power Symbols
      symbol_map U+23FB-U+23FE,U+2b58 Symbols Nerd Font
      # Font Logos
      symbol_map U+F300-U+F313 Symbols Nerd Font
      # Pomicons
      symbol_map U+E000-U+E00D Symbols Nerd Font
    '';
  };
}
