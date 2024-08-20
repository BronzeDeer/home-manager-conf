{pkgs,lib,...}@inputs : {

    config = {
        home.packages = [
            pkgs.azure-cli
        ];
    };
}
