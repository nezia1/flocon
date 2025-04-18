{inputs, ...}: {
  imports = [
    ./hardware-configuration.nix
    ./networking.nix # generated at runtime by nixos-infect

    inputs.agenix.nixosModules.default
  ];

  local = {
    vars.system = {
      hostName = "anastacia";
    };

    profiles.server.enable = true;
  };

  boot.tmp.cleanOnBoot = true;
  networking.domain = "";
  services.openssh.enable = true;
  users.users.root.openssh.authorizedKeys.keys = [
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEzs7SQH0Vjt9JHoXXmWy9fPU1I3rrRWV5magZFrI5al"
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHKEPlN/GU9nJZPleA77HH5NA+6vyhhM84fTSjEwnEgq"
  ];

  system.stateVersion = "23.11";
}
