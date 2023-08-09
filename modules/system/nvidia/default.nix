{config, pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    # Allow setting fancurves for nvidia gpu
    (gwe.overrideAttrs ( old: {
      version = "0.15.5";
      src = fetchFromGitLab {
        owner = "leinardi";
        repo = old.pname;
        rev = "0.15.5";
        sha256 = "sha256-bey/G+muDZsMMU3lVdNS6E/BnAJr29zLPE0MMT4sh1c=";
      };
    }))
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
