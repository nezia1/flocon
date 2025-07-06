{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (lib.lists) singleton;

  gtkCfg = config.local.style.gtk;
in {
  services = {
    # needed for GNOME services outside of GNOME Desktop
    dbus.packages = [
      pkgs.gnome-settings-daemon
    ];

    gnome = {
      gnome-keyring.enable = true;
      gcr-ssh-agent.enable = true;
    };
  };
  programs.seahorse.enable = true;

  programs.dconf = mkIf gtkCfg.enable {
    enable = true;
    profiles.user.databases = singleton {
      lockAll = true;
      settings = {
        "org/gnome/desktop/interface" = {
          gtk-theme = gtkCfg.theme.name;
          icon-theme = gtkCfg.iconTheme.name;
        };
      };
    };
  };
}
