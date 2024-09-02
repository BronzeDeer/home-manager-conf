{config, pkgs, lib, ...}:
{
  options= {
    # Instead of enabling cudaSupport for all packages, set custom flag to indicate that cudaSupport is available on this system
    _cudaSupportAvailable = lib.options.mkOption {
      default = true;
      type = lib.types.bool;
      readOnly = true;
    };
  };

  config = {

    environment.systemPackages = with pkgs; [
      # Allow setting fancurves for nvidia gpu
      gwe
      # Needed by some packages to support cuda acceleration
      cudaPackages.cudatoolkit
    ];

    hardware.graphics = {
      enable = true;
      enable32Bit = true;
      extraPackages = with pkgs; [
        # Video acceleration
        nvidia-vaapi-driver
        vaapiVdpau
      ];
    };

    #libva doesn't seem to be able to query for the driver correctly, so we have to hint which driver we want
    environment.sessionVariables = { LIBVA_DRIVER_NAME="nvidia"; };

    hardware.nvidia = {
      modesetting.enable = true;
      nvidiaSettings = true;
      # Experimental support for better resume from sleep
      powerManagement.enable = true;
      open = false;
    };
    services.xserver.videoDrivers = ["nvidia"];

    # Enable using gpu in containers
    hardware.nvidia-container-toolkit.enable = true;
  };
}
