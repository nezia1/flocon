{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.local.profiles.desktop.enable {
    programs.direnv.enable = true;
  };
}
