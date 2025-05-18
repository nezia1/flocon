{
  config,
  pkgs,
  lib,
  ...
}: let
  cfg = config.services.gnome.gcr-ssh-agent;

  systemdSupport = lib.meta.availableOn pkgs.stdenv.hostPlatform pkgs.systemd;

  gcr_4 = pkgs.gcr_4.overrideAttrs (_: _: {
    mesonFlags = [
      "-Dgpg_path=${lib.getBin pkgs.gnupg}/bin/gpg"
      (lib.mesonEnable "systemd" systemdSupport)
      "--cross-file=${
        pkgs.writeText "cross-file.conf" (
          ''
            [binaries]
            ssh-add = '${lib.getExe' pkgs.openssh "ssh-add"}'
            ssh-agent = '${lib.getExe' pkgs.openssh "ssh-agent"}'
          ''
          + lib.optionalString systemdSupport ''
            systemctl = '${lib.getExe' pkgs.systemd "systemctl"}'
          ''
        )
      }"
    ];
  });
in {
  meta = {
    maintainers = lib.teams.gnome.members;
  };

  options = {
    services.gnome.gcr-ssh-agent = {
      enable = lib.mkEnableOption "GCR ssh-agent";
    };
  };

  config = lib.mkIf cfg.enable {
    systemd.packages = [gcr_4];

    # Set SSH_AUTH_SOCK in session environment since not all DEs/display managers will use environment variables from systemd
    environment.extraInit = ''
      if [ -z "$SSH_AUTH_SOCK" -a -n "$XDG_RUNTIME_DIR" ]; then
        export SSH_AUTH_SOCK="$XDG_RUNTIME_DIR/gcr/ssh"
      fi
    '';
  };
}
