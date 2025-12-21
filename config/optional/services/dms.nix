{
  lib,
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.dms.nixosModules.dank-material-shell
    inputs.dms.nixosModules.greeter
  ];

  programs.dank-material-shell = {
    enable = true;

    systemd = {
      enable = true; # Systemd service for auto-start
      restartIfChanged = true; # Auto-restart dms.service when dankMaterialShell changes
    };

    # Core features
    enableSystemMonitoring = true; # System monitoring widgets (dgop)
    enableVPN = true; # VPN management widget
    enableAudioWavelength = true; # Audio visualizer (cava)
    enableCalendarEvents = true; # Calendar integration (khal)

    greeter = {
      enable = true;
      compositor = {
        name = "niri";
      };

      # Sync your user's DankMaterialShell theme with the greeter. You'll probably want this
      configHome = config.hj.directory;

      # Save the logs to a file
      logs = {
        save = true;
        path = "/tmp/dms-greeter.log";
      };
    };
  };

  hj.environment.sessionVariables = {
    DMS_ENABLE_MATUGEN = 0;
  };

  # Allow full access to environment / PATH
  systemd.user.services.dms.environment = lib.mkForce {};

  security.pam.services = {
    greetd.fprintAuth = false;
    greetd.kwallet.enable = true;
    dankshell.fprintAuth = false;
  };
}
