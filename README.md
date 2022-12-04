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
