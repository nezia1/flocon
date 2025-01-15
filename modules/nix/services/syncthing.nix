{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.local.profiles.desktop.enable {
    services = {
      syncthing = {
        enable = true;
      };
    };
    systemd.services.syncthing.environment.STNODEFAULTFOLDER = "true"; # Don't create default ~/Sync folder
  };
}
