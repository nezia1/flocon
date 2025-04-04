{
  lib,
  config,
  ...
}: let
  inherit (lib) mapAttrs mkIf optionalAttrs removePrefix;
  inherit (config.local.systemVars) username;

  styleCfg = config.local.style;

  prefix = "ctrl+a";

  mkGhosttyTheme = palette: let
    colors = mapAttrs (_: value: removePrefix "#" value) palette;
  in
    with colors; {
      palette = [
        "0=#${base00}"
        "1=#${base08}"
        "2=#${base0B}"
        "3=#${base0A}"
        "4=#${base0D}"
        "5=#${base0E}"
        "6=#${base0C}"
        "7=#${base06}"
        "8=#${base02}"
        "9=#${base12}"
        "10=#${base14}"
        "11=#${base13}"
        "12=#${base16}"
        "13=#${base17}"
        "14=#${base15}"
        "15=#${base07}"
        "16=#${base09}"
        "17=#${base0F}"
        "18=#${base01}"
        "19=#${base02}"
        "20=#${base04}"
        "21=#${base06}"
      ];
      background = base00;
      foreground = base05;
      cursor-color = base05;
      selection-background = base02;
      selection-foreground = base05;
    };
in {
  config = mkIf config.local.profiles.desktop.enable {
    hjem.users.${username} = {
      rum.programs.ghostty =
        {
          enable = true;
          settings =
            {
              font-family = ["monospace" "Symbols Nerd Font Mono"];
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

              background-opacity = 0.8;
              linux-cgroup = "always";
            }
            // (optionalAttrs styleCfg.enable {
              theme = "base16";
            });
        }
        // (optionalAttrs styleCfg.enable {
          themes.base16 = mkGhosttyTheme styleCfg.colors.scheme.palette;
        });

      systemd.services.ghostty = {
        name = "ghostty";
        description = "ghosttyd™";
        partOf = ["graphical-session.target"];
        after = ["graphical-session.target"];
        wantedBy = ["graphical-session.target"];
        path = lib.mkForce [];

        serviceConfig = {
          Type = "simple";
          ExecStart = "${config.hjem.users.${username}.rum.programs.ghostty.package}/bin/ghostty --initial-window=false --quit-after-last-window-closed=false";
          Restart = "on-failure";
          Slice = "background-graphical.slice";
        };
      };
    };
  };
}
