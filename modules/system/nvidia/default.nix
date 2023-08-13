{config, pkgs, ...}:
{

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
}
