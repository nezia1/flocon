{pkgs, ...}: {
  services = {
    printing.enable = true;

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    printing.drivers = [
      pkgs.gutenprint
      pkgs.hplip
    ];

    udev.packages = [
      pkgs.sane-airscan
      pkgs.utsushi
    ];
  };

  hardware.sane.enable = true;
  hardware.sane.extraBackends = [
    pkgs.sane-airscan # generic
    pkgs.hplip # HP
    pkgs.utsushi # other printers
  ];
}
