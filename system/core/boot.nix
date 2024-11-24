{pkgs, ...}: {
  boot = {
    loader = {
      timeout = 0;
      systemd-boot = {
        enable = true;
        consoleMode = "2";
      };
      efi.canTouchEfiVariables = true;
    };

    plymouth = {
      enable = true;
      extraConfig = ''
        [Daemon]
        DeviceScale=2
      '';
    };

    consoleLogLevel = 0;
    initrd.systemd.enable = true;
    initrd.verbose = false;

    kernelParams = [
      "quiet"
      "splash"
      "boot.shell_on_fail"
      "loglevel=3"
      "rd.systemd.show_status=false"
      "rd.udev.log_level=3"
      "udev.log_priority=3"
    ];
  };
}
