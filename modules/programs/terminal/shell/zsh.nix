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
          ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=8"

          ZSH_HIGHLIGHT_HIGHLIGHTERS=(main brackets pattern)
          bindkey -v

          eval "$(starship init zsh)"
          eval "$(zoxide init zsh)"

          source <(fzf --zsh)
          source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

          ZSH_HIGHLIGHT_STYLES[default]=none
          ZSH_HIGHLIGHT_STYLES[unknown-token]=fg=red,underline
          ZSH_HIGHLIGHT_STYLES[reserved-word]=fg=cyan,bold
          ZSH_HIGHLIGHT_STYLES[suffix-alias]=fg=green,underline
          ZSH_HIGHLIGHT_STYLES[global-alias]=fg=green,bold
          ZSH_HIGHLIGHT_STYLES[precommand]=fg=green,underline
          ZSH_HIGHLIGHT_STYLES[commandseparator]=fg=blue,bold
          ZSH_HIGHLIGHT_STYLES[autodirectory]=fg=green,underline
          ZSH_HIGHLIGHT_STYLES[path]=bold
          ZSH_HIGHLIGHT_STYLES[path_pathseparator]=
          ZSH_HIGHLIGHT_STYLES[path_prefix_pathseparator]=
          ZSH_HIGHLIGHT_STYLES[globbing]=fg=blue,bold
          ZSH_HIGHLIGHT_STYLES[history-expansion]=fg=blue,bold
          ZSH_HIGHLIGHT_STYLES[command-substitution]=none
          ZSH_HIGHLIGHT_STYLES[command-substitution-delimiter]=fg=magenta,bold
          ZSH_HIGHLIGHT_STYLES[process-substitution]=none
          ZSH_HIGHLIGHT_STYLES[process-substitution-delimiter]=fg=magenta,bold
          ZSH_HIGHLIGHT_STYLES[single-hyphen-option]=fg=green
          ZSH_HIGHLIGHT_STYLES[double-hyphen-option]=fg=green
          ZSH_HIGHLIGHT_STYLES[back-quoted-argument]=none
          ZSH_HIGHLIGHT_STYLES[back-quoted-argument-delimiter]=fg=blue,bold
          ZSH_HIGHLIGHT_STYLES[single-quoted-argument]=fg=yellow
          ZSH_HIGHLIGHT_STYLES[double-quoted-argument]=fg=yellow
          ZSH_HIGHLIGHT_STYLES[dollar-quoted-argument]=fg=yellow
          ZSH_HIGHLIGHT_STYLES[rc-quote]=fg=magenta
          ZSH_HIGHLIGHT_STYLES[dollar-double-quoted-argument]=fg=magenta,bold
          ZSH_HIGHLIGHT_STYLES[back-double-quoted-argument]=fg=magenta,bold
          ZSH_HIGHLIGHT_STYLES[back-dollar-quoted-argument]=fg=magenta,bold
          ZSH_HIGHLIGHT_STYLES[assign]=none
          ZSH_HIGHLIGHT_STYLES[redirection]=fg=blue,bold
          ZSH_HIGHLIGHT_STYLES[comment]=fg=black,bold
          ZSH_HIGHLIGHT_STYLES[named-fd]=none
          ZSH_HIGHLIGHT_STYLES[numeric-fd]=none
          ZSH_HIGHLIGHT_STYLES[arg0]=fg=cyan
          ZSH_HIGHLIGHT_STYLES[bracket-error]=fg=red,bold
          ZSH_HIGHLIGHT_STYLES[bracket-level-1]=fg=blue,bold
          ZSH_HIGHLIGHT_STYLES[bracket-level-2]=fg=green,bold
          ZSH_HIGHLIGHT_STYLES[bracket-level-3]=fg=magenta,bold
          ZSH_HIGHLIGHT_STYLES[bracket-level-4]=fg=yellow,bold
          ZSH_HIGHLIGHT_STYLES[bracket-level-5]=fg=cyan,bold
          ZSH_HIGHLIGHT_STYLES[cursor-matchingbracket]=standout
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
