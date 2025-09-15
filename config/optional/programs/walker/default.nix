{
  config,
  pkgs,
  ...
}: let
  inherit (config.local.style.gtk) iconTheme;
  ini = pkgs.formats.ini {};
  toml = pkgs.formats.toml {};
in {
  hj = {
    packages = [
      pkgs.walker
      pkgs.networkmanager_dmenu
    ];
    xdg.config.files = {
      "networkmanager-dmenu/config.ini".source = ini.generate "networkmanager-dmenu.ini" {
        dmenu = {
          dmenu_command = "walker";
          active_chars = "==";
          highlight = true;
          highlight_bold = true;
          compact = false;
          wifi_icons = " 󰤯󰤟󰤢󰤥󰤨";
          format = "{name:<{max_len_name}s}  {sec:<{max_len_sec}s} {icon:>4}";
          list_saved = false;
          prompt = "Networks";
        };

        dmenu_passphrase = {
          obscure = false;
          obscure_color = "#222222";
        };

        pinentry = {
          description = "Get network password";
          prompt = "Password: ";
        };

        editor = {
          terminal = "footclient";
          gui_if_available = true;
          gui = "nm-connection-editor";
        };

        nmdm = {
          rescan_delay = 5;
        };
      };
      "walker/config.toml".source = toml.generate "walker-config.toml" {
        app_launch_prefix = "uwsm app -- ";
        theme = "gtk";
      };
      "walker/themes/gtk.css".source = ./gtk.css;
      "walker/themes/gtk.toml".source = toml.generate "walker-gtk-config.toml" {
        ui.window.box = {
          max_height = 256;
          min_width = 512;
          height = 256;
          width = 512;

          bar = {
            orientation = "horizontal";
            position = "end";

            entry.icon = {
              pixel_size = 32;
              theme = iconTheme.name;
            };
          };

          ai_scroll = {
            name = "aiScroll";

            list = {
              name = "aiList";
              orientation = "vertical";

              item = {
                name = "aiItem";
                wrap = true;
              };
            };
          };

          scroll.list = {
            max_height = 256;
            min_width = 512;
            height = 256;
            width = 512;
          };

          search = {
            prompt = {
              name = "prompt";
              icon = "edit-find";
              pixel_size = 16;
            };

            clear = {
              name = "clear";
              icon = "edit-clear";
              pixel_size = 16;
            };

            input = {
              icons = true;
            };

            spinner = {
              hide = false;
            };
          };
        };
      };
    };
  };
}
