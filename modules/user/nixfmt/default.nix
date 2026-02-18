{ pkgs, lib, ... }@inputs:
{
  home.packages = [
    pkgs.nixfmt
  ];

  programs.git.settings.mergetool.nixfmt = {
    cmd = "nixfmt --mergetool \"$BASE\" \"$LOCAL\" \"$REMOTE\" \"$MERGED\"";
    trustExitCode = true;
  };
}
