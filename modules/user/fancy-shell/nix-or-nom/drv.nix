{
  writeShellApplication,
  installShellFiles,
  nix-output-monitor,
  nix,
}:
writeShellApplication {
  name = "nix-or-nom";
  text = ''
    if [[ "$1" == "build" || "$1" == "shell" || "$1" == "develop" ]]; then
      ${nix-output-monitor}/bin/nom "$@"
    else
      ${nix}/bin/nix "$@"
    fi
  '';
  derivationArgs = {
    buildInputs = [ nix-output-monitor ];
    nativeBuildInputs = [ installShellFiles ];
    postCheck = ''
      installShellCompletion --cmd nix-or-nom \
      --bash ${./completion.bash} \
      --fish ${./completion.fish} \
      --zsh ${./completion.zsh}
    '';
  };
}
