{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.webappify;
  appOptions = {
    options = {
      name = mkOption {
        type = types.str;
        default = builtins.match "^.*://([^/]+)(/.*)?$" options.url;
      };
      url = mkOption {
        type = types.str;
      };
      browserCommand = mkOption {
        type = types.str;
        default = cfg.browserCommand;
      };
      dataDirBase = mkOption {
        type = types.str;
        default = cfg.dataDirBase;
        description = ''
          Base directory under wich the indidividual browser profile for this app will be created.
        '';
      };
      icon = mkOption {
        type = types.nullOr types.path;
        default = null;
      };
    };
  };
  mkApp = (
    app: rec {
      name = sanitizeName app.name;
      prettyName = app.name;
      command = "${cfg.browserCommand} \"--app=${app.url}\" \"--user-data-dir=${dataDir}\" \"--class=${prettyName}\" \"--no-first-run\"";
      dataDir = strings.normalizePath "${app.dataDirBase}/${name}";
      desktopEntry =
        {
          name = prettyName;
          exec = command;
          settings = {
            # Set different window manager classes to avoid app grouping
            StartupWMClass = prettyName;
          };
        }
        // optionalAttrs (app.icon != null) {
          icon = app.icon;
        };
    }
  );
  # Convert human readable name to more machine-friendly format of lowercase alphanum and "_"
  # First all characters are lowercased, then all sequences of characters that are not in [a-z0-9] are replaced with a single underscore
  sanitizeName = (
    n:
    strings.concatStringsSep "_" (
      builtins.filter (x: builtins.typeOf x == "string" && builtins.stringLength x > 0) (
        # We check for empty string to remove ignore illegal characters at start and end of string
        builtins.split "[^a-z0-9]" (strings.toLower n)
      )
    )
  );
in
{
  options = {
    webappify = {

      enable = mkOption {
        type = types.bool;
        default = true;
      };

      browserCommand = mkOption {
        type = types.str;
        default = "chromium";
        description = ''
          Command that provides a chromium-based browser to use for the webapp.
          The browser executable needs to support the "--app" and "--user-data-dir" flages
          Due to quirks in chromium sandboxing, chromium needs to be configured by the system/root on some hosts.
          Accessing chromium via $PATH, rather than direct reference is less nix-like but avoids tight, potentially impure coupling with the host.
          On a platform that allows for properly sandboxed chromium installed via home-manager, set this option to
          `\${p.outPath}/bin/\${p.pname}`, where `p` is the chromium providing package installed via home-manager.
          (This is necessary since the launcher will likely not have the correct path from your shell)
          UNSAFE: As a last resort, the command can be set to the home-manager installed binary and the flag `--no-sandbox` to avoid any need to system packages.
          This however massively increases the blast radius of any browser vulnerabilities
        '';
      };

      dataDirBase = mkOption {
        type = types.str;
        default = "${config.home.homeDirectory}/chromium-config/webappify-browser-profiles";
        description = ''
          Base directory under wich the indidividual browser profiles will be created.
          Defaults to $HOME/chromium-config/webappify-browser-profiles.
          This path is specifically choosen to also work out of the box with snap chromium, which can only write to $HOME/chromium-config
        '';
      };

      appIdPrefix = mkOption {
        type = types.str;
        default = "chromium_chromium";
        description = ''
          Sandbox app id prefix of the browser running the webapp. This is required when running under certain DEs (like gnome-shell)
          while using a chromium sandboxed through flatpak or snap. This is the default case on Ubuntu for example.
          When dealing with sandboxed apps, gnome-shell disregards the DesktopEntry specification and only matches desktop files
          that are prefixed with the apps sandbox id
          compare: https://bugs.launchpad.net/ubuntu/+source/chromium-browser/+bug/1891649 and https://gitlab.gnome.org/GNOME/gnome-shell/-/merge_requests/1357
          By setting the correct prefix for our generated desktop files we can restore the functionality of individual icons and ungrouped windows for the webapps
          according to the WM_CLASS xprop
        '';
      };

      apps = mkOption {
        type = types.listOf (types.coercedTo types.str (s: { url = s; }) (types.submodule appOptions));
        default = [ ];
      };
    };
  };
  config = mkIf cfg.enable (
    let
      apps = map mkApp cfg.apps;
    in
    {
      xdg.desktopEntries = listToAttrs (
        map (app: attrsets.nameValuePair "${cfg.appIdPrefix}.${app.name}" app.desktopEntry) apps
      );
      #webappify.out.apps = listToAttrs(map (app : attrsets.nameValuePair app.name app) apps);
    }
  );
}
