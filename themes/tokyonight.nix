# Adapted from https://github.com/sherubthakur/d
let
  utils = import ./utils.nix;
in
{ pkgs }@inputs:
rec {
  name = "tokyonight";

  gtk-theme-name = "palenight";
  gtk-icon-name = "Moka";

  font-name = fonts.propo.name;
  font-size = 16;

  fonts = {
    mono = {
      # The base mono font to be used
      name = "Fira Mono";
      pkg = pkgs.fira-mono;

      # The mono base font with icons patched in
      # Every application implementing font-fallback should use the base font and the relevant symbols font separately to avoid problems with patched fonts
      icon-patched = {
        name = "FiraCode Nerd Font Mono";
        pkg = pkgs.nerd-fonts.fira-code;
      };
    };
    propo = {
      name = "TeX Gyre Heros";
      pkg = pkgs.tex-gyre;
    };
    symbols = {
      nerd-fonts = {
        name = "Symbols Nerd Font";
        pkg = pkgs.nerd-fonts.symbols-only;
      };
    };
  };

  bg-primary = "#24283b";
  bg-primary-bright = "#1f2335";
  bg-primary-transparent-argb = utils.transparentify accent-primary;
  bg-primary-bright-transparent-argb = utils.transparentify bg-primary-bright;
  fg-primary = bright-white;
  fg-primary-bright = "#fefefe";

  accent-primary = blue;
  accent-secondary = magenta;
  accent-tertiary = "#ffb86c";

  alert = red;
  warning = yellow;

  black = "#15161E";
  red = "#f7768e";
  green = "#9ece6a";
  yellow = "#e0af68";
  blue = "#7aa2f7";
  magenta = "#bb9af7";
  cyan = "#7dcfff";
  white = "#a9b1d6";
  bright-black = "#414868";
  bright-red = "#f7768e";
  bright-green = "#9ece6a";
  bright-yellow = "#e0af68";
  bright-blue = "#7aa2f7";
  bright-magenta = "#bb9af7";
  bright-cyan = "#7dcfff";
  bright-white = "#c0caf5";

  deadd-css-file = ../modules/user/deadd/tokyonight.css;

  nvim-theme = {
    plugin = pkgs.vimPlugins.tokyonight-nvim;
    config = "colorscheme tokyonight";
  };
}
