{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
  inherit (pkgs.writers) writeTOML;
  inherit (config.local.style.gtk) iconTheme;
in {
  config = mkIf (config.local.vars.home.desktop.type == "wm") {
    # FIXME: seems to stop when another instance is launched
    # hm.systemd.user.services.walker = {
    #   Unit.Description = "Walker - Application Runner";
    #   Install.WantedBy = ["graphical-session.target"];
    #   Service = {
    #     ExecStart = "${pkgs.walker}/bin/walker --gapplication-service";
    #     Restart = "on-failure";
    #   };
    # };

    hj = {
      # TODO: configure when not lazy
      packages = [pkgs.walker];
      files = {
        ".config/walker/config.toml".source = writeTOML "walker-config.toml" {
          app_launch_prefix = "uwsm app -- ";
          theme = "gtk";
        };
        ".config/walker/themes/gtk.css".source = ./gtk.css;
        ".config/walker/themes/gtk.toml".source = writeTOML "walker-gtk-config.toml" {
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
  };
}
