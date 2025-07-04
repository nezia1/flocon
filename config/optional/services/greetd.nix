{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;

  styleCfg = config.local.style;
in {
  config = mkIf (config.local.vars.home.desktop.type == "wm") {
    services.greetd = {
      enable = true;
      settings.terminal.vt = 1;
    };

    programs.regreet = {
      enable = true;
      cageArgs = ["-s" "-m" "last"];
      cursorTheme = {
        inherit (styleCfg.cursors.xcursor) name package;
      };
      font = {
        name = "Inter";
        package = pkgs.inter;
      };
      theme = {
        inherit (styleCfg.gtk.theme) name package;
      };
      iconTheme = {
        inherit (styleCfg.gtk.iconTheme) name package;
      };

      extraCss = config.hj.rum.misc.gtk.css.gtk4;
    };

    security.pam.services = {
      greetd.enableGnomeKeyring = true;
      gdm-password.enableGnomeKeyring = true;
      greetd.fprintAuth = false;
    };
  };
}
