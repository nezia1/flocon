{
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf osConfig.local.profiles.desktop.enable {
    services.syncthing = {
      enable = true;
    };
  };
}
