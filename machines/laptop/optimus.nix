{
  config,
  pkgs,
  lib,
  ...
}:
{
  # This laptop runs an older 965 which cannot use the open source modules
  hardware.nvidia.open = lib.mkForce false;
  hardware.nvidia.prime = {
    intelBusId = "PCI:0:2:0";
    nvidiaBusId = "PCI:1:0:0";
  };
}
