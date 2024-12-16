{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkOption mkIf attrNames;
  inherit (lib.strings) removePrefix;
  inherit (lib.types) path package enum;

  cfg = config.theme;
in {
  imports = [
    ./gtk.nix
    inputs.niri.nixosModules.niri
    inputs.hyprland.nixosModules.default
  ];
  options.theme = {
    enable = mkEnableOption "theme";
    schemeName = mkOption {
      description = ''
        Name of the tinted-theming color scheme to use.
      '';
      type = enum (attrNames inputs.basix.schemeData.base16);
      example = "catppuccin-mocha";
      default = "catppuccin-mocha";
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

    avatar = mkOption {
      description = ''
        Path to an avatar image (used for hyprlock).
      '';
      default = ../../assets/avatar.png;
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

        wayland.windowManager.hyprland.settings = {
          env = [
            "HYPRCURSOR_THEME,phinger-cursors-light"
            "HYPRCURSOR_SIZE,32"
            "XCURSOR_SIZE,32"
          ];
          general = {
            border_size = 4;
            "col.active_border" = "rgb(${removePrefix "#" scheme.palette.base0E})";
          };
          decoration = {
            rounding = 10;
            blur.enabled = true;
          };
        };

        programs = {
          hyprlock = {
            settings = {
              background = [
                {
                  path = "screenshot";
                  blur_passes = 3;
                  blur_size = 8;
                }
              ];

              general = {
                disable_loading_bar = true;
                hide_cursor = true;
              };

              label = [
                {
                  monitor = "";
                  text = "Layout: $LAYOUT";
                  font_size = 25;
                  color = scheme.palette.base05;

                  position = "30, -30";
                  halign = "left";
                  valign = "top";
                }
                {
                  monitor = "";
                  text = "$TIME";
                  font_size = 90;
                  color = scheme.palette.base05;

                  position = "-30, 0";
                  halign = "right";
                  valign = "top";
                }
                {
                  monitor = "";
                  text = "cmd[update:43200000] date +\"%A, %d %B %Y\"";
                  font_size = 25;
                  color = scheme.palette.base05;

                  position = "-30, -150";
                  halign = "right";
                  valign = "top";
                }
              ];

              image = {
                monitor = "";
                path = "${cfg.avatar}"; # Replace with your avatar path
                size = 100;
                border_color = scheme.palette.base0D;

                position = "0, 75";
                halign = "center";
                valign = "center";
              };

              input-field = [
                {
                  monitor = "";

                  size = "300, 60";
                  outline_thickness = 4;
                  dots_size = 0.2;
                  dots_spacing = 0.2;
                  dots_center = true;

                  outer_color = scheme.palette.base0D;
                  inner_color = scheme.palette.base02;
                  font_color = scheme.palette.base05;

                  fade_on_empty = false;
                  placeholder_text = "<span foreground=\"#${scheme.palette.base03}\"><i>󰌾 Logged in as </i><span foreground=\"#${scheme.palette.base0D}\">$USER</span></span>";

                  hide_input = false;
                  check_color = scheme.palette.base0D;
                  fail_color = scheme.palette.base08;

                  fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
                  capslock_color = scheme.palette.base0E;

                  position = "0, -47";
                  halign = "center";
                  valign = "center";
                }
              ];
            };
          };
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
              match = "${scheme.palette.base0E}ff";
              selection = "${scheme.palette.base03}ff";
              selection-text = "${scheme.palette.base06}ff";
              selection-match = "${scheme.palette.base0E}ff";
              border = "${scheme.palette.base0E}ff";
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
            set fish_cursor_default     block      blink
            set fish_cursor_insert      line       blink
            set fish_cursor_replace_one underscore blink
            set fish_cursor_visual      block

            set -x fish_color_autosuggestion      brblack
            set -x fish_color_cancel              -r
            set -x fish_color_command             brgreen
            set -x fish_color_comment             brmagenta
            set -x fish_color_cwd                 green
            set -x fish_color_cwd_root            red
            set -x fish_color_end                 brmagenta
            set -x fish_color_error               brred
            set -x fish_color_escape              brcyan
            set -x fish_color_history_current     --bold
            set -x fish_color_host                normal
            set -x fish_color_host_remote         yellow
            set -x fish_color_match               --background=brblue
            set -x fish_color_normal              normal
            set -x fish_color_operator            cyan
            set -x fish_color_param               brblue
            set -x fish_color_quote               yellow
            set -x fish_color_redirection         bryellow
            set -x fish_color_search_match        'bryellow' '--background=brblack'
            set -x fish_color_selection           'white' '--bold' '--background=brblack'
            set -x fish_color_status              red
            set -x fish_color_user                brgreen
            set -x fish_color_valid_path          --underline
            set -x fish_pager_color_completion    normal
            set -x fish_pager_color_description   yellow
            set -x fish_pager_color_prefix        'white' '--bold' '--underline'
            set -x fish_pager_color_progress      'brwhite' '--background=cyan'
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
        xdg.configFile."equibop/themes/midnight-base16.css".text = with scheme.palette; ''
          /**
           * @name Midnight-base16
           * @description A dark, rounded discord theme. Updated to use base16 colors.
           * @author refact0r
           * @version 1.6.2
           * @invite nz87hXyvcy
           * @website https://github.com/refact0r/midnight-discord
           * @source https://github.com/refact0r/midnight-discord/blob/master/midnight.theme.css
           * @authorId 508863359777505290
           * @authorLink https://www.refact0r.dev
          */

          /* IMPORTANT: make sure to enable dark mode in discord settings for the theme to apply properly!!! */

          @import url('https://refact0r.github.io/midnight-discord/midnight.css');

          /* customize things here */
          :root {
           /* font, change to 'gg sans' for default discord font*/
           --font: 'gg sans';

           /* top left corner text */
           --corner-text: '${scheme.name}';

           /* color of status indicators and window controls */
              --online-indicator: ${base0B}; /* change to #23a55a for default green */
           --dnd-indicator: ${base08};       /* change to #f13f43 for default red */
           --idle-indicator: ${base0A};      /* change to #f0b232 for default yellow */
           --streaming-indicator: ${base0D}; /* change to #593695 for default purple */

           /* accent colors */
              --accent-1: ${base0D};     /* links */
           --accent-2: ${base0D};        /* general unread/mention elements, some icons when active */
           --accent-3: ${base0D};        /* accent buttons */
           --accent-4: ${base03};        /* accent buttons when hovered */
           --accent-5: ${base07};        /* accent buttons when clicked */
           --mention:  ${base00}1a;      /* mentions & mention messages */
           --mention-hover: ${base00}0d; /* mentions & mention messages when hovered */

           /* text colors */
           --text-0: var(--bg-4); /* text on colored elements */
           --text-1: ${base06};   /* other normally white text */
           --text-2: ${base06};   /* headings and important text */
           --text-3: ${base05};   /* normal text */
           --text-4: ${base05};   /* icon buttons and channels */
           --text-5: ${base04};   /* muted channels/chats and timestamps */

           /* background and dark colors */
            --bg-1: ${base0D};         /* dark buttons when clicked */
           --bg-2: ${base02};          /* dark buttons */
           --bg-3: ${base01};          /* spacing, secondary elements */
           --bg-4: ${base00};          /* main background color */
           --hover: ${base03}1a;       /* channels and buttons when hovered */
           --active: ${base03}33;      /* channels and buttons when clicked or selected */
           --message-hover: #0000001a; /* messages when hovered */

           /* amount of spacing and padding */
           --spacing: 12px;

           /* animations */
           /* ALL ANIMATIONS CAN BE DISABLED WITH REDUCED MOTION IN DISCORD SETTINGS */
           --list-item-transition: 0.2s ease;  /* channels/members/settings hover transition */
           --unread-bar-transition: 0.2s ease; /* unread bar moving into view transition */
           --moon-spin-transition: 0.4s ease;  /* moon icon spin */
           --icon-spin-transition: 1s ease;    /* round icon button spin (settings, emoji, etc.) */

           /* corner roundness (border-radius) */
           --roundness-xl: 22px; /* roundness of big panel outer corners */
           --roundness-l: 20px;  /* popout panels */
           --roundness-m: 16px;  /* smaller panels, images, embeds */
           --roundness-s: 12px;  /* members, settings inputs */
           --roundness-xs: 10px; /* channels, buttons */
           --roundness-xxs: 8px; /* searchbar, small elements */

           /* direct messages moon icon */
           /* change to block to show, none to hide */
           --discord-icon: none;                                                                                      /* discord icon */
           --moon-icon: block;                                                                                        /* moon icon */
           --moon-icon-url: url('https://upload.wikimedia.org/wikipedia/commons/c/c4/Font_Awesome_5_solid_moon.svg'); /* custom icon url */
           --moon-icon-size: auto;

           /* filter uncolorable elements to fit theme */
           /* (just set to none, they're too much work to configure) */
           --login-bg-filter: saturate(0.3) hue-rotate(-15deg) brightness(0.4);             /* login background artwork */
           --green-to-accent-3-filter: hue-rotate(56deg) saturate(1.43);                    /* add friend page explore icon */
           --blurple-to-accent-3-filter: hue-rotate(304deg) saturate(0.84) brightness(1.2); /* add friend page school icon */
          }

          /* Selected chat/friend text */
          .selected_f5eb4b,
          .selected_f6f816 .link_d8bfb3 {
              color: var(--text-0) !important;
              background: var(--accent-3) !important;
          }

          .selected_f6f816 .link_d8bfb3 * {
              color: var(--text-0) !important;
              fill: var(--text-0) !important;
          }
        '';
        gtk = rec {
          gtk3.extraConfig = {
            gtk-application-prefer-dark-theme = scheme.variant == "dark";
          };
          gtk4.extraConfig = gtk3.extraConfig;
        };
        dconf.settings."org/gnome/desktop/interface".color-scheme = "prefer-${scheme.variant}";
      };
    };
}
