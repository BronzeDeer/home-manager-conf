# FIXME: Find way of including in home-manager with conditional pkgs.config.cudaSupport set
{config, pkgs, ...}:
{
  environment.systemPackages = with pkgs; [
    # If our custom options exists and is true, enable cudaSupport
    (blender.override { cudaSupport = (builtins.hasAttr "_cudaSupportAvailable" config) && config._cudaSupportAvailable ;})
  ];
}
