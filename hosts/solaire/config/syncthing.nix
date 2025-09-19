{config, ...}: {
  age.secrets = {
    syncthing-solaire-key.file = ../../../secrets/syncthing-solaire-key.age;
    syncthing-solaire-cert.file = ../../../secrets/syncthing-solaire-cert.age;
  };

  services.syncthing = {
    key = config.age.secrets.syncthing-solaire-key.path;
    cert = config.age.secrets.syncthing-solaire-cert.path;
  };
}
