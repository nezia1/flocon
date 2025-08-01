{
  lib,
  pkgs,
  config,
  inputs',
  ...
}: let
  inherit (builtins) toJSON;
  inherit (lib.modules) mkIf;

  inherit (config.hj.rum.desktops.hyprland.settings.plugin.hyprsplit) num_workspaces;

  styleCfg = config.local.style;
in {
  hj = {
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
          "power-profiles-daemon"
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
          on-click = "${pkgs.pavucontrol}/bin/pavucontrol";
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
          on-click = "${pkgs.wlogout}/bin/wlogout";
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
          on-click = "${inputs'.iwmenu.packages.default}/bin/iwmenu -i xdg -l walker";
        };

        "hyprland/window" = {
          max-length = 22;
          separate-outputs = false;
        };

        "hyprland/workspaces" = {
          all-outputs = false;
          format = "{icon}";
          format-icons = {
            "active" = "";
            "empty" = "";
            "default" = "";
            "urgent" = "";
            "special" = "󰠱";
          };
          persistent-workspaces."*" = num_workspaces;
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
            font-family: "monospace";
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
          #power-profiles-daemon,
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
  };
  hm = {
    systemd.user.services.waybar = {
      Unit = {
        Description = "Highly customizable Wayland bar for Sway and Wlroots based compositors.";
        Documentation = ["https://github.com/Alexays/Waybar/wiki/"];
        After = ["graphical-session.target"];
        PartOf = ["graphical-session.target"];
        Requisite = ["graphical-session.target"];
      };

      Service = {
        ExecStart = "${pkgs.waybar}/bin/waybar";
        ExecReload = "${pkgs.coreutils}/bin/kill -SIGUSR2 $MAINPID";
        Restart = "on-failure";
        Slice = "app-graphical.slice";
      };

      Install.WantedBy = ["graphical-session.target"];
    };
  };
}
