{
  lib,
  pkgs,
  inputs,
  osConfig,
  ...
}: let
  inherit (lib) mkIf;
  anyrunPkgs = inputs.anyrun.packages.${pkgs.system};
in {
  imports = [inputs.anyrun.homeManagerModules.default];
  config = mkIf osConfig.local.modules.hyprland.enable {
    programs.anyrun = {
      enable = true;
      config = {
        x = {fraction = 0.5;};
        y = {fraction = 0.3;};
        width = {fraction = 0.3;};
        hideIcons = false;
        ignoreExclusiveZones = false;
        layer = "overlay";
        hidePluginInfo = false;
        closeOnClick = true;
        showResultsImmediately = true;
        maxEntries = null;

        plugins = with anyrunPkgs; [
          applications
          symbols
          randr
        ];
      };

      extraCss =
        /*
        css
        */
        ''
          #window {
            background-color: rgba(0, 0, 0, 0);
          }

          box#main {
            border-radius: 10px;
            background-color: @theme_bg_color;
          }

          list#main {
            background-color: rgba(0, 0, 0, 0);
            border-radius: 10px;
          }

          list#plugin {
            background-color: rgba(0, 0, 0, 0);
          }

          label#match-desc {
            font-size: 10px;
          }

          label#plugin {
            font-size: 14px;
          }
        '';

      extraConfigFiles = {
        "applications.ron".text = ''
          Config(
            // Also show the Desktop Actions defined in the desktop files, e.g. "New Window" from LibreWolf
            desktop_actions: false,
            max_entries: 5,
            // The terminal used for running terminal based desktop entries, if left as `None` a static list of terminals is used
            // to determine what terminal to use.
            terminal: Some(Terminal(
              // The main terminal command
              command: "foot",
              // What arguments should be passed to the terminal process to run the command correctly
              // {} is replaced with the command in the desktop entry
              args: "uwsm app -- {}",
            )),
          )
        '';

        "symbols.ron".text = ''
          Config(
            // The prefix that the search needs to begin with to yield symbol results
            prefix: ":s",

            // Custom user defined symbols to be included along the unicode symbols
            symbols: {
              // "name": "text to be copied"
              "shrug": "¯\\_(ツ)_/¯",
              "tableflip": "(╯°□°)╯︵ ┻━┻",
              "unflip": "┬─┬ノ( º _ ºノ)",
            },

            // The number of entries to be displayed
            max_entries: 5,
          )
        '';
        "randr.ron".text = ''
          Config(
            prefix: ":d",
            max_entries: 5,
          )
        '';
      };
    };
  };
}
