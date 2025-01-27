{
  lib,
  osConfig,
  ...
}: {
  config = lib.mkIf osConfig.local.profiles.desktop.enable {
    services.gammastep = {
      enable = true;
      tray = true;
      provider = "geoclue2";
    };

    systemd.user.services.gammastep = {
      Unit = {
        PartOf = lib.mkForce [];
        After = lib.mkForce ["graphical-session.target"];
      };
      Service = {
        Slice = lib.mkForce "background-graphical.slice";
      };
    };
  };
}
