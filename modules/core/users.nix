{
  lib,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.local.systemVars) username;
  inherit (config.local.homeVars) fullName;
  inherit (config.local.profiles) desktop;
in {
  users.users.${username} = {
    isNormalUser = true;
    description = fullName;
    extraGroups = mkIf desktop.enable [
      "networkmanager"
      "audio"
      "video"
      "wheel"
      "plugdev"
    ];
  };

  hjem = mkIf desktop.enable {
    clobberByDefault = true;
    users.${username} = {
      enable = true;
      directory = "/home/${username}";
      user = "${username}";
      environment = {
        forceOverride = true;
      };
    };
  };
}
