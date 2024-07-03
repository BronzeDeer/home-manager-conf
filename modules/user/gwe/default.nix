{config, pkgs, ...}:
{
  home.packages = with pkgs; [
    # Ensure green with envy is installed, even if we might shadow a system package
    gwe
  ];

  userautostart.scriptInline = ''
    # gwe sets fan curves for nvidia GPUs but needs to be running to work
    gwe --hide-window &
  '';
}
