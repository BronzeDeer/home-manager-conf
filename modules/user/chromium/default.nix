{config, pkgs, ...}:
{
  programs.chromium = {
    enable = true;
    extensions = with pkgs; [
      "cjpalhdlnbpafiamejdnhcphjbkeiagm" #uBlock Origin
    ];
  };
}
