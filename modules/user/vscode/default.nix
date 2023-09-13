{pkgs, config, ...}:
{
  programs.vscode = {
    enable = true;
    extensions = with pkgs; [
      vscode-extensions.hashicorp.terraform
      vscode-extensions.bbenoist.nix
    ];
  };
}
