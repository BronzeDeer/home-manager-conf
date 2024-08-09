{pkgs, config, ...}:
{
  programs.vscode = {
    enable = true;

    package = (config.lib.nixGL.wrap pkgs.vscode);

    extensions = with pkgs; [
      vscode-extensions.hashicorp.terraform
      vscode-extensions.bbenoist.nix
    ];
  };
}
