{ pkgs, lib, ... }@inputs:
{
  home.packages = [
    pkgs.nixfmt-rfc-style
  ];

  programs.git.extraConfig.mergetool.nixfmt = {
    cmd = "nixfmt --mergetool \"$BASE\" \"$LOCAL\" \"$REMOTE\" \"$MERGED\"";
    trustExitCode = true;
  };
}
