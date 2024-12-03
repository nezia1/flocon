{inputs, ...}: {
  anastacia = {
    hostname = "78.47.146.254";
    profiles.system = {
      sshUser = "root";
      user = "root";
      path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos inputs.self.nixosConfigurations.anastacia;
    };
  };
}
