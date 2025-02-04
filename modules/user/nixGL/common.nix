# Adds a helper method to wrap OpenGL applications transparently on non-nixOS systems
# The core problem is well summarized in https://alternativebit.fr/posts/nixos/nix-opengl-and-ubuntu-integration-nightmare/
# However we use nixGL which solves the problem at build time (by including a lot of opengl libs) rather than requiring systems to have nixglhost setup
{ config, pkgs, nixgl, ... }:
{

  nixGL = {
    packages = nixgl.packages; # you must set this or everything will be a noop
  };
}
