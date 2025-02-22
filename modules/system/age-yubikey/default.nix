{config, pkgs,...}:
{
  # We use a yubikey as identities, this needs extra support on the system
  services.pcscd.enable = true; #Allows us to access the Yubikey via the SCard API (PC/SC)

  environment.systemPackages = with pkgs; [
    # Make default age available
    age
    # Faster rust re-implementation
    rage

    # Allow using yubikey as age identity
    age-plugin-yubikey
    
  ];
}
