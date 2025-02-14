{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (builtins) toJSON;
  inherit (config.local.systemVars) username;
  styleCfg = config.local.style;
  betterTransition = "all 0.3s cubic-bezier(.55,-0.68,.48,1.682)";
in {
  config = mkIf config.local.modules.hyprland.enable {
    hjem.users.${username} = {
      packages = [
        pkgs.waybar
        pkgs.pavucontrol
      ];

      files = {
        ".config/waybar/config".text = toJSON {
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

        ".config/waybar/style.css".text = with styleCfg.scheme.palette;
          mkIf styleCfg.enable ''
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
              color: ${base00};
              background: ${base01};
              margin: 4px 4px;
              padding: 5px 5px;
              border-radius: 16px;
            }
            #workspaces button {
              font-weight: bold;
              padding: 0px 5px;
              margin: 0px 3px;
              border-radius: 16px;
              color: ${base00};
              background: linear-gradient(45deg, ${base08}, ${base0D});
              opacity: 0.5;
              transition: ${betterTransition};
            }
            #workspaces button.active {
              font-weight: bold;
              padding: 0px 5px;
              margin: 0px 3px;
              border-radius: 16px;
              color: ${base00};
              background: linear-gradient(45deg, ${base08}, ${base0D});
              transition: ${betterTransition};
              opacity: 1.0;
              min-width: 40px;
            }
            #workspaces button:hover {
              font-weight: bold;
              border-radius: 16px;
              color: ${base00};
              background: linear-gradient(45deg, ${base08}, ${base0D});
              opacity: 0.8;
              transition: ${betterTransition};
            }
            tooltip {
              background: ${base00};
              border: 1px solid ${base0E};
              border-radius: 12px;
            }
            tooltip label {
              color: ${base0E};
            }
            #window, #pulseaudio, #cpu, #memory, #idle_inhibitor {
              font-weight: bold;
              margin: 4px 0px;
              margin-left: 7px;
              padding: 0px 18px;
              background: ${base00};
              color: ${base05};
              border-radius: 24px 10px 24px 10px;
            }
            #network, #battery,
            #custom-swaync, #tray, #custom-power {
              font-weight: bold;
              background: ${base00};
              color: ${base05};
              margin: 4px 0px;
              margin-right: 7px;
              border-radius: 10px 24px 10px 24px;
              padding: 0px 18px;
            }
            #clock {
              font-weight: bold;
              color: ${base00};
              background: linear-gradient(90deg, ${base0E}, ${base0C});
              margin: 0px;
              padding: 0px 15px 0px 30px;
              border-radius: 0px 0px 0px 40px;
            }
          '';
      };

      systemd.services.waybar.settings = {
        Unit = {
          Description = "Highly customizable Wayland bar for Sway and Wlroots based compositors.";
          Documentation = ["https://github.com/Alexays/Waybar/wiki/"];
          After = ["graphical-session.target"];
          PartOf = ["graphical-session.target"];
          Requisite = ["graphical-session.target"];
          X-Reload-Triggers = ["${config.hjem.users.${username}.files.".config/waybar/config".text}"];
        };

        Service = {
          ExecStart = "${pkgs.waybar}/bin/waybar";
          ExecReload = "kill -SIGUSR2 $MAINPID";
          Restart = "on-failure";
          Slice = "app-graphical.slice";
        };

        Install = {
          WantedBy = ["graphical-session.target"];
        };
      };
    };
  };
}
