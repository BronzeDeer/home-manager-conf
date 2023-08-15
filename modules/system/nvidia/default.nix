{config, pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    # Allow setting fancurves for nvidia gpu
    gwe
  ];

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    # Experimental support for better resume from sleep
    powerManagement.enable = true;
  };
  services.xserver.videoDrivers = ["nvidia"];

  # Enable using gpu in containers
  virtualisation.docker.enableNvidia = true;
}
