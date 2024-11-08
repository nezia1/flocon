{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) getExe evalModules;
  inherit (inputs) niri;
in {
  services.greetd = let
    home-config = config.home-manager.users.nezia;
    # huge thanks to https://github.com/sodiboo/system/blob/262e7e80ac9ae0511f8565713feaa8315d084025/login.mod.nix#L22-L67
    # this is needed because we are also importing the default settings
    niri-cfg-modules = evalModules {
      modules = [
        niri.lib.internal.settings-module
        (let
          cfg = home-config.programs.niri.settings;
        in {
          programs.niri.settings = {
            inherit (cfg) input outputs layout;
            hotkey-overlay.skip-at-startup = true;
            # causes a deprecation warning otherwise
            cursor = builtins.removeAttrs cfg.cursor ["hide-on-key-press"];

            window-rules = [
              {
                draw-border-with-background = false;
                clip-to-geometry = true;
                geometry-corner-radius = {
                  top-left = 8.0;
                  top-right = 8.0;
                  bottom-left = 8.0;
                  bottom-right = 8.0;
                };
              }
            ];
          };
        })
      ];
    };

    # validates config and creates a derivation
    niri-config = niri.lib.internal.validated-config-for pkgs config.programs.niri.package niri-cfg-modules.config.programs.niri.finalConfig;
  in {
    enable = true;
    settings = {
      default_session = let
        niri = getExe config.programs.niri.package;
        regreet = getExe config.programs.regreet.package;
        # needed because we need to run niri msg quit inside of niri itself (it needs the socket)
        greeterScript = pkgs.writeScript "greeter-script" ''
          ${regreet} && ${niri} msg action quit --skip-confirmation
        '';
      in {
        command = "${niri} -c ${niri-config} -- ${greeterScript}";
        user = "greeter";
      };
    };
  };
  programs.regreet = {
    enable = true;
    theme = {
      inherit (config.theme.gtk.theme) name package;
    };
    iconTheme = {
      inherit (config.theme.gtk.iconTheme) name package;
    };
    cursorTheme = {
      inherit (config.theme.cursorTheme) name package;
    };
    settings = {
      background = {
        path = config.theme.wallpaper;
        fit = "Fill";
      };
      GTK = {
        application_prefer_dark_theme = true;
      };
    };
  };
  security.pam.services = {
    login.enableGnomeKeyring = true;
    greetd.enableGnomeKeyring = true;
    greetd.fprintAuth = false;
  };
}
