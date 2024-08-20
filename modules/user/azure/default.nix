{pkgs,lib,...}@inputs : {

    config = {
        home.packages = with pkgs; [
            azure-cli
            kubelogin
            kubelogin-oidc
        ];
    };
}
