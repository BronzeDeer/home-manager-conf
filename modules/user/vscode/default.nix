{ pkgs, config, ... }:
{
  programs.vscode = {
    enable = true;

    package = (config.lib.nixGL.wrap pkgs.vscode);

    profiles.default.extensions = with pkgs; [
      vscode-extensions.hashicorp.terraform
      vscode-extensions.bbenoist.nix
    ];
  };
}
