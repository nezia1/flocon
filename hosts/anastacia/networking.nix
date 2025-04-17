{lib, ...}: {
  # This file was populated at runtime with the networking
  # details gathered from the active system.
  networking = {
    nameservers = [
      "2001:4860:4860::8888"
      "2001:4860:4860::8844"
    ];
    defaultGateway6 = {
      address = "fe80::1";
      interface = "eth0";
    };
    dhcpcd.enable = false;
    usePredictableInterfaceNames = lib.mkForce false;
    interfaces = {
      eth0 = {
        ipv6.addresses = [
          {
            address = "2a01:4f8:1c1c:8495::1";
            prefixLength = 64;
          }
          {
            address = "fe80::9400:3ff:fecb:6deb";
            prefixLength = 64;
          }
        ];
        ipv6.routes = [
          {
            address = "fe80::1";
            prefixLength = 128;
          }
        ];
      };
    };
  };
  services.udev.extraRules = ''
    ATTR{address}=="96:00:03:cb:6d:eb", NAME="eth0"

  '';
}
