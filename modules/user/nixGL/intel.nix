{ config, pkgs,... }:
let
    nixGLPackage = pkgs.nixgl.nixGLIntel;
in
{
    imports = [ ./common.nix ];
    home.packages = [
        nixGLPackage
    ];

    nixGL.prefix = "${nixGLPackage}/bin/nixGLIntel";
}
