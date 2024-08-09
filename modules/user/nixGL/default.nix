{
    # For now we are defaulting to the mesa driver which is pure because it doesn't depend on exact driver version
    # Nvidia compat would be impure because it would need to query installed driver version at build time
    # For now this will be fine for any productivity applications, games probably won't work well, but those are typically not installed via nix
    imports = [
        ./intel.nix
    ];
}
