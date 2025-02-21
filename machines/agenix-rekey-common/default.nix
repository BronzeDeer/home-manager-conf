{config, pkgs, ...}:
{
  # By default we encode for the host key for deployment to a machine
  # sshd needs to be enabled for the host key to be present
  services.sshd.enable = true;

  age.rekey = {
    # hostPubkey should be set by the individual machines
    #hostPubkey
    masterIdentities = [ ../../age-identities/age-yubikey-5c-primary-identity-c8d44732.pub ];
    extraEncryptionPubkeys = [
      "age1yubikey1qfsmv6y756vv6t5qk7xq72gaz8ecp2d5czv58pjqxx8ltntty44ly2lssw3" # Yubikey 5c Backup
    ];

    # Using the local storage mode ensures that hosts can boot independently without user interaction or the presence of the yubikey
    # This is a deliberate tradeoff. Be aware that this means that if the machine's host key is compromised and the attacker has access to the rekeyed secrets
    # (either from the machine itself or a public repo), they can decrypt all secrets ever encrypted for that host.
    #
    # The alternative would be derivation mode, which avoids this leakage, but prohibits hosts without access to the yubikey from building and deploying new configurations for the host unless
    # we manually upload the correct derivations after each rekeying, which depending on circumstances does not actually mitigate the chance of leakage by much.
    storageMode = "local";

    #Choose a directory to store the rekeyed secrets for this host.
    # This cannot be shared with other hosts. Please refer to this path
    # from your flake's root directory and not by a direct path literal like ./secrets
    localStorageDir = ../../.. + "/secrets/rekeyed/${config.networking.hostName}";
  };
}
