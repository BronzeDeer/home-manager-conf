# Adapted from https://github.com/sherubthakur/d
let
  utils = import ./utils.nix;
in
rec {
  name = "tokyonight";

  gtk-theme-name = "palenight";
  gtk-icon-name = "Moka";

  font-name = "TeX Gyre Heros";
  font-size = 16;

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
}
