{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
# thanks https://git.jacekpoz.pl/poz/niksos/src/commit/f8d5e7ccd9c769f7c0b564f10dff419285e75248/modules/services/greetd.nix
let
  inherit (lib) getExe getExe' concatStringsSep;
  inherit (inputs.hyprland.packages.${pkgs.stdenv.system}) hyprland;

  hyprctl = getExe' hyprland "hyprctl";
  Hyprland = getExe' hyprland "Hyprland";

  greeter = getExe pkgs.greetd.gtkgreet;

  hyprlandConfig = pkgs.writeText "greetd-hyprland-config" ''
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
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${Hyprland} --config ${hyprlandConfig}";
        user = config.local.systemVars.username;
      };
    };
  };
  environment.etc."greetd/environments".text = concatStringsSep "\n" ["Hyprland"];

  security.pam.services = {
    greetd.enableGnomeKeyring = true;
    login.enableGnomeKeyring = true;
    greetd.fprintAuth = false;
  };
}
