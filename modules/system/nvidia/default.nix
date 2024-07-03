{config, pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    # Allow setting fancurves for nvidia gpu
    gwe
    # Needed by some packages to support cuda acceleration
    cudaPackages.cudatoolkit
  ];

  # Allow building nixpkgs with the (unfree) cuda support
  nixpkgs.config.cudaSupport = true;

  hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
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
  };
  services.xserver.videoDrivers = ["nvidia"];

  # Enable using gpu in containers
  virtualisation.docker.enableNvidia = true;
}
