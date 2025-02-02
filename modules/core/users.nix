{
  lib,
  config,
  ...
}: let
  inherit (lib.filesystem) listFilesRecursive;
  inherit (config.local.systemVars) username;
in {
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

    hjem = {
      clobberByDefault = true;
      users.${username} = {
        enable = true;
        directory = "/home/${username}";
        user = "${username}";
        environment.enable = true;
      };
      extraModules = listFilesRecursive ../../shared/modules/hjem;
    };
  };
}
