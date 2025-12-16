{config, ...}: {
  age.secrets.wg-private-key-hepia.file = ../../../secrets/wg-private-key-hepia.age;

  networking.useNetworkd = true;

  networking.wireguard.interfaces.wg-hepia = {
    ips = ["10.180.100.158/24"];
    privateKeyFile = config.age.secrets.wg-private-key-hepia.path;

    peers = [
      {
        publicKey = "8ajb0JLdBzfyiIEBqxKEPsF9TvfM2ztbAKHKUOkgREM=";
        allowedIPs = ["10.180.0.0/16"];
        endpoint = "lab.hepia.ovh:51100";
        persistentKeepalive = 25;
      }
    ];
  };

  systemd.network.networks."wg-hepia" = {
    matchConfig.Name = "wg-hepia";
    networkConfig = {
      DNS = ["10.180.100.1"];
    };
  };
}
