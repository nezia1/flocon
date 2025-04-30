{
  inputs,
  self,
  lib,
  ...
}: {
  flake.deploy = {
    autoRollback = true;
    magicRollback = true;

    nodes = {
      anastacia = {
        hostname = "78.47.146.254";
        profiles.system = {
          sshUser = "root";
          path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos inputs.self.nixosConfigurations.anastacia;
        };
      };
    };
  };

  perSystem = {system, ...}: {
    checks = inputs.deploy-rs.lib.${system}.deployChecks self.deploy;
  };
}
