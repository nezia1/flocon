{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.local.vars.system) username;
in {
  imports = [
    ./starship.nix
    ./nushell.nix
    ./zoxide.nix
    ./zsh.nix
  ];

  config = mkIf (!config.local.profiles.server.enable) {
    users.users.${username}.shell = pkgs.zsh;
  };
}
