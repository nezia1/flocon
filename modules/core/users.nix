{
  self,
  inputs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (config.local.vars.system) username;
  inherit (config.local.vars.home) fullName;
  inherit (config.local.profiles) server;
in {
  imports = [
    inputs.hjem.nixosModules.default
    inputs.home-manager.nixosModules.default
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
    extraModules = [
      inputs.hjem-rum.hjemModules.default
      self.outputs.hjemModules.hjem-rum
    ];
    users.${username} = {
      enable = true;
      directory = "/home/${username}";
      user = "${username}";
    };
  };

  home-manager = mkIf (!server.enable) {
    useUserPackages = true;
    useGlobalPkgs = true;
    users.${username} = {
      home.stateVersion = "25.05";
    };
  };
}
