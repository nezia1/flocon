{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (config.local.systemVars) username;
  inherit (config.local.profiles) desktop;
in {
  config = mkIf desktop.enable {
    hjem.users.${username} = {
      rum.programs.lsd = {
        enable = true;
      };
    };
  };
}
