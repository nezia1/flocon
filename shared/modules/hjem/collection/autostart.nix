{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkOption;
  inherit (lib.types) listOf package;
  cfg = config.autostart;

  # stolen from https://github.com/nix-community/home-manager/issues/3447#issuecomment-1328294558
  mkAutostartEntries = builtins.listToAttrs (map
    (pkg: {
      name = ".config/autostart/" + pkg.pname + ".desktop";
      value =
        if pkg ? desktopItem
        then {
          # Application has a desktopItem entry.
          # Assume that it was made with makeDesktopEntry, which exposes a
          # text attribute with the contents of the .desktop file
          inherit (pkg.desktopItem) text;
        }
        else {
          # Application does *not* have a desktopItem entry. Try to find a
          # matching .desktop name in /share/apaplications
          source = pkg + "/share/applications/" + pkg.pname + ".desktop";
        };
    })
    cfg.programs);
in {
  options.autostart = {
    programs = mkOption {
      type = listOf package;
      default = [];
      description = ''
        A list of packages that will be started automatically,
        according to the Desktop Application Autostart
        Specification.
      '';
    };
  };
  config = mkIf (cfg.programs != []) {
    files = mkAutostartEntries;
  };
}
