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
  imports = [
    ./gtk.nix
  ];
  options.theme = {
    enable = mkEnableOption "theme";
    schemeName = mkOption {
      description = ''
        Name of the tinted-theming color scheme to use.
      '';
      type = enum (attrNames inputs.basix.schemeData.base16);
      example = "rose-pine";
      default = "rose-pine";
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
        default = "BreezeX-RosePine-Linux";
      };
      package = mkOption {
        type = package;
        description = ''
          Package providing the cursor theme.
        '';
        default = pkgs.rose-pine-cursor;
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
          x11.enable = true;
          gtk.enable = true;
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

          foot.settings.colors = let
            inherit (lib.strings) removePrefix;
            # because someone thought this was a great idea: https://github.com/tinted-theming/schemes/commit/61058a8d2e2bd4482b53d57a68feb56cdb991f0b
            palette = builtins.mapAttrs (_: color: removePrefix "#" color) scheme.palette;
          in {
            background = palette.base00;
            foreground = palette.base05;

            regular0 = palette.base00;
            regular1 = palette.base08;
            regular2 = palette.base0B;
            regular3 = palette.base0A;
            regular4 = palette.base0D;
            regular5 = palette.base0E;
            regular6 = palette.base0C;
            regular7 = palette.base05;

            bright0 = palette.base02;
            bright1 = palette.base08;
            bright2 = palette.base0B;
            bright3 = palette.base0A;
            bright4 = palette.base0D;
            bright5 = palette.base0E;
            bright6 = palette.base0C;
            bright7 = palette.base07;

            "16" = palette.base09;
            "17" = palette.base0F;
            "18" = palette.base01;
            "19" = palette.base02;
            "20" = palette.base04;
            "21" = palette.base06;
          };

          waybar.style =
            generateGtkColors lib scheme.palette;

          fuzzel.settings = {
            main = {
              font = "sans-serif:size=16";
            };
            colors = {
              background = "${scheme.palette.base01}f2";
              text = "${scheme.palette.base05}ff";
              match = "${scheme.palette.base0D}ff";
              selection = "${scheme.palette.base03}ff";
              selection-text = "${scheme.palette.base06}ff";
              selection-match = "${scheme.palette.base0D}ff";
              border = "${scheme.palette.base0D}ff";
            };
          };

          swaylock.settings = {
            inside-color = scheme.palette.base01;
            line-color = scheme.palette.base01;
            ring-color = scheme.palette.base05;
            text-color = scheme.palette.base05;

            inside-clear-color = scheme.palette.base0A;
            line-clear-color = scheme.palette.base0A;
            ring-clear-color = scheme.palette.base00;
            text-clear-color = scheme.palette.base00;

            inside-caps-lock-color = scheme.palette.base03;
            line-caps-lock-color = scheme.palette.base03;
            ring-caps-lock-color = scheme.palette.base00;
            text-caps-lock-color = scheme.palette.base00;

            inside-ver-color = scheme.palette.base0D;
            line-ver-color = scheme.palette.base0D;
            ring-ver-color = scheme.palette.base00;
            text-ver-color = scheme.palette.base00;

            inside-wrong-color = scheme.palette.base08;
            line-wrong-color = scheme.palette.base08;
            ring-wrong-color = scheme.palette.base00;
            text-wrong-color = scheme.palette.base00;

            caps-lock-bs-hl-color = scheme.palette.base08;
            caps-lock-key-hl-color = scheme.palette.base0D;
            bs-hl-color = scheme.palette.base08;
            key-hl-color = scheme.palette.base0D;

            separator-color = "#00000000"; # transparent
            layout-bg-color = "#00000050"; # semi-transparent black
          };

          zathura.options = {
            default-fg = scheme.palette.base01;
            default-bg = scheme.palette.base00;

            completion-bg = scheme.palette.base01;
            completion-fg = scheme.palette.base0D;
            completion-highlight-bg = scheme.palette.base0D;
            completion-highlight-fg = scheme.palette.base07;

            statusbar-fg = scheme.palette.base04;
            statusbar-bg = scheme.palette.base02;

            notification-bg = scheme.palette.base00;
            notification-fg = scheme.palette.base07;
            notification-error-bg = scheme.palette.base00;
            notification-error-fg = scheme.palette.base08;
            notification-warning-bg = scheme.palette.base00;
            notification-warning-fg = scheme.palette.base0A;

            inputbar-fg = scheme.palette.base07;
            inputbar-bg = scheme.palette.base00;

            recolor = false;
            recolor-keephue = false;
            recolor-lightcolor = scheme.palette.base00;
            recolor-darkcolor = scheme.palette.base06;

            highlight-color = scheme.palette.base0A;
            highlight-active-color = scheme.palette.base0D;
          };

          gnome-terminal.profile = {
            "4621184a-b921-42cf-80a0-7784516606f2".colors = {
              backgroundColor = "#${scheme.palette.base00}";
              foregroundColor = "#${scheme.palette.base05}" "#${scheme.palette.base05}";
              palette = builtins.attrValues (builtins.mapAttrs (_: color: "#${color}") scheme.palette);
            };
          };

          fish.interactiveShellInit = ''
            set emphasized_text  brcyan   # base1
            set normal_text      brblue   # base0
            set secondary_text   brgreen  # base01
            set background_light black    # base02
            set background       brblack  # base03
            set -g fish_color_quote        cyan      # color of commands
            set -g fish_color_redirection  brmagenta # color of IO redirections
            set -g fish_color_end          blue      # color of process separators like ';' and '&'
            set -g fish_color_error        red       # color of potential errors
            set -g fish_color_match        --reverse # color of highlighted matching parenthesis
            set -g fish_color_search_match --background=yellow
            set -g fish_color_selection    --reverse # color of selected text (vi mode)
            set -g fish_color_operator     green     # color of parameter expansion operators like '*' and '~'
            set -g fish_color_escape       red       # color of character escapes like '\n' and and '\x70'
            set -g fish_color_cancel       red       # color of the '^C' indicator on a canceled command
          '';

          starship.settings = {
            directory = {
              style = "bold yellow";
            };
            character = {
              format = "$symbol ";
              success_symbol = "[➜](bold green)";
              error_symbol = "[✗](bold red)";
              vicmd_symbol = "[](bold green)";
            };
            cmd_duration = {
              style = "yellow";
              format = "[ $duration]($style)";
            };
          };

          nvf.settings.vim.theme = {
            enable = true;
            name = "base16";
            base16-colors = scheme.palette;
          };
        };
      };
    };
}
