{
  lib,
  pkgs,
  config,
  lib',
  ...
}:
# thanks https://git.jacekpoz.pl/poz/niksos/src/commit/f8d5e7ccd9c769f7c0b564f10dff419285e75248/modules/services/greetd.nix
let
  inherit (builtins) toString;
  inherit (lib.attrsets) optionalAttrs;
  inherit (lib.meta) getExe getExe';
  inherit (lib.modules) mkIf;

  inherit (lib'.generators) toHyprConf;

  inherit (config.hjem.users.${username}) rum;

  inherit (config.local.vars.system) username;

  hyprland = config.programs.hyprland.package;

  styleCfg = config.local.style;

  hyprctl = getExe' hyprland "hyprctl";
  Hyprland = getExe' hyprland "Hyprland";

  greeter = getExe pkgs.greetd.regreet;

  hyprlandConfig = pkgs.writeText "greetd-hyprland-config" (toHyprConf {
    attrs =
      {
        misc = {
          disable_hyprland_logo = true;
          disable_splash_rendering = true;
        };
        animations = {
          enabled = false;
          first_launch_animation = false;
        };
        workspace = "1,default:true,gapsout:0,gapsin:0,border:false,decorate:false";
        monitor = "HDMI-A-1, disable";
        exec-once = "[workspace 1;fullscreen;noanim] ${greeter}; ${hyprctl} dispatch exit";
      }
      // optionalAttrs styleCfg.enable {
        env = [
          "HYPRCURSOR_THEME,${styleCfg.cursorTheme.name}"
          "HYPRCURSOR_SIZE,${toString styleCfg.cursorTheme.size}"
        ];
      };
  });
in {
  config = mkIf (config.local.vars.home.desktop == "Hyprland") {
    services.greetd = {
      enable = true;
      settings = {
        default_session.command = "${Hyprland} --config ${hyprlandConfig}";
      };
    };

    programs.regreet = {
      enable = true;
      cursorTheme = {
        inherit (styleCfg.cursorTheme) name package;
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

      extraCss = rum.gtk.css.gtk4;
    };

    security.pam.services = {
      greetd.enableGnomeKeyring = true;
      gdm-password.enableGnomeKeyring = true;
      greetd.fprintAuth = false;
    };
  };
}
