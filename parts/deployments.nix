{
  inputs,
  self,
  withSystem,
  ...
}: {
  flake.deploy = {
    autoRollback = true;
    magicRollback = true;
    nodes = {
      anastacia = withSystem "x86_64-linux" ({pkgs, ...}: {
        hostname = "anastacia.tailc8ef51.ts.net";
        profiles.system = {
          sshUser = "root";
          path = pkgs.deploy-rs.lib.activate.nixos inputs.self.nixosConfigurations.anastacia;
        };
      });
      ranni = withSystem "x86_64-linux" ({pkgs, ...}: {
        hostname = "83.228.235.176";
        profiles.system = {
          sshUser = "root";
          path = pkgs.deploy-rs.lib.activate.nixos inputs.self.nixosConfigurations.ranni;
        };
      });
    };
  };

  perSystem = {pkgs, ...}: {
    checks = pkgs.deploy-rs.lib.deployChecks self.deploy;
  };
}
