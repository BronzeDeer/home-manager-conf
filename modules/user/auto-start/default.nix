{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.userautostart;
in
{
  options = {
    userautostart = {

      enable = mkOption {
        type = types.bool;
        default = true;
      };

      # Other packages can add lines to the startup script here
      scriptInline = mkOption {
        type = types.lines;
        default = ''
          #debug inline
          whoami >> ~/autostart-debug.log
        '';
      };

      entrypoint = mkOption {
        type = types.str;
        default = "${config.home.homeDirectory}/autostart.sh";
      };
    };
  };
  config = mkIf cfg.enable {
    # decide on how to divide between user and system and writeScriptBin vs home-manager file

    home.file.autostart = {
      target = cfg.entrypoint;
      executable = true;
      text =
        ''
          #!/${pkgs.stdenv.shell}
          # debug
          date +%F-%H-%M-%S >> ~/autostart-debug.log
        ''
        + cfg.scriptInline;
    };
  };
}
