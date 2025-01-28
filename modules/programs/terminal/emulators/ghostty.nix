{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mapAttrs mkIf mkMerge optionalAttrs removePrefix;
  inherit (config.local.systemVars) username;
  toINI = lib.generators.toINIWithGlobalSection {listsAsDuplicateKeys = true;};
  styleCfg = config.local.style;

  prefix = "ctrl+a";

  mkGhosttyTheme = palette: let
    colors = mapAttrs (_: value: removePrefix "#" value) palette;
  in {
    palette = [
      "0=#${colors.base00}"
      "1=#${colors.base08}"
      "2=#${colors.base0B}"
      "3=#${colors.base0A}"
      "4=#${colors.base0D}"
      "5=#${colors.base0E}"
      "6=#${colors.base0C}"
      "7=#${colors.base05}"
      "8=#${colors.base02}"
      "9=#${colors.base08}"
      "10=#${colors.base0B}"
      "11=#${colors.base0A}"
      "12=#${colors.base0D}"
      "13=#${colors.base0E}"
      "14=#${colors.base0C}"
      "15=#${colors.base07}"
      "16=#${colors.base09}"
      "17=#${colors.base0F}"
      "18=#${colors.base01}"
      "19=#${colors.base02}"
      "20=#${colors.base04}"
      "21=#${colors.base06}"
    ];
    background = colors.base00;
    foreground = colors.base05;
    cursor-color = colors.base06;
    selection-background = colors.base02;
    selection-foreground = colors.base05;
  };
in {
  config = mkIf config.local.profiles.desktop.enable {
    hjem.users.${username} = {
      files = mkMerge [
        {
          ".config/ghostty/config".text =
            toINI
            {
              globalSection = {
                font-family = ["monospace" "Symbols Nerd Font"];
                font-size = 14;
                gtk-single-instance = true;
                gtk-adwaita = false;
                confirm-close-surface = false;

                keybind = [
                  "${prefix}>c=new_tab"
                  "${prefix}>p=move_tab:-1"
                  "${prefix}>n=move_tab:1"

                  "${prefix}>\\=new_split:right"
                  "${prefix}>-=new_split:down"
                  "${prefix}>h=goto_split:left"
                  "${prefix}>j=goto_split:bottom"
                  "${prefix}>k=goto_split:top"
                  "${prefix}>l=goto_split:right"
                  "${prefix}>shift+h=resize_split:left,10"
                  "${prefix}>shift+j=resize_split:down,10"
                  "${prefix}>shift+k=resize_split:up,10"
                  "${prefix}>shift+l=resize_split:right,11"
                  "${prefix}>z=toggle_split_zoom"
                ];

                adw-toolbar-style = "flat";
                gtk-tabs-location = "bottom";
                gtk-wide-tabs = false;
                window-decoration = false;

                linux-cgroup = "always";
              };
            };
        }
        (optionalAttrs styleCfg.enable
          {
            ".config/ghostty/config".text = toINI {
              globalSection.theme = "base16";
            };
            ".config/ghostty/themes/base16".text = toINI {globalSection = mkGhosttyTheme styleCfg.scheme.palette;};
          })
      ];
      packages = [pkgs.ghostty];
    };

    systemd.user.services.ghosttyd = {
      description = "ghosttyd™";
      partOf = ["graphical-session.target"];
      after = ["graphical-session.target"];
      wantedBy = ["graphical-session.target"];
      path = with pkgs; [carapace starship zoxide];

      serviceConfig = {
        Type = "simple";
        ExecStart = "${pkgs.ghostty}/bin/ghostty --initial-window=false --quit-after-last-window-closed=false";
        Slice = "background-graphical.slice";
        Restart = "on-failure";
      };
    };
  };
}
