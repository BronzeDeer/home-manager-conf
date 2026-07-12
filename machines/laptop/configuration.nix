# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running `nixos-help`).

{ config, pkgs, ... }:

{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
    # Define correct Bus IDs to get optimus working
    ./optimus.nix
    # Enable Pipewire for sound
    ../../modules/system/pipewire
    # Steam needs to be enabled on system-level due to firewall changes among other things
    ../../modules/system/steam
    ../../modules/system/bluetooth
  ];

  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = false;
  boot.loader.efi.canTouchEfiVariables = true;

  # Boot and LUKS settings
  boot.loader.grub = {
    enable = true;
    device = "nodev";
    efiSupport = true;
    enableCryptodisk = true;
    gfxmodeEfi = "1280x720";
    # Automatically detect other OSes
    useOSProber = true;
  };

  boot.initrd.luks.devices = {
    cryptroot = {
      device = "/dev/mapper/main-nixos--root";
      allowDiscards = true;
      # Allow unlocking cryptroot with fido2 device if enrolled
      crypttabExtraOpts = [ "fido2-device=auto" ];
    };
  };
  # Allow unlocking cryptroot with fido2 device if enrolled
  boot.initrd.systemd.enable = true;

  boot.tmp.cleanOnBoot = true;

  networking.hostName = "nixos-laptop"; # Define your hostname.
  # Pick only one of the below networking options.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true; # Easiest to use and most distros use this by default.

  hardware.usb-modeswitch.enable = true; # Needed for certain usb wifi adapters including android usb tethering

  hardware.nvidia.branch = "legacy_580"; # Required since the stable branch has abandoned support for 965M

  # Set your time zone.
  time.timeZone = "Europe/Amsterdam";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "en_US.UTF-8";
  console = {
    font = "Lat2-Terminus16";
    # keyMap = "de";
    useXkbConfig = true; # use xkbOptions in tty.
  };

  # Enable the X11 windowing system.
  services.xserver.enable = true;
  services.xserver.desktopManager = {
    xterm.enable = false;
  };
  services.displayManager = {
    defaultSession = "none+i3";
    sddm = {
      enable = true;
      wayland.enable = true;
    };
  };
  services.xserver.windowManager.i3 = {
    enable = true;
    extraPackages = with pkgs; [
      dmenu
      i3status
      i3blocks
    ];
  };

  # Many screen lockers use i3lock as a base which has a hardcoded pam service it looks for
  # A pam service cannot be added from a user-profile, so enable this by default
  # This used to always enabled by default, until https://github.com/NixOS/nixpkgs/pull/399051
  security.pam.services.i3lock.enable = true;

  services.udev.packages = with pkgs; [
    yubikey-personalization
  ];

  # Configure keymap in X11
  services.xserver.xkb = {
    layout = "de";
    variant = "nodeadkeys";
  };
  # services.xserver.xkbOptions = "eurosign:e,caps:escape";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  # sound.enable = true;
  # hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).
  # services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.joel = {
    isNormalUser = true;
    extraGroups = [
      "wheel" # Enable ‘sudo’ for the user.
      "docker" # Enable interacting with the docker daemon
      "scanner"
      "lp" # Enable interacting with scanners
    ];
    packages = with pkgs; [
      firefox
      tree
    ];
    shell = pkgs.zsh;
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    fastfetch
    git
    home-manager
  ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = false;
  };
  programs.dconf.enable = true;

  programs.zsh = {
    enable = true;
    enableCompletion = true;
    # Allow users to decide when and if they want to compinit
    enableGlobalCompInit = false;
  };

  programs.ssh = {
    startAgent = true;
  };

  security.pam.services = {
    login.u2fAuth = true;
    sudo.u2fAuth = true;
  };

  security.pam.u2f.settings = {
    # Tell user we are waiting for u2f input/touch
    cue = true;
    # The keyid in the u2f key is dependent on "origin" which defaults to hostname if unset
    # This is the automatically derived origin that was created when the u2f_keys file was created
    # This ensures that this works across machines
    origin = "pam://nixos-workstation";
  };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # Does not work with flakes (but they are version controled any way so no need)
  # system.copySystemConfiguration = true;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It's perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "23.05"; # Did you read the comment?

}
