{
  config,
  inputs,
  ...
}: let
  inherit (config.local.systemVars) username;
in {
  imports = [
    inputs.home-manager.nixosModules.default
  ];

  home-manager = {
    backupFileExtension = "backup";
    useGlobalPkgs = true;
    useUserPackages = true;
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
}
