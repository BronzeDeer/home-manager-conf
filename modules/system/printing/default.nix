{ config, pkgs, ... }:
{
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.hplipWithPlugin ];
  services.avahi.enable = true;
  services.avahi.nssmdns4 = true;
  # for a WiFi printer
  services.avahi.openFirewall = true;

  # Enable scanner support
  hardware.sane.enable = true;
  hardware.sane.extraBackends = [ pkgs.hplipWithPlugin ];
  # Simple graphical scanning utility
  environment.systemPackages = [ pkgs.simple-scan ];
}
