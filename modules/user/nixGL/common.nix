# Adds a helper method to wrap OpenGL applications transparently on non-nixOS systems
# The core problem is well summarized in https://alternativebit.fr/posts/nixos/nix-opengl-and-ubuntu-integration-nightmare/
# However we use nixGL which solves the problem at build time (by including a lot of opengl libs) rather than requiring systems to have nixglhost setup
{ config, pkgs,... }:
{

  imports = [
    # Can be removed once home-manager itself has merged https://github.com/nix-community/home-manager/pull/5355
    # Then this wrapper should probably be included conditionally based on home-manager version
    (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/Smona/home-manager/f54a6b00768eabf72a075043a320d64d13972b8e/modules/misc/nixgl.nix";
      sha256 = "0g5yk54766vrmxz26l3j9qnkjifjis3z2izgpsfnczhw243dmxz9";
    })
  ];
}
