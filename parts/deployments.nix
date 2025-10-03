{
  inputs,
  self,
  ...
}: {
  flake.deploy = {
    autoRollback = true;
    magicRollback = true;

    nodes = {
      anastacia = {
        hostname = "anastacia.tailc8ef51.ts.net";
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
