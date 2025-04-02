{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;

  inherit (config.local.systemVars) username;
in {
  config = mkIf config.local.profiles.desktop.enable {
    hjem.users.${username}.packages = with pkgs; [
      gthumb
      papers
      spotify
      stremio
      celluloid
      tidal-hifi
    ];
  };
}
