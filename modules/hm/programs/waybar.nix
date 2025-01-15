{
  lib,
  pkgs,
  osConfig,
  ...
}: {
  config = lib.mkIf osConfig.local.modules.hyprland.enable {
    programs.waybar = {
      enable = true;
      systemd.enable = true;
      settings = {
        mainBar = {
          layer = "top";
          position = "top";

          modules-left = [
            "hyprland/window"
            "pulseaudio"
            "cpu"
            "memory"
            "idle_inhibitor"
          ];

          modules-center = ["hyprland/workspaces"];
          modules-right = [
            "custom/swaync"
            "custom/power"
            "network"
            "battery"
            "tray"
            "clock"
          ];

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
            format-muted = "";
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

          "custom/power" = {
            format = "";
            tooltip = false;
            on-click = lib.getExe pkgs.wlogout;
          };

          "memory" = {
            interval = 5;
            format = " {}%";
            tooltip = true;
          };

          "cpu" = {
            interval = 5;
            format = " {usage:2}%";
            tooltip = true;
          };

          "idle_inhibitor" = {
            format = "{icon}";
            format-icons = {
              activated = "";
              deactivated = "";
            };
            tooltip = "true";
          };

          "clock" = {
            format = " {:L%H:%M}";
            tooltip = true;
            tooltip-format = "<big>{:%A, %d.%B %Y }</big>\n<tt><small>{calendar}</small></tt>";
          };

          "network" = {
            format-icons = [
              "󰤯"
              "󰤟"
              "󰤢"
              "󰤥"
              "󰤨"
            ];
            format-ethernet = " {bandwidthDownOctets}";
            format-wifi = "{icon} {signalStrength}%";
            format-disconnected = "󰤮";
            tooltip = false;
            on-click = "XDG_CURRENT_DESKTOP=gnome gnome-control-center";
          };

          "hyprland/window" = {
            max-length = 22;
            separate-outputs = false;
          };

          "hyprland/workspaces" = {
            format = "{name}";
            format-icons = {
              default = " ";
              active = " ";
              urgent = " ";
            };
            on-scroll-up = "hyprctl dispatch workspace e+1";
            on-scroll-down = "hyprctl dispatch workspace e-1";
          };

          "custom/swaync" = {
            tooltip = false;
            format = "<big>{icon}</big>";
            format-icons = {
              none = "";
              notification = "<span foreground='red'><sup></sup></span>";
              dnd-notification = "<span foreground='red'><sup></sup></span>";
              dnd-none = "";
              inhibited-notification = "<span foreground='red'><sup></sup></span>";
              inhibited-none = "";
              dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
              dnd-inhibited-none = "";
            };
            return-type = "json";
            escape = true;
            exec-if = "which ${pkgs.swaynotificationcenter}/bin/swaync-client";
            exec = "${pkgs.swaynotificationcenter}/bin/swaync-client --subscribe-waybar";
            on-click = "${pkgs.swaynotificationcenter}/bin/swaync-client --toggle-panel --skip-wait";
            on-click-middle = "${pkgs.swaynotificationcenter}/bin/swaync-client --toggle-dnd --skip-wait";
          };
        };
      };
    };

    systemd.user.services.waybar = {
      Unit.After = lib.mkForce "graphical-session.target";
      Service.Slice = "app-graphical.slice";
    };

    home.packages = [
      pkgs.pavucontrol
    ];
  };
}
