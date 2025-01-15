{
  inputs,
  lib,
  config,
  ...
}: let
  inherit (config.local.systemVars) username;
in {
  imports = [
    inputs.home-manager.nixosModules.default
  ];

  config = lib.mkIf (!config.local.profiles.server.enable) {
    home-manager = {
      backupFileExtension = "backup";
      useGlobalPkgs = true;
      useUserPackages = true;

      extraSpecialArgs = {inherit inputs;};
      sharedModules = [../../hm];
    };

    home-manager.users.${username} = {
      home = {
        homeDirectory = "/home/${username}";
        stateVersion = "24.05";
      };

      programs.home-manager.enable = true;
    };

    programs = {
      # make HM-managed GTK stuff work
      dconf.enable = true;
    };
  };
}
