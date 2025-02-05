{
  lib,
  inputs,
  pkgs,
  config,
  lib',
  ...
}:
# thanks https://git.jacekpoz.pl/poz/niksos/src/commit/f8d5e7ccd9c769f7c0b564f10dff419285e75248/modules/services/greetd.nix
let
  inherit (lib.attrsets) optionalAttrs;
  inherit (lib.meta) getExe getExe';

  inherit (inputs.hyprland.packages.${pkgs.stdenv.system}) hyprland;
  inherit (lib'.generators) toHyprConf;

  styleCfg = config.local.style;

  hyprctl = getExe' hyprland "hyprctl";
  Hyprland = getExe' hyprland "Hyprland";

  greeter = getExe pkgs.greetd.gtkgreet;

  hyprlandConfig = pkgs.writeText "greetd-hyprland-config" (toHyprConf {
    attrs =
      {
        misc = {
          disable_hyprland_logo = true;
          force_default_wallpaper = false;
          focus_on_activate = true;
        };

        animations = {
          enabled = false;
          first_launch_animation = false;
        };
        workspace = "1,default:true,gapsout:0,gapsin:0,border:false,decorate:false";

        exec-once = [
          "[workspace 1;fullscreen;noanim] ${greeter} -l; ${hyprctl} dispatch exit"
          "${hyprctl} dispatch focuswindow ${greeter}"
        ];
      }
      // optionalAttrs styleCfg.enable {
        env = [
          "HYPRCURSOR_THEME,${styleCfg.cursorTheme.name}"
          "HYPRCURSOR_SIZE,${toString styleCfg.cursorTheme.size}"
        ];
      };
  });
in {
  # TODO: perhaps turn this into a more generic module if we wanna use other wayland compositors
  config = lib.mkIf config.local.modules.hyprland.enable {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${Hyprland} --config ${hyprlandConfig}";
          user = config.local.systemVars.username;
        };
      };
    };

    security.pam.services = {
      gdm-password.enableGnomeKeyring = true;
      greetd.fprintAuth = false;
    };

    environment.etc."greetd/environments".text = let
      environments = [
        {
          name = "Hyprland";
          condition = with config.programs.hyprland; enable && !withUWSM;
        }
        {
          name = "uwsm start -S hyprland-uwsm.desktop";
          condition = with config.programs.hyprland; enable && withUWSM;
        }
        {
          name = "sway";
          condition = config.programs.sway.enable;
        }
      ];
    in
      builtins.concatStringsSep "\n" (map (env: env.name) (builtins.filter (env: env.condition) environments));
  };
}
