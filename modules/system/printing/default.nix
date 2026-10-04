{ config, pkgs, ... }:
{
  services.printing.enable = true;
  services.printing.drivers = [ ];
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  # for a WiFi printer
  services.avahi.openFirewall = true;

  # Enable scanner support
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ ];
  # Simple graphical scanning utility
  environment.systemPackages = [ pkgs.simple-scan ];
}
