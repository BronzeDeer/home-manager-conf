{
  pkgs,
  ...
}@inputs:
{
  home.packages = with pkgs; [
    (callPackage (import ./drv.nix) { })
    nix-output-monitor
  ];

  home.shellAliases = {
    # nom aliases
    nix = "nix-or-nom";
    nix-shell = "nom-shell";
    nix-build = "nom-build";
  };

}
