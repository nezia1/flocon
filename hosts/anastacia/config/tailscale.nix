{config, ...}: {
  age.secrets = {
    tailscale-auth-anastacia.file = ../../../secrets/tailscale-auth-anastacia.age;
  };

  services.tailscale = {
    enable = true;
    authKeyFile = config.age.secrets.tailscale-auth-anastacia.path;
  };
}
