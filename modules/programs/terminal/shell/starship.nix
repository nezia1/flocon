{
  lib,
  config,
  ...
}: let
  inherit (lib.modules) mkIf;
in {
  config = mkIf (!config.local.profiles.server.enable) {
    hj.rum.programs.starship = {
      enable = true;
      settings = {
        character = {
          error_symbol = "[✖](bold red)";
        };

        # from NotAShelf - https://github.com/NotAShelf/nyx/blob/d407b4d6e5ab7f60350af61a3d73a62a5e9ac660/homes/notashelf/programs/terminal/shell/starship.nix#L76-L88
        git_status = {
          style = "red";
          ahead = "⇡ ";
          behind = "⇣ ";
          conflicted = " ";
          renamed = "»";
          deleted = "✘ ";
          diverged = "⇆ ";
          modified = "!";
          stashed = "≡";
          staged = "+";
          untracked = "?";
        };

        nix_shell = {
          symbol = " ";
          heuristic = true;
        };
      };
    };
  };
}
