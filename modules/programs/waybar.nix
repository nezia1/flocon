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
            "hyprland/workspaces"
            "pulseaudio"
            "idle_inhibitor"
          ];

          modules-center = ["clock"];

          modules-right = [
            "battery"
            "network"
            "tray"
            "custom/swaync"
            "custom/power"
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
            format-charging = " {capacity}%";
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
            tooltip-format = "<big>{:%A, %d.%B %Y }</big>\n<tt>{calendar}</tt>";
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
            format = "{icon}";
            format-icons = {
              "active" = "";
              "empty" = "";
              "default" = "";
              "urgent" = "";
              "special" = "󰠱";
            };
            persistent-workspaces = {
              "*" = 3;
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
        ".config/waybar/style.css".text =
          mkIf styleCfg.enable
          /*
          css
          */
          ''
            * {
              font-family: "0xProto Nerd Font";
              border-radius: 0;
              border: none;
              min-height: 0;
            }

            window#waybar {
              background: @window_bg_color;
              font-size: 16px;
            }

            window#waybar.empty {
              background: transparent;
            }

            #workspaces {
              background-color: @card_bg_color;
              padding: 0 1em;
            }

            #workspaces button {
              color: @card_fg_color;
              font-size: 1.3em;
              padding: 0.2em 0.3em;
            }

            tooltip {
              background: @popover_bg_color;
              color: @popover_fg_color;
              border: 2px solid @accent_color;
              border-radius: 12px;
            }

            #pulseaudio,
            #idle_inhibitor,
            #workspaces,
            #clock,
            #network,
            #battery,
            #custom-swaync,
            #tray,
            #custom-power {
              font-weight: bold;
              background: @popover_bg_color;
              color: @popover_fg_color;
              padding: 0.2em 1em;
              margin: 0.5em 0.2em;
              border-radius: 0.5em;
            }

            #workspaces {
              margin-left: 1em;
            }

            #custom-power {
              margin-right: 1em;
            }
          '';
      };

      systemd.services.waybar = {
        wantedBy = ["graphical-session.target"];
        unitConfig = {
          Description = "Highly customizable Wayland bar for Sway and Wlroots based compositors.";
          Documentation = ["https://github.com/Alexays/Waybar/wiki/"];
          After = ["graphical-session.target"];
          PartOf = ["graphical-session.target"];
          Requisite = ["graphical-session.target"];
        };

        serviceConfig = {
          ExecStart = "${pkgs.waybar}/bin/waybar";
          ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
          Restart = "on-failure";
          Slice = "app-graphical.slice";
        };
      };
    };
  };
}
