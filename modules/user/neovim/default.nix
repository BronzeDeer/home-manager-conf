{
  pkgs,
  lib,
  config,
  theming,
  ...
}:
let
  themeConfig = theming { inherit pkgs; };
in
{
  home.keyboard = {
    options = [
      "caps:escape_shifted_capslock" # caps now also works as escape, shift+caps toggles caps
    ];
  };

  programs.neovim = {
    enable = true;

    withRuby = true;
    withPython3 = true;

    plugins =
      with pkgs.vimPlugins;
      [
        telescope-nvim
        harpoon2
        nvim-treesitter.withAllGrammars
      ]
      ++ lib.optionals (theming ? "nvim-theme") [ themeConfig.nvim-theme ];
    vimAlias = true;
    defaultEditor = true;
    extraConfig = ''
      filetype plugin indent on
      set sts=2 sw=2 ts=2 expandtab smartindent
    '';
  };

  home.packages = [
    pkgs.xclip # for clipboard integration
  ];
}
