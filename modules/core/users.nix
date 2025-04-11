{
  self,
  inputs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (config.local.systemVars) username;
  inherit (config.local.homeVars) fullName;
  inherit (config.local.profiles) server;
in {
  imports = [
    inputs.hjem.nixosModules.default
    inputs.hjem-rum.nixosModules.default
  ];
  users.users.${username} = {
    isNormalUser = true;
    description = fullName;
    extraGroups = mkIf (!server.enable) [
      "networkmanager"
      "audio"
      "video"
      "wheel"
      "plugdev"
    ];
  };

  hjem = mkIf (!server.enable) {
    clobberByDefault = true;
    extraModules = [self.outputs.hjemModules.default];
    users.${username} = {
      enable = true;
      directory = "/home/${username}";
      user = "${username}";
    };
  };
}
