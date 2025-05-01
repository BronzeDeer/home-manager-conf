{ pkgs, lib, ... }@inputs:
{
  programs.coolercontrol.enable = true;
  environment.systemPackages = with pkgs; [
    lm_sensors
  ];
}
