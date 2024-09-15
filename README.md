# Initial Setup

## Install nix 
https://nixos.org/download.html
(when in doubt, try single user install)

## Enable flakes
(only applicable if this is still experimental like at time of writing)
https://nixos.wiki/wiki/Flakes#Permanent

## Bootstrap home-manager via nix

```bash
nix build --no-link .#homeConfigurations.pepper.activationPackage
"$(nix path-info .#homeConfigurations.pepper.activationPackage)"/activate
```

# Apply changes in `home.nix`

```bash
home-manager switch --flake ".#pepper"
```

# Secrets for human users (and standalone home-manager on non-NixOs)

To fulfill all of the [requirements](#motivation), this setup uses [passage](https://github.com/FiloSottile/passage), a fork of the very unixoid [password-store/`pass`](https://www.passwordstore.org/) which uses age as encryption/decryption backend rather than gpg of the original password-store. Age has better ergonomics in creating and maintaining keys, especially when interacting with yubikeys or other smartcards or security keys that can act as smart cards. The passage binary available on the path has been wrapped to point at a read-only copy of the secrets in the nix store and pointing at the preconfigured master age identity.

## Motivation

Securely handling the secrets of users in a declarative, nix-like way is very hard. Tools like [sops-nix](https://github.com/Mic92/sops-nix), [agenix](https://github.com/ryantm/agenix) (especially with [agenix-rekey](https://github.com/oddlama/agenix-rekey)) are good at configuring nix multiple NixOS machines and deploying secrets for runtime-decryption. Managing everything inside a NixOS configuration allows for fine-grained permission control and coordination between declaration and usage of a secret.

When handling multiple users across different machines, users without root rights or when wanting to reuse home-manager configurations outside of NixOS these approaches fall flat. Generally, when running as an unprivileged user, keeping decrypted secrets available at runtime by default should be avoided since the user is executing a lot of processes using their userid, all of which could easily read out all secrets available to the user. Similarly, processes running as root can easily sidestep most protections that can be put in place at user-level. If possible, user secrets should be decrypted as-needed and requiring user interaction. This frequent interaction in-turn requires certain considerations towards ergonomics:

1. Programs should be able to request their relevant secret programmatically (typically via shell command that returns the secret on stdout). Users should not be require to copy/paste secrets over from a secrets-manager on every boot
1. Short-term caching of the general unlock/decryption credentials to make both first startup of many
1. The secret store should automatically and transparently handle prompting the user for decryption credentials if not cached
1. Prompting needs to be visual/GUI based since the user doesn't invoke the password commands themself
1. Users should need to type as little as possible without weakening security, therefore security key based solutions are preferred over long complex master passphrases
1. All credentials need to be encrypted for atleast a master and a backup key (be that security or paper key) for recoverability
1. Adding and editing secrets needs to go through the flake and not the copy of the secret store on an individual system
1. The last two requirements should be ensured automatically and not require user knowledge or care


## Quickstart

### Reading out a secret

```sh
# The passage binary on the users path has been patched to point to the read-only secret store and correct age identity
# Note that when using this command inside a systemd service, make sure that the systemd user session has inherited $PATH
# e.g. systemctl --user import-environment 'PATH'
passage show debug/test
```

in home-manager

```nix
{

  accounts.email.accounts."foo@bar.com".passwordCommand = "passage show email/bar.com/foo/password"

  # If as systemd service cannot find passage, ensure PATH was exported into the user session
  # Note that importedVariables is a hidden option that is used mostly internally by home-manager modules
  # xsession.importedVariables = ["PATH"];
}

```

### Adding or editing secrets

To ensure full versioning and reproducibility all changes to secrets must be tracked in the flake and deployed to the nix store. Since the passage executable on the path is pointed at this read-only copy in the nix store it cannot add or edit secrets. The flake offers a nix devShell that shadows the existing passage with a different wrapper pointed at the r/w store inside the flake. When using `direnv` this devShell is automatically invoked when inside the flake directory.

Creating new secrets or force overwriting them does not require presence of the key-material, only editing existing secrets

```sh
REPO=/path/to/this/repo/on/disk
cd $REPO

# direnv invokes the devshell
# passage now edits the store inside the repo

# Will prompt for decryption password/Yubikey pin if secrets already exists
passage edit my/new/secret

# Programmatically update secret (useful for CI)
# Note the doubling up of the secret, since passage requires confirmation
# Inserts do not need access to the password/Yubikey since it never decrypts
passage insert -f an/existing/secret < <(cat /mounted/secret /mounted/secret)
echo "${ENV_SECRET}\n${ENV_SECRET}" | passage insert -f another/existing/secret

# Do not forget to put any new secrets on the git index
git add -N -- $PASSAGE_DIR

# Changes only become visible to the system when the new generation is copied to the nix store
# Note that some programs might need to be restarted to re-read their secrets from the store
home-manager switch --flake $REPO
```

### Changing key material

TODO: Unify passage module between devShell and home-manager
TODO: Also unify with agenix afterwards?


# Machine Secrets Management with agenix-rekey

This repository uses [agenix-rekey](https://github.com/oddlama/agenix-rekey) to encrypt manage all secrets using a central identity backed up bi a (pair of) yubikey(s). This greatly simplifies managing secrets across multiple machines or the reinstallation of a machine.

## Quickstart

Day to day operations need very little knowledge of agenix. If none of the secrets used by a machine have changed, deploying new generations to this machine will work without any additional steps. Adding hosts, adding usage of additional secrets to a host requires rekeying using the yubikey and the rekeyed secrets to be committed. Due to transparent re-encryption and caching of re-encrypted keys, every host will be able to decrypt its own secrets upon boot without interaction or presence of the key being required. The hosts use their own sshd hostkey for this, agenix-rekey only ensures that these host-specific re-encrypted secrets are up to date.

### Updating existing or creating new secrets

For more detail refer to [agenix-rekey's usage instructions](https://github.com/oddlama/agenix-rekey?tab=readme-ov-file#usage)

The devshell for this repo includes the `agenix` binary that handles all encryption based on the public keys set in the nix-store

```sh
# By convention, store the encrypted secrets in secrets/age-encrypted/
cd secrets/age-encrypted
# Open $EDITOR to create or edit my-secret.age
agenix edit my-secret.age

# Alternatively create a new secret from an existing plaintext secret
agenix edit -i /path/plaintext/secret.txt my-from-plaintext-secret.age
```

### Using a secret in a host configuration

Using the secrets inside the system configuration is very easy.

```nix
{
  # This references the master version of the secret in /secrets/age-encrypted
  # agenix-rekey transparently translates this to the corrected host-specific secret
  # Note that this is equivalent to normal age usage with the exception of using "rekeyFile" instead of "file"
  age.secrets.secret1.rekeyFile = ../relative/path/to/my-secret.age;
  services.someService.passwordFile = config.age.secrets.secret1.path;
}
```

After a new secret has been added, or the contents of the secret have changed, it is necessary to rekey the secrets when deploying this host. age-nix rekey will prompt for this automatically when running `nixos-rebuild` (or other nix deployment tool), but we can also do this ahead of time

```sh
# -a adds the rekeyed secret to the git index to ensure that it is visible to nix
# This is not necessary when using the "derivation" storage mode rather than the default of "local"
agenix rekey -a 
```

#### Using secrets for user apps through home-manager

Using secrets inside home-manager configurations is less ergonomic, since the home-manager configurations have no access to the systemConfiguration of the underlying host and the agenix-rekey module and can therefore not add secrets that should be deployed to the machine.
Therefore any secrets that are required by home-manager configurations on a system need to be declared in the system configuration

```nix
{
  age.secrets = {
    secretSpotify = {
      rekeyFile = /path/to/spotify.age;
      name = "spotify";

      # Set permissions depending on usage by user programs
      #owner = <user>;
      #group = <group>;
      #mode = 440;
    };
  };

}
```

Using secrets from home-manager (or as non-root in general) can be done by reading the decrypted secret from agenix at runtime. The secret will be present at `${nixosConfig.age.secrets.<name>.path}`. Note that the `nixosConfig` input is only available when using home-manager as nixOS module and not in standalone mode. Note that his still does not allow editing the details of the secret configuration, therefore all secrets need to be configured correctly including permissions for the correct users to interact with the secret. This creates a tight coupling between the systemConfiguration and home-manager managed users, that is not easily avoidable.

At the moment, the user is required to correctly set permissions for any secrets and ensure that the attack surface is minimal while maintaining the ability to reuse configurations between different user(name)s. A potential option is creating a group per program, creating it on all relevant machines and chowning the secret to said group and then running the program with that group. Alternatively, secrets can be divided into separate user groups that users are assigned to. Both approaches require cooperation from the system configuration in creating the correct groups and assigning users correctly.

An alternative to exporting the correct path to a secret is predicting the secret path. By default this is `/run/agenix`, but can be set via `age.secretsDir` in the system configuration. A secret named `foo` would then be available as file under the path `/run/agenix/foo`.

Maintaining parity between standalone home-manager and stand-alone home-manager in nix can be harder if the other OS does not use age(nix) to secure it's secrets


### Adding a new machine

Adding a new machine as a deployment target for rekeying is simple and needs very little individual setup.

1. Ensure that the machine configuration includes the [agenix-rekey-common module](./machines/agenix-rekey-common/). This module enables sshd service to ensure that a hostkey is present and configures the common master and backup identities used by agenix for rekeying.

1. Set the correct public key for this machine.
On the machine itself it can be found in `/etc/ssh/ssh_host_*_key.pub` or it can be obtained using `ssh-keyscan`or from `~/.ssh/known_hosts` on a client that has sshd into the machien previously \
\
 Note that if the machine has never been deployed before or it (or atleast its host key) has been regenerated, the correct pubkey is not known yet, in which case any dummy age or ssh public identity can be used (or the default value or example value below can be used, but it is impossible to ensure that nobody holds the private key to that, creating a potential leak). Deploying the machine will make it unable to decrypt the secrets but boot far enough to generate and retrieve the correct host key
 .
```nix
{
  age.rekey.hostPubkey = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIDVzmffCmgHnqb08WCESCdNACjNQZy3poW8OCtbVW8tB";
}
```
