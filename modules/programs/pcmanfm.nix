{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.local.systemVars) username;
in {
  config = mkIf config.local.profiles.desktop.enable {
    hjem.users.${username} = {
      packages = with pkgs; [
        lxmenu-data
        pcmanfm # builds with gtk3 by default, no need to override
        shared-mime-info
      ];

      systemd.services.pcmanfm = {
        description = "PCManFM daemon";
        documentation = ["https://github.com/lxde/pcmanfm"];
        after = ["graphical-session.target"];
        partOf = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        serviceConfig = {
          Type = "simple";
          ExecStart = "${pkgs.pcmanfm}/bin/pcmanfm --daemon-mode";
          Restart = "on-failure";
          Slice = "background-graphical.slice";
        };
      };
    };

    services.gvfs.enable = true; # mount, trash, and other functionalities
  };
}
