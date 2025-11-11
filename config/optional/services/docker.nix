{
  config,
  pkgs,
  ...
}: let
  inherit (config.local.vars.system) username;
in {
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  hj = {
    packages = [pkgs.docker-compose];
  };
  users.users.${username}.extraGroups = ["podman"];
}
