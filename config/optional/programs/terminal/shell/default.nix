{
  pkgs,
  config,
  ...
}: let
  inherit (config.local.vars.system) username;
in {
  config = {
    users.users.${username}.shell = pkgs.zsh;
  };
}
