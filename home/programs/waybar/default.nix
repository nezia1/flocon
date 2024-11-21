{
  osConfig,
  pkgs,
  lib,
  ...
}: let
  inherit (lib) getExe;
in {
  imports = [./style.nix];
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 30;

        margin-top = 6;
        margin-left = 6;
        margin-right = 6;
        margin-bottom = 0;

        modules-left = ["niri/workspaces" "niri/window"];
        modules-center = ["group/clock"];
        modules-right = ["tray" "group/status" "group/power"];

        battery = {
          interval = 60;
          states = {
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-icons = [
            ""
            ""
            ""
            ""
            ""
          ];
          max-length = 25;
        };

        "niri/window" = {
          icon = true;
        };

        "pulseaudio" = {
          format = "{icon} {volume}%";
          format-bluetooth = "{icon} {volume}%";
          format-muted = " ";
          format-icons = {
            "alsa_output.pci-0000_00_1f.3.analog-stereo" = "";
            "alsa_output.pci-0000_00_1f.3.analog-stereo-muted" = "";
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            phone-muted = "";
            portable = "";
            car = "";
            default = [
              ""
              ""
            ];
          };
          scroll-step = 1;
          on-click = "pavucontrol";
          ignored-sinks = [
            "Easy Effects Sink"
          ];
        };

        "power-profiles-daemon" = {
          format-icons = {
            default = "";
            performance = "";
            balanced = "";
            power-saver = "";
          };
        };

        "group/status" = {
          orientation = "inherit";
          modules = [
            "pulseaudio"
            "power-profiles-daemon"
            "network"
            "battery"
          ];
        };

        "group/power" = {
          orientation = "inherit";
          modules = [
            "custom/power"
          ];
        };

        "group/clock" = {
          orientation = "inherit";
          modules = [
            "clock#time"
            "clock#date"
          ];
        };

        "custom/power" = {
          format = "";
          tooltip = false;
          on-click = getExe pkgs.wlogout;
        };

        "clock#date" = {
          format = "{:%D}";
          tooltip-format = "<tt><big>{calendar}</big></tt>";
        };

        "clock#time" = {
          format = "{:%H:%M}";
          tooltip-format = "{tz_list}";
          timezones = [
            osConfig.time.timeZone
            "US/Eastern"
          ];
        };

        network = {
          interface = "wlp1s0";
          format = "{ifname}";
          format-wifi = "{icon}";
          format-ethernet = "{ipaddr}/{cidr} 󰊗";
          format-disconnected = "";
          tooltip-format = "{ifname} via {gwaddr} 󰊗";
          tooltip-format-wifi = "{essid} ({signalStrength}%)";
          tooltip-format-ethernet = "{ifname} ";
          tooltip-format-disconnected = "Disconnected";
          max-length = 50;
          format-icons = [
            "󰤟"
            "󰤢"
            "󰤥"
            "󰤨"
          ];
        };
      };
    };
  };

  home.packages = [
    pkgs.pavucontrol
  ];
}
