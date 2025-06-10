{
  inputs,
  lib,
  pkgs,
  config,
  inputs',
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  # TODO: remove when https://github.com/NixOS/nixpkgs/pull/379731 gets merged
  imports = ["${inputs.nixpkgs-gcr}/nixos/modules/services/desktops/gnome/gcr-ssh-agent.nix"];
  config = mkIf (config.local.vars.home.desktop.type == "wm") {
    services = {
      # needed for GNOME services outside of GNOME Desktop
      dbus.packages = with pkgs; [
        gnome-settings-daemon
      ];

      gnome = {
        gnome-keyring.enable = true;
        gcr-ssh-agent = {
          enable = true;
          # TODO: remove when https://github.com/NixOS/nixpkgs/pull/379731 gets merged
          package = inputs'.nixpkgs-gcr.legacyPackages.gcr_4;
        };
      };
    };
    programs.seahorse.enable = true;
  };
}
