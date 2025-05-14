{
  inputs,
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkAliasOptionModule mkIf;

  inherit (config.local.vars.home) fullName;
  inherit (config.local.vars.system) username;
  inherit (config.local.profiles) server;
in {
  imports = [
    inputs.hjem.nixosModules.default
    inputs.home-manager.nixosModules.default
    # avoid boilerplate in the configuration
    (mkAliasOptionModule ["hj"] ["hjem" "users" username])
    (mkAliasOptionModule ["hm"] ["home-manager" "users" username])
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

  age.identityPaths = mkIf (!server.enable) ["${config.hj.directory}/.ssh/id_ed25519"];

  hjem = mkIf (!server.enable) {
    clobberByDefault = true;
    extraModules = [
      inputs.hjem-rum.hjemModules.default
      inputs.self.outputs.hjemModules.rum
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
