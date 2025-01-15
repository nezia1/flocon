{
  lib,
  config,
  ...
}: {
  config = lib.mkIf (!config.local.profiles.server.enable) {
    users.users.${config.local.systemVars.username} = {
      isNormalUser = true;
      description = config.local.homeVars.fullName or "User";
      extraGroups = [
        "networkmanager"
        "audio"
        "video"
        "wheel"
        "plugdev"
      ];
    };
  };
}
