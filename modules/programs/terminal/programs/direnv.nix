{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf config.local.profiles.desktop.enable {
    programs.direnv.enable = true;
  };
}
