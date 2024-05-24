{config, pkgs, lib, ...}:
{
  home.packages = with pkgs; [
    ausweisapp
  ];

  userautostart.scriptInline = ''
    AusweisApp & # Note this will launch the UI, there seems to be no "launch to tray" option here
  '';
}
