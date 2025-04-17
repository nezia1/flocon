{inputs, ...}: {
  anastacia = {
    hostname = "2a01:4f8:1c1c:8495::1";
    profiles.system = {
      sshUser = "root";
      user = "root";
      path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos inputs.self.nixosConfigurations.anastacia;
    };
  };
}
