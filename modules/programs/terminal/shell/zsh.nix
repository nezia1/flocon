{
  lib,
  pkgs,
  config,
  ...
}: let
  inherit (lib) mkIf;
  inherit (config.local.systemVars) username;
in {
  config = mkIf config.local.profiles.desktop.enable {
    programs.zsh.enable = true;
    hjem.users.${username} = {
      packages = [pkgs.zsh];
      files = {
        ".zshrc".text = ''
          SAVEHIST=2000
          HISTSIZE=2000
          ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=cyan,underline"
          ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)

          bindkey -v

          eval "$(starship init zsh)"
          eval "$(zoxide init zsh)"

          source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
          source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh

          # aliases
          alias lg='lazygit'
          alias g='git'
          alias gs='git status'
          alias ga='git add'
          alias gc='git commit'
          alias gca='git commit --amend'
          alias gcm='git commit --message'
          alias gk='git checkout'
          alias gd='git diff'
          alias gf='git fetch'
          alias gl='git log'
          alias gp='git push'
          alias gpf='git push --force-with-lease'
          alias gr='git reset'
          alias gt='git stash'
          alias gtp='git stash pop'
          alias gu='git pull'
        '';
      };
    };
  };
}
