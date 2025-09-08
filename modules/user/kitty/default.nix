# Adopted from https://github.com/sherubthakur/dotfiles/

{
  config,
  pkgs,
  theming,
  ...
}:
let
  nfSymbols = theming.fonts.symbols.nerd-fonts;
  monoFont = theming.fonts.mono;
in
{
  # Allow importing and "nerdyfing" fonts for p10k
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    # Install a nerdfont patches version of our desired Font (FiraCode)
    nerd-fonts.fira-code
    monoFont.pkg
    nfSymbols.pkg
  ];

  programs.kitty = {
    enable = true;

    package = (config.lib.nixGL.wrap pkgs.kitty);

    font.name = monoFont.name;
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
      symbol_map U+E5FA-U+E62B ${nfSymbols.name}
      # Devicons
      symbol_map U+E700-U+E7C5 ${nfSymbols.name}
      # Font Awesome
      symbol_map U+F000-U+F2E0 ${nfSymbols.name}
      # Font Awesome Extension
      symbol_map U+E200-U+E2A9 ${nfSymbols.name}
      # Material Design Icons
      symbol_map U+F500-U+FD46 ${nfSymbols.name}
      # Weather
      symbol_map U+E300-U+E3EB ${nfSymbols.name}
      # Octicons
      symbol_map U+F400-U+F4A8,U+2665,U+26A1,U+F27C ${nfSymbols.name}
      # Powerline Extra Symbols
      symbol_map U+E0A3,U+E0B4-U+E0C8,U+E0CC-U+E0D2,U+E0D4 ${nfSymbols.name}
      # IEC Power Symbols
      symbol_map U+23FB-U+23FE,U+2b58 ${nfSymbols.name}
      # Font Logos
      symbol_map U+F300-U+F313 ${nfSymbols.name}
      # Pomicons
      symbol_map U+E000-U+E00D ${nfSymbols.name}
    '';
  };
}
