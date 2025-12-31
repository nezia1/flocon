{
  pkgs,
  config,
  ...
}: {
  hj = {
    packages = with pkgs; [
      mangohud
      bolt-launcher
      qbittorrent
      wowup-cf
    ];
  };

  services.wivrn = {
    enable = true;
    openFirewall = true;

    # Write information to /etc/xdg/openxr/1/active_runtime.json, VR applications
    # will automatically read this and work with WiVRn (Note: This does not currently
    # apply for games run in Valve's Proton)
    defaultRuntime = true;

    # Run WiVRn as a systemd service on startup
    autoStart = true;

    # If you're running this with an nVidia GPU and want to use GPU Encoding (and don't otherwise have CUDA enabled system wide), you need to override the cudaSupport variable.
    # package = pkgs.wivrn.override {cudaSupport = true;};

    # You should use the default configuration (which is no configuration), as that works the best out of the box.
    # However, if you need to configure something see https://github.com/WiVRn/WiVRn/blob/master/docs/configuration.md for configuration options and https://mynixos.com/nixpkgs/option/services.wivrn.config.json for an example configuration.
  };

  hj.xdg.config.files."openxr/1/active_runtime.json".source = "${config.services.wivrn.package}/share/openxr/1/openxr_wivrn.json";

  programs = {
    steam = {
      enable = true;
      package = pkgs.steam.override {
        extraProfile = ''
          # Fixes timezones on VRChat
          unset TZ
          # Allows Monado to be used
          export PRESSURE_VESSEL_IMPORT_OPENXR_1_RUNTIMES=1
        '';
      };
      gamescopeSession.enable = true;
      extraCompatPackages = [pkgs.proton-ge-bin];
      protontricks.enable = true;
    };
    gamemode.enable = true;
    gamescope = {
      enable = true;
      capSysNice = true;
      args = [
        "--rt"
        "--expose-wayland"
      ];
    };
    coolercontrol.enable = true;
  };

  services.udev.packages = [
    (pkgs.writeTextFile {
      name = "50-oculus.rules";
      text = ''
        SUBSYSTEM=="usb", ATTR{idVendor}=="2833", ATTR{idProduct}=="0186", MODE="0660", GROUP="plugdev", SYMLINK+="ocuquest%n"
      '';
      destination = "/etc/udev/rules.d/50-oculus.rules";
    })
    (pkgs.writeTextFile {
      name = "52-android.rules";
      text = ''
        SUBSYSTEM=="usb", ATTR{idVendor}=="2833", ATTR{idProduct}=="0186", MODE="0666", OWNER="matt"
      '';
      destination = "/etc/udev/rules.d/52-android.rules";
    })
  ];

  environment.systemPackages = with pkgs; [
    android-tools
    vulkan-tools
    vulkan-loader
    xdg-utils
    pciutils
    cudatoolkit
    vulkan-validation-layers
  ];

  services.hardware.openrgb.enable = true;
}
