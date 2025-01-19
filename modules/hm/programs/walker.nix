{
  lib,
  inputs,
  osConfig,
  ...
}: let
  styleCfg = osConfig.local.style;
in {
  imports = [
    inputs.walker.homeManagerModules.default
  ];
  config = lib.mkIf osConfig.local.modules.hyprland.enable {
    programs.walker = {
      enable = true;
      runAsService = true;
      # All options from the config.json can be used here.
      config = {
        list = {
          height = 200;
        };
        app_launch_prefix = "uwsm app -- ";
        websearch.prefix = "?";
        switcher.prefix = "/";
      };

      theme = with styleCfg.scheme.palette;
        lib.mkIf styleCfg.enable {
          style = ''
            @define-color foreground ${base05};
            @define-color background ${base00};
            @define-color accent ${base0E};

            #window,
            #box,
            #aiScroll,
            #aiList,
            #search,
            #password,
            #input,
            #prompt,
            #clear,
            #typeahead,
            #list,
            child,
            scrollbar,
            slider,
            #item,
            #text,
            #label,
            #bar,
            #sub,
            #activationlabel {
              all: unset;
            }

            #cfgerr {
              background: rgba(255, 0, 0, 0.4);
              margin-top: 20px;
              padding: 8px;
              font-size: 1.2em;
            }

            #window {
              color: @foreground;
            }

            #box {
              border-radius: 2px;
              background: @background;
              padding: 32px;
              border: 1px solid ${base01};
              box-shadow:
                0 19px 38px rgba(0, 0, 0, 0.3),
                0 15px 12px rgba(0, 0, 0, 0.22);
            }

            #search {
              box-shadow:
                0 1px 3px rgba(0, 0, 0, 0.1),
                0 1px 2px rgba(0, 0, 0, 0.22);
              background: ${base01};
              padding: 8px;
            }

            #prompt {
              margin-left: 4px;
              margin-right: 12px;
              color: @foreground;
              opacity: 0.2;
            }

            #clear {
              color: @foreground;
              opacity: 0.8;
            }

            #password,
            #input,
            #typeahead {
              border-radius: 2px;
            }

            #input {
              background: none;
            }

            #spinner {
              padding: 8px;
            }

            #typeahead {
              color: @foreground;
              opacity: 0.8;
            }

            #input placeholder {
              opacity: 0.5;
            }

            child {
              padding: 8px;
              border-radius: 2px;
            }

            child:selected,
            child:hover {
              background: alpha(@accent, 0.4);
            }

            #icon {
              margin-right: 8px;
            }

            #label {
              font-weight: 500;
            }

            #sub {
              opacity: 0.5;
              font-size: 0.8em;
            }

            .aiItem {
              padding: 10px;
              border-radius: 2px;
              color: @foreground;
              background: @background;
            }

            .aiItem.assistant {
              background: ${base02};
            }

            .aiItem:hover {
              background: alpha(@accent, 0.2);
              color: ${base00};
            }

            #activationlabel {
              color: @accent;
              font-weight: bold;
            }
          '';

          layout = {
            ui.window.box = {
              v_align = "center";
              orientation = "vertical";
            };
          };
        };
    };

    systemd.user.services.walker = {
      Unit = {
        PartOf = lib.mkForce [];
        After = lib.mkForce ["graphical-session.target"];
      };
      Service = {
        Slice = lib.mkForce "background-graphical.slice";
      };
    };
  };
}
