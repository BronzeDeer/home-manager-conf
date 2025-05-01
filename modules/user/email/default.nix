{
  config,
  pkgs,
  lib,
  ...
}:
let
  zohoImap = {
    host = "imappro.zoho.eu";
    port = 993;
    tls.enable = true;
  };
  zohoSmtp = {
    host = "smtppro.zoho.eu";
    port = 465;
    tls.enable = true;
  };
in
{
  accounts.email.accounts = {
    gmx = {
      thunderbird.enable = true;

      realName = "Joël Pepper";
      address = "wl4life@gmx.net";
      aliases = [ "joel.pepper@gmx.net" ];

      userName = "wl4life@gmx.net";

      imap = {
        host = "imap.gmx.net";
        port = 993;
        tls.enable = true;
      };
      smtp = {
        host = "mail.gmx.net";
        port = 465;
        tls.enable = true;
      };
    };
    "BronzeDeer (Privat)" = {
      primary = true;
      thunderbird.enable = true;

      realName = "Joël Pepper";
      address = "joel@bronze-deer.de";

      userName = "joel@bronze-deer.de";

      imap = zohoImap;
      smtp = zohoSmtp;
    };
    "BronzeDeer (Work)" = {
      thunderbird.enable = true;

      realName = "Joël Pepper";
      address = "pepper@bronze-deer.de";

      userName = "pepper@bronze-deer.de";

      imap = zohoImap;
      smtp = zohoSmtp;
    };
    "BronzeDeer (Info)" = {
      thunderbird.enable = true;

      realName = "Joël Pepper";
      address = "info@bronze-deer.de";

      userName = "info@bronze-deer.de";

      imap = zohoImap;
      smtp = zohoSmtp;
    };
  };

  programs.thunderbird = {
    enable = true;
    profiles.default = {
      isDefault = true;
    };
  };
}
