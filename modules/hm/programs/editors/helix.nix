{
  lib,
  pkgs,
  osConfig,
  ...
}: {
  config = lib.mkIf osConfig.local.profiles.desktop.enable {
    programs.helix = {
      enable = true;
      settings = {
        theme = "catppuccin_macchiato";
        editor = {
          line-number = "relative";
          lsp.display-messages = true;
          auto-format = true;
          auto-completion = true;
          completion-timeout = 5;
          color-modes = true;
          completion-trigger-len = 1;
          completion-replace = true;
          cursorline = true;
          cursor-shape = {
            insert = "bar";
            normal = "block";
            select = "underline";
          };
          indent-guides.render = true;
          lsp.display-inlay-hints = true;
          statusline.center = ["position-percentage"];
          true-color = true;
          whitespace.characters = {
            newline = "↴";
            tab = "⇥";
          };
        };

        keys.normal = {
          space = {
            space = "file_picker";
            w = ":w";
            q = ":q";
          };
          esc = ["collapse_selection" "keep_primary_selection"];
        };
      };

      languages = {
        language = [
          {
            name = "nix";
            auto-format = true;
          }
        ];

        language-server = {
          nil = {
            command = lib.getExe pkgs.nil;
            config.nil.formatting.command = ["${lib.getExe pkgs.alejandra}" "-q"];
          };
        };
      };
    };
  };
}
