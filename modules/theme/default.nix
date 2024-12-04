{
  inputs,
  config,
  lib,
  lib',
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf attrNames;
  inherit (lib.types) path package enum;
  inherit (lib') generateGtkColors;
  cfg = config.theme;
in {
  imports = [./gtk.nix];
  options.theme = {
    enable = mkEnableOption "theme";
    schemeName = mkOption {
      description = ''
        Name of the tinted-theming color scheme to use.
      '';
      type = enum (attrNames inputs.basix.schemeData.base16);
      example = "catppuccin-macchiato";
      default = "catppuccin-macchiato";
    };

    wallpaper = mkOption {
      description = ''
        Location of the wallpaper that will be used throughout the system.
      '';
      type = path;
      example = lib.literalExpression "./wallpaper.png";
      default = pkgs.fetchurl {
        url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/e0cf0eb237dc5baba86661a3572b20a6183c1876/wallpapers/nix-wallpaper-nineish-catppuccin-frappe.png?raw=true";
        hash = "sha256-/HAtpGwLxjNfJvX5/4YZfM8jPNStaM3gisK8+ImRmQ4=";
      };
    };

    cursorTheme = {
      name = mkOption {
        description = ''
          Name of the cursor theme.
        '';
        default = "phinger-cursors-dark";
      };
      package = mkOption {
        type = package;
        description = ''
          Package providing the cursor theme.
        '';
        default = pkgs.phinger-cursors;
      };
      size = mkOption {
        description = ''
          Size of the cursor.
        '';
        default = 32;
      };
    };
  };
  config = let
    scheme = inputs.basix.schemeData.base16.${config.theme.schemeName};
  in
    mkIf cfg.enable
    {
      home-manager.users.nezia = {
        home.pointerCursor = {
          inherit (config.theme.cursorTheme) name package size;
        };

        gtk = {
          iconTheme = {
            inherit (config.theme.gtk.iconTheme) name package;
          };

          theme = lib.mkIf (!config.services.xserver.desktopManager.gnome.enable) {
            inherit (config.theme.gtk.theme) name package;
          };

          gtk3.extraConfig = {
            gtk-application-prefer-dark-theme =
              if scheme.variant == "dark"
              then "1"
              else "0";
          };
        };

        services.swaync.style =
          generateGtkColors lib scheme.palette;

        programs = {
          niri = {
            settings = {
              layout.focus-ring.active.color = scheme.palette.base0D;
              cursor = {
                inherit (config.theme.cursorTheme) size;
                theme = config.theme.cursorTheme.name;
              };
            };
          };

          kitty.settings = {
            foreground = scheme.palette.base05;
            background = scheme.palette.base00;
            selection_foreground = scheme.palette.base00;
            selection_background = scheme.palette.base06;

            cursor = scheme.palette.base06;
            cursor_text_color = scheme.palette.base00;

            url_color = scheme.palette.base06;

            active_border_color = scheme.palette.base07;
            inactive_border_color = scheme.palette.base04;
            bell_border_color = scheme.palette.base0A;

            wayland_titlebar_color = scheme.palette.base00;

            active_tab_foreground = scheme.palette.base01;
            active_tab_background = scheme.palette.base0E;
            inactive_tab_foreground = scheme.palette.base05;
            inactive_tab_background = scheme.palette.base01;
            tab_bar_background = scheme.palette.base01;

            mark1_foreground = scheme.palette.base00;
            mark1_background = scheme.palette.base07;
            mark2_foreground = scheme.palette.base00;
            mark2_background = scheme.palette.base0E;
            mark3_foreground = scheme.palette.base00;
            mark3_background = scheme.palette.base0C;

            color0 = scheme.palette.base03;
            color8 = scheme.palette.base03;

            color1 = scheme.palette.base08;
            color9 = scheme.palette.base08;

            color2 = scheme.palette.base0B;
            color10 = scheme.palette.base0B;

            color3 = scheme.palette.base0A;
            color11 = scheme.palette.base0A;

            color4 = scheme.palette.base0D;
            color12 = scheme.palette.base0D;

            color5 = scheme.palette.base0E;
            color13 = scheme.palette.base0E;

            color6 = scheme.palette.base0C;
            color14 = scheme.palette.base0C;

            color7 = scheme.palette.base07;
            color15 = scheme.palette.base07;
          };
          foot.settings.colors = let
            inherit (lib.strings) removePrefix;
            # because someone thought this was a great idea: https://github.com/tinted-theming/schemes/commit/61058a8d2e2bd4482b53d57a68feb56cdb991f0b
            palette = builtins.mapAttrs (_: color: removePrefix "#" color) scheme.palette;
          in {
            background = palette.base00;
            foreground = palette.base05;

            regular0 = palette.base01;
            regular1 = palette.base08;
            regular2 = palette.base0B;
            regular3 = palette.base0A;
            regular4 = palette.base0D;
            regular5 = palette.base0E;
            regular6 = palette.base0C;
            regular7 = palette.base06;

            bright0 = palette.base02;
            bright1 = palette.base08;
            bright2 = palette.base0B;
            bright3 = palette.base0A;
            bright4 = palette.base0D;
            bright5 = palette.base0E;
            bright6 = palette.base0C;
            bright7 = palette.base07;
          };

          waybar.style =
            generateGtkColors lib scheme.palette;

          fuzzel.settings = {
            main = {
              font = "sans-serif:size=16";
            };
            colors = {
              background = "${scheme.palette.base00}ff";
              text = "${scheme.palette.base05}ff";
              input = "${scheme.palette.base05}ff";
              selection = "${scheme.palette.base02}ff";
              selection-text = "${scheme.palette.base07}ff";
              selection-match = "${scheme.palette.base0D}ff";
              border = "${scheme.palette.base0E}ff";
            };
          };

          swaylock.settings = {
            inside-color = scheme.palette.base01;
            inside-clear-color = scheme.palette.base0C;
            inside-caps-lock-color = scheme.palette.base09;
            inside-ver-color = scheme.palette.base0D;
            inside-wrong-color = scheme.palette.base08;
            key-hl-color = scheme.palette.base0B;
            layout-bg-color = scheme.palette.base00;
            layout-border-color = scheme.palette.base05;
            layout-text-color = scheme.palette.base07;
            line-color = scheme.palette.base00;
            line-clear-color = scheme.palette.base0C;
            line-caps-lock-color = scheme.palette.base09;
            line-ver-color = scheme.palette.base0D;
            line-wrong-color = scheme.palette.base08;
            ring-color = scheme.palette.base02;
            ring-clear-color = scheme.palette.base0C;
            ring-caps-lock-color = scheme.palette.base09;
            ring-ver-color = scheme.palette.base0D;
            ring-wrong-color = scheme.palette.base08;
            separator-color = scheme.palette.base02;
            text-color = scheme.palette.base07;
            text-clear-color = scheme.palette.base04;
            text-caps-lock-color = scheme.palette.base04;
            text-ver-color = scheme.palette.base04;
            text-wrong-color = scheme.palette.base04;
          };

          zathura.options = {
            default-fg = scheme.palette.base05;
            default-bg = scheme.palette.base00;

            completion-bg = scheme.palette.base02;
            completion-fg = scheme.palette.base05;
            completion-highlight-bg = scheme.palette.base03;
            completion-highlight-fg = scheme.palette.base05;
            completion-group-bg = scheme.palette.base02;
            completion-group-fg = scheme.palette.base0D;

            statusbar-fg = scheme.palette.base05;
            statusbar-bg = scheme.palette.base02;

            notification-bg = scheme.palette.base02;
            notification-fg = scheme.palette.base05;
            notification-error-bg = scheme.palette.base02;
            notification-error-fg = scheme.palette.base08;
            notification-warning-bg = scheme.palette.base02;
            notification-warning-fg = scheme.palette.base0A;

            inputbar-fg = scheme.palette.base05;
            inputbar-bg = scheme.palette.base02;

            recolor = true;
            recolor-lightcolor = scheme.palette.base00;
            recolor-darkcolor = scheme.palette.base05;

            index-fg = scheme.palette.base05;
            index-bg = scheme.palette.base00;
            index-active-fg = scheme.palette.base05;
            index-active-bg = scheme.palette.base02;

            render-loading-bg = scheme.palette.base00;
            render-loading-fg = scheme.palette.base05;

            highlight-color = lib'.rgba lib scheme.palette.base03 ".5";
            highlight-fg = lib'.rgba lib scheme.palette.base0E ".5";
            highlight-active-color = lib'.rgba lib scheme.palette.base0E ".5";
          };

          gnome-terminal.profile = {
            "4621184a-b921-42cf-80a0-7784516606f2".colors = {
              backgroundColor = "#${scheme.palette.base00}";
              foregroundColor = "#${scheme.palette.base05}" "#${scheme.palette.base05}";
              palette = builtins.attrValues (builtins.mapAttrs (_: color: "#${color}") scheme.palette);
            };
          };
        };
      };
    };
}
