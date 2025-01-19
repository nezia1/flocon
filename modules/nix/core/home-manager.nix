{
  inputs,
  lib,
  config,
  ...
}: let
  inherit (config.local.systemVars) username;
  lib' = import ../../../shared/lib inputs.nixpkgs.lib;
in {
  imports = [
    inputs.home-manager.nixosModules.default
  ];

  config = lib.mkIf (!config.local.profiles.server.enable) {
    home-manager = {
      backupFileExtension = "backup";
      useGlobalPkgs = true;
      useUserPackages = true;

      extraSpecialArgs = {inherit inputs lib';};
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
