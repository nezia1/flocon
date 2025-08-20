{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (builtins) toString;
  inherit (lib.lists) findFirst;
  inherit (lib.meta) getExe getExe';
  inherit (lib.strings) escapeShellArgs;
  primaryMonitor = findFirst (m: m.primary) null config.local.monitors;

  run-regreet = pkgs.writeShellScript "run-regreet" ''
    ${getExe pkgs.wlr-randr} \
      --output ${primaryMonitor.name} \
      --scale ${toString primaryMonitor.scale}
    exec ${getExe config.programs.regreet.package}
  '';

  styleCfg = config.local.style;
in {
  config = {
    services.greetd = {
      enable = true;
      settings = {
        terminal.vt = 1;
        default_session.command = toString [
          (getExe' pkgs.dbus "dbus-run-session")
          (getExe pkgs.cage)
          (escapeShellArgs config.programs.regreet.cageArgs)
          run-regreet
        ];
      };
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
        name = "Adwaita";
        package = pkgs.adwaita-icon-theme;
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
