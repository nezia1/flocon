{
  networking = {
    hostName = "anastacia";
    useNetworkd = true;
    useDHCP = false;
    enableIPv6 = true;

    nameservers = [
      "100.100.100.100"
      "192.168.1.1"
      "1.1.1.1"
      "2606:4700:4700::1111"
    ];

    search = ["tailc8ef51.ts.net"];

    defaultGateway = {
      address = "192.168.1.1";
      interface = "eth0";
    };

    defaultGateway6 = {
      address = "fe80::1adf:26ff:feb1:2090";
      interface = "eth0";
    };

    interfaces.eth0 = {
      ipv4.addresses = [
        {
          address = "192.168.1.50";
          prefixLength = 24;
        }
      ];
      ipv6.addresses = [
        {
          address = "2a01:cb15:149:dd00::50";
          prefixLength = 64;
        }
      ];
    };
  };

  services.udev.extraRules = ''
    ATTR{address}=="78:55:36:02:70:26", NAME="eth0"
  '';
}
