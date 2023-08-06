{ config, pkgs, ...}:
{

  programs.zsh = {
    shellAliases = {
      k = "kubectl";
    };
  };

  home.packages = with pkgs; [
    kubectl
    kubectx
    kustomize
    yq
    k9s
  ];

  # Style k9s as desired (https://k9scli.io/topics/skins/)
  #programs.k9s.skin = {};

}
