{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (config.local.profiles) server;
in {
  config = mkIf (!server.enable) {
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
        "systemd.show_status=auto"
        "rd.udev.log_level=3"
      ];
    };
  };
}
