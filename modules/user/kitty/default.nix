# Adopted from https://github.com/sherubthakur/dotfiles/

{
  config,
  pkgs,
  theming,
  ...
}:
let
  themeConfig = theming { inherit pkgs; };
  nfSymbols = themeConfig.fonts.symbols.nerd-fonts;
  monoFont = themeConfig.fonts.mono;
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
    #theme = "${themeConfig.kitty-theme}";
    settings = {
      scrollback_lines = 10000;
      input_delay = 1;

      foreground = "${themeConfig.fg-primary}";
      background = "${themeConfig.bg-primary}";

      color0 = "${themeConfig.black}";
      color1 = "${themeConfig.red}";
      color2 = "${themeConfig.green}";
      color3 = "${themeConfig.yellow}";
      color4 = "${themeConfig.blue}";
      color5 = "${themeConfig.magenta}";
      color6 = "${themeConfig.cyan}";
      color7 = "${themeConfig.white}";
      color8 = "${themeConfig.bright-black}";
      color9 = "${themeConfig.bright-red}";
      color10 = "${themeConfig.bright-green}";
      color11 = "${themeConfig.bright-yellow}";
      color12 = "${themeConfig.bright-blue}";
      color13 = "${themeConfig.bright-magenta}";
      color14 = "${themeConfig.bright-cyan}";
      color15 = "${themeConfig.bright-white}";
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
