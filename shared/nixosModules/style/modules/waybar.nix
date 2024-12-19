{
  lib,
  config,
  ...
}: let
  cfg = config.local.style;
  betterTransition = "all 0.3s cubic-bezier(.55,-0.68,.48,1.682)";
in {
  config.home-manager.sharedModules = lib.mkIf cfg.enable [
    {
      programs.waybar.style = ''
        * {
          font-family: "0xProto Nerd Font";
          font-size: 16px;
          border-radius: 0px;
          border: none;
          min-height: 0px;
        }
        window#waybar {
          background: rgba(0,0,0,0);
        }
        #workspaces {
          color: ${cfg.scheme.palette.base00};
          background: ${cfg.scheme.palette.base01};
          margin: 4px 4px;
          padding: 5px 5px;
          border-radius: 16px;
        }
        #workspaces button {
          font-weight: bold;
          padding: 0px 5px;
          margin: 0px 3px;
          border-radius: 16px;
          color: ${cfg.scheme.palette.base00};
          background: linear-gradient(45deg, ${cfg.scheme.palette.base08}, ${cfg.scheme.palette.base0D});
          opacity: 0.5;
          transition: ${betterTransition};
        }
        #workspaces button.active {
          font-weight: bold;
          padding: 0px 5px;
          margin: 0px 3px;
          border-radius: 16px;
          color: ${cfg.scheme.palette.base00};
          background: linear-gradient(45deg, ${cfg.scheme.palette.base08}, ${cfg.scheme.palette.base0D});
          transition: ${betterTransition};
          opacity: 1.0;
          min-width: 40px;
        }
        #workspaces button:hover {
          font-weight: bold;
          border-radius: 16px;
          color: ${cfg.scheme.palette.base00};
          background: linear-gradient(45deg, ${cfg.scheme.palette.base08}, ${cfg.scheme.palette.base0D});
          opacity: 0.8;
          transition: ${betterTransition};
        }
        tooltip {
          background: ${cfg.scheme.palette.base00};
          border: 1px solid ${cfg.scheme.palette.base08};
          border-radius: 12px;
        }
        tooltip label {
          color: ${cfg.scheme.palette.base08};
        }
        #window, #pulseaudio, #cpu, #memory, #idle_inhibitor {
          font-weight: bold;
          margin: 4px 0px;
          margin-left: 7px;
          padding: 0px 18px;
          background: ${cfg.scheme.palette.base00};
          color: ${cfg.scheme.palette.base05};
          border-radius: 24px 10px 24px 10px;
        }
        #network, #battery,
        #custom-swaync, #tray, #custom-power {
          font-weight: bold;
          background: ${cfg.scheme.palette.base00};
          color: ${cfg.scheme.palette.base05};
          margin: 4px 0px;
          margin-right: 7px;
          border-radius: 10px 24px 10px 24px;
          padding: 0px 18px;
        }
        #clock {
          font-weight: bold;
          color: ${cfg.scheme.palette.base00};
          background: linear-gradient(90deg, ${cfg.scheme.palette.base0E}, ${cfg.scheme.palette.base0C});
          margin: 0px;
          padding: 0px 15px 0px 30px;
          border-radius: 0px 0px 0px 40px;
        }
      '';
    }
  ];
}
