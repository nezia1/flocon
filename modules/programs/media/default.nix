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
    ./zathura.nix
  ];

  config = mkIf config.local.profiles.desktop.enable {
    hjem.users.${username}.packages = with pkgs; [
      gthumb
      spotify
      stremio
      celluloid
      tidal-hifi
    ];
  };
}
