{ config, pkgs, ... }:
let
  # maestral is lightweight linux and mac client for dropbox
  mstrl = pkgs.maestral-gui;
in
{
  home.packages = with pkgs; [
    mstrl
    dex # platform agnostic .desktop launcher
  ];

  userautostart.scriptInline = ''
    # dex is overly strict around spaces surrounding the equal signs, even in valid desktop files
    # patching the derivation would be bit overkill, so we just fix it "inline" (can't make dex launch from /proc/self/fd sadly) with sed
    sed 's/ = /=/g' < ${mstrl}/share/applications/*.desktop > /tmp/maestral-fixed.desktop
    dex /tmp/maestral-fixed.desktop;
    rm /tmp/maestral-fixed.desktop;
  '';
}
