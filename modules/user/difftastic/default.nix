{
  pkgs,
  lib,
  config,
  ...
}@inputs:
let
  cfg = config.programs.difftastic;
  difftCommand = "${lib.getExe cfg.package} ${lib.cli.toCommandLineShellGNU { } cfg.options}";
in
{
  programs.difftastic = {
    enable = true;
    jujutsu.enable = lib.mkDefault config.programs.jujutsu.enable;
  };

  programs.git.settings = {
    # Replicate the git integration settings here in a way that plays nice with delta being enabled at the same time
    diff.external = difftCommand;
    diff.tool = lib.mkDefault "difftastic";
    difftool.difftastic.cmd = "${difftCommand} $LOCAL $REMOTE";

    alias = {
      dlog = "-c diff.external=difft log --ext-diff";
      dshow = "-c diff.external=difft show --ext-diff";
      ddiff = "-c diff.external=difft diff";
    };
  };
}
