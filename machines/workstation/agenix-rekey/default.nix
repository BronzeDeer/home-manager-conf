{config, pkgs, ...}:
{
  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDVzmffCmgHnqb08WCESCdNACjNQZy3poW8OCtbVW8tB";

  #Example secret to verify working agenix mounting
  age.secrets.test = {
    # Note that "rekeyFile" is used instead of "file" like in standard agenix
    rekeyFile = ../../../secrets/age-encrypted/test.age;
    #group = "";
    #user = "";
    #mode = "0400";
  };
}
