# FIXME: Find way of including in home-manager with conditional pkgs.config.cudaSupport set
{config, pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    blender
  ];
}
