{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.local.profiles.desktop.enable {
    documentation = {
      enable = true;

      man = {
        enable = true;
        man-db.enable = false;
        mandoc.enable = true;
        generateCaches = true;
      };
    };
  };
}
