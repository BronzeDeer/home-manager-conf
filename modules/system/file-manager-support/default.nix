{ config, pkgs, ... }:
{
  environment.systemPackages = with pkgs; [
    #Needed for mtp mounts
    jmtpfs
  ];

  # Enable auto-mounting of disks
  services.udisks2.enable = true;

  # Enable mounting mtp, sftp etc via userspace virtual file-systems
  services.gvfs.enable = true;
}
