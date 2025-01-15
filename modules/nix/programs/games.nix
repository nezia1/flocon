{
  lib,
  config,
  ...
}: {
  config = lib.mkIf config.local.profiles.gaming.enable {
    programs = {
      steam = {
        enable = true;
      };

      gamemode.enable = true;
      gamescope.enable = true;

      coolercontrol = {
        enable = true;
        nvidiaSupport = true;
      };
    };
  };
}
