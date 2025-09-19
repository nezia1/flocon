{config, ...}: {
  age.secrets = {
    syncthing-vamos-key.file = ../../../secrets/syncthing-vamos-key.age;
    syncthing-vamos-cert.file = ../../../secrets/syncthing-vamos-cert.age;
  };

  services.syncthing = {
    key = config.age.secrets.syncthing-vamos-key.path;
    cert = config.age.secrets.syncthing-vamos-cert.path;
  };
}
