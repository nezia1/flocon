{ ... }:

{
  programs.nixvim.plugins = {
    nvim-autopairs.enable = true;
    direnv.enable = true;
    tmux-navigator.enable = true;
  };
}