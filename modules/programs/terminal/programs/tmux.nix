{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = (mkIf (!config.profiles.server.enable)) {
    programs.tmux = {
      enable = true;
      prefix = "C-space";
      escapeTime = 10;
      clock24 = true;
      keyMode = "vi";
      mouse = true;
      baseIndex = 1;
      extraConfig = ''
        set-option -a terminal-features "''${TERM}:RGB"
        bind c new-window -c "#{pane_current_path}"
        bind '"' split-window -v -c "#{pane_current_path}"
        bind '%' split-window -h -c "#{pane_current_path}"
        bind C-k clear-history
      '';
      plugins = builtins.attrValues {
        inherit
          (pkgs.tmuxPlugins)
          vim-tmux-navigator
          yank
          ;
      };
    };
    programs.fzf.tmux.enableShellIntegration = true;
  };
}
