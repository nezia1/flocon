{pkgs, ...}: {
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
    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      tmuxPlugins.yank
    ];
  };
  programs.fzf.tmux.enableShellIntegration = true;
}
