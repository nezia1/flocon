{
  lib,
  inputs,
  pkgs,
  config,
  ...
}:
# thanks https://git.jacekpoz.pl/poz/niksos/src/commit/f8d5e7ccd9c769f7c0b564f10dff419285e75248/modules/services/greetd.nix
let
  inherit (lib) getExe getExe';
  inherit (inputs.hyprland.packages.${pkgs.stdenv.system}) hyprland;

  styleCfg = config.local.style;

  hyprctl = getExe' hyprland "hyprctl";
  Hyprland = getExe' hyprland "Hyprland";

  greeter = getExe pkgs.greetd.gtkgreet;

  hyprlandConfig =
    pkgs.writeText "greetd-hyprland-config"
    ''
      misc {
          force_default_wallpaper=0
          focus_on_activate=1
      }

      animations {
          enabled=0
          first_launch_animation=0
      }

      workspace=1,default:true,gapsout:0,gapsin:0,border:false,decorate:false

      exec-once=[workspace 1;fullscreen;noanim] ${greeter} -l; ${hyprctl} dispatch exit
      exec-once=${hyprctl} dispatch focuswindow ${greeter}
    '';
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

    programs.regreet = lib.mkMerge [
      {
        enable = true;
      }

      (lib.mkIf styleCfg.enable {
        theme = {
          inherit (styleCfg.gtk.theme) name package;
        };

        cursorTheme = {
          inherit (styleCfg.cursorTheme) name package;
        };

        iconTheme = {
          inherit (styleCfg.gtk.iconTheme) name package;
        };
      })
    ];

    security.pam.services = {
      greetd.enableGnomeKeyring = true;
      login.enableGnomeKeyring = true;
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
