{
  pkgs,
  config,
  theming,
  ...
}:
let
  # Vscode does not implement font fallback, so it needs a single patched font
  monoFont = theming.fonts.mono.icon-patched;
in
{
  home.packages = [
    monoFont.pkg
  ];

  programs.vscode = {
    enable = true;

    package = (config.lib.nixGL.wrap pkgs.vscode);


    profiles.default = {
      userSettings = {
        "editor.fontFamily" = monoFont.name;
        "editor.fontSize" = theming.font-size;
        "files.eol" = "\n";
        "editor.tabSize" = 2;
        "editor.renderWhitespace" = "all";

        "git.openRepositoryInParentFolders" = "always";

        "terminal.integrated.fontLigatures.enabled" = false;
        "terminal.integrated.gpuAcceleration" = "on";

        "python.analysis.typeCheckingMode" = "strict";
      };

      extensions = with pkgs; [
        vscode-extensions.hashicorp.terraform
        vscode-extensions.jnoortheen.nix-ide
        vscode-extensions.mkhl.direnv
        vscode-extensions.eamodio.gitlens
        vscode-extensions.ms-vsliveshare.vsliveshare
        vscode-extensions.redhat.vscode-yaml
      ];
    };
  };
}
