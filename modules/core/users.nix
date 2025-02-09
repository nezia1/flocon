{
  inputs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.lists) singleton;
  inherit (lib.filesystem) listFilesRecursive;
  inherit (config.local.systemVars) username;
  inherit (config.local.homeVars) fullName;
  inherit (config.local.profiles) desktop;
in {
  imports = [inputs.hjem.nixosModules.default];
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
    };

    extraModules = singleton {
      imports = listFilesRecursive ../../shared/modules/hjem;
    };
  };
}
