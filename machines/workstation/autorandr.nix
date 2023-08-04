{ config, pkgs, ...}:

{
  # Run autorandr once at the start of the display manager
  services.xserver.displayManager.setupCommands = "${pkgs.autorandr}/bin/autorandr -c";
  services.autorandr = {
    enable = true;
    defaultTarget = "default";
    profiles = {
      "default" = {
        fingerprint = {
          # LG Middle
          DP-4 = "00ffffffffffff001e6d095b3d2902000c1b0104b53c22789e3035a7554ea3260f50542108007140818081c0a9c0d1c08100010101014dd000a0f0703e803020650c58542100001a286800a0f0703e800890650c58542100001a000000fd00383d1e8738000a202020202020000000fc004c4720556c7472612048440a20012c0203117144900403012309070783010000023a801871382d40582c450058542100001e565e00a0a0a029503020350058542100001a0000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000c8";
          # Acer Left
          DP-3 = "00ffffffffffff0004722b019d1170142f15010380341d782aeed5a555489b26125054bfef80714f810081809500950fb300d1c00101023a801871382d40582c450009252100001e000000fd00384b1e5311000a202020202020000000fc0041636572204732343548510a20000000ff004c4b4b3057303134343334300a0111020321324f010203040590111213149f060715166c030c00100080a5c000000000023a80d072382d40102c9680092521000018011d8018711c1620582c250009252100009e011d80d0721c1620102c258009252100009e023a80d072382d40102c258009251200001e00000000000000000000000000000000000000000000dc";
          # Acer Right
          HDMI-0 = "00ffffffffffff0004722b01481470142f15010380341d782aeed5a555489b26125054bfef80714f810081809500950fb300d1c00101023a801871382d40582c450009252100001e000000fd00384b1e5311000a202020202020000000fc0041636572204732343548510a20000000ff004c4b4b3057303134343334300a0163020321324f010203040590111213149f060715166c030c00100080a5c000000000023a80d072382d40102c9680092521000018011d8018711c1620582c250009252100009e011d80d0721c1620102c258009252100009e023a80d072382d40102c258009251200001e00000000000000000000000000000000000000000000dc";
        };
        config = {
          DP-3 = {
            enable = true;
            primary = false;
            position = "0x0";
            mode = "1920x1080";
            rate = "60.00";
            transform = [
              [ 2.0 0.0 0.0 ]
              [ 0.0 2.0 0.0 ]
              [ 0.0 0.0 1.0 ]
            ];
          };
          DP-4 = {
            enable = true;
            primary = true;
            position = "3840x0";
            mode = "3840x2160";
            rate = "60.00";
          };
          HDMI-0 = {
            enable = true;
            primary = false;
            position = "7680x0";
            mode = "1920x1080";
            rate = "60.00";
            transform = [
              [ 2.0 0.0 0.0 ]
              [ 0.0 2.0 0.0 ]
              [ 0.0 0.0 1.0 ]
            ];
          };
        };
      };
    };
  };
}
