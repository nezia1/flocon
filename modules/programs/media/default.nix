{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;

  inherit (config.local.systemVars) username;
in {
  imports = [
    ./tidal-hifi.nix
    ./zathura.nix
  ];

  config = mkIf config.local.profiles.desktop.enable {
    hjem.users.${username}.packages = [
      pkgs.gnome-calculator
      pkgs.gthumb
      pkgs.spotify
      pkgs.stremio
      pkgs.celluloid
    ];
  };
}
