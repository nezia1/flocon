{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (config.local.systemVars) username;
in {
  imports = [
    ./tidal-hifi.nix
    ./zathura.nix
  ];

  config = lib.mkIf config.local.profiles.desktop.enable {
    hjem.users.${username}.packages = [
      pkgs.gnome-calculator
      pkgs.gthumb
      pkgs.spotify
      pkgs.stremio
      pkgs.celluloid
    ];
  };
}
