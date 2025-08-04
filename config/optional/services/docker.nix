{config, ...}: let
  inherit (config.local.vars.system) username;
in {
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
    defaultNetwork.settings.dns_enabled = true;
  };
  users.users.${username}.extraGroups = ["podman"];
}
