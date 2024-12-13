{
  pkgs,
  lib,
  osConfig,
  config,
  ...
}: let
  inherit (lib) getExe mkMerge mkIf;
  inherit (builtins) readFile;
in {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = readFile ./style.css;
    settings = {
      mainBar = mkMerge [
        {
          layer = "top";
          position = "top";
          height = 30;

          margin-top = 6;
          margin-left = 6;
          margin-right = 6;
          margin-bottom = 0;

          modules-left = ["hyprland/workspaces" "hyprland/window"];
          modules-center = ["group/clock"];
          modules-right =
            ["tray" "group/status" "group/power"]
            ++ lib.optional config.services.swaync.enable "custom/swaync";

          tray = {
            icon-size = 16;
            spacing = 12;
          };

          battery = {
            interval = 10;
            states = {
              warning = 30;
              critical = 15;
            };
            format = "{icon} {capacity}%";
            format-charging = " {capacity}% - {time}";
            format-full = " {capacity}% - Full";
            format-icons = [
              ""
              ""
              ""
              ""
              ""
            ];
            max-length = 25;
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
        }
        (mkIf osConfig.programs.niri.enable {
          "niri/window" = {
            icon = true;
          };
        })
        (mkIf config.services.swaync.enable {
          "custom/swaync" = {
            format = "<big>{icon}</big>";
            format-icons = {
              notification = "󱥁";
              none = "󰍥";
              dnd-notification = "󱅮";
              dnd-none = "󱅯";
            };
            max-length = 3;
            return-type = "json";
            escape = true;
            exec-if = "which ${pkgs.swaynotificationcenter}/bin/swaync-client";
            exec = "${pkgs.swaynotificationcenter}/bin/swaync-client --subscribe-waybar";
            on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client --toggle-panel --skip-wait";
            on-click-middle = "${pkgs.swaynotificationcenter}/bin/swaync-client --toggle-dnd --skip-wait";
            tooltip-format = "󰵚  {} notification(s)";
          };
        })
      ];
    };
  };
  home.packages = [
    pkgs.pavucontrol
  ];
}
