{
  lib,
  inputs,
  config,
  pkgs,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.local.systemVars) username;
in {
  config = mkIf config.local.modules.hyprland.enable {
    hjem.users.${username} = {
      packages = [inputs.anyrun.packages.${pkgs.system}.anyrun-with-all-plugins];
      files = {
        ".config/anyrun/config.ron".source = ./config.ron;
        ".config/anyrun/applications.ron".text = ''
          Config(
            // Also show the Desktop Actions defined in the desktop files, e.g. "New Window" from LibreWolf
            desktop_actions: false,
            max_entries: 5,
            // The terminal used for running terminal based desktop entries, if left as `None` a static list of terminals is used
            // to determine what terminal to use.
            terminal: Some(Terminal(
              // The main terminal command
              command: "ghostty -e",
              // What arguments should be passed to the terminal process to run the command correctly
              // {} is replaced with the command in the desktop entry
              args: "uwsm app -- {}",
            )),
          )
        '';
        ".config/anyrun/symbols.ron".text = ''
          Config(
            prefix: ":s",
            symbols: {
              "shrug": "¯\\_(ツ)_/¯",
            },
            max_entries: 5,
          )
        '';
        ".config/anyrun/shell.ron".text = ''
          Config(
            prefix: ">"
          )
        '';
        ".config/anyrun/randr.ron".text = ''
          Config(
            prefi: ":dp",
            max_entries: 5,
          )
        '';
        ".config/anyrun/style.css".source = ./style.css;
      };
    };
  };
}
