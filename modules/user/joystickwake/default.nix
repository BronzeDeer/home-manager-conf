{pkgs,lib,...}@inputs:
{
  home.packages = with pkgs; [
    joystickwake
  ];

  userautostart.scriptInline = ''
    joystickwake & # As long as input is coming invia joystick (game controller), screen will not lock
  '';
}
