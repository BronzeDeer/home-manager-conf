{ config, pkgs,... }:
let
    nixGLPackage = pkgs.nixgl.nixGLIntel;
in
{
    imports = [ ./common.nix ];
    home.packages = [
        nixGLPackage
    ];

    nixGL = {
        defaultWrapper = "mesa"; # choose from options
    };
}
