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
  };
  services.xserver.videoDrivers = ["nvidia"];
}
