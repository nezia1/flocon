{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.meta) getExe getExe';
  inherit (lib.strings) escapeShellArgs;

  # TODO: setup monitors with NixOS options, so that this may be setup for the main monitor of both desktop and laptop
  run-regreet = pkgs.writeShellScript "run-regreet" ''
    ${getExe pkgs.wlr-randr} \
      --output eDP-1 \
      --scale 1.33
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
