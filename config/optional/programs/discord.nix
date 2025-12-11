{
  lib,
  pkgs,
  inputs,
  ...
}: let
  pkgsDiscord = import inputs.nixpkgs-discord-krisp-fix {
    system = pkgs.stdenv.hostPlatform.system;
    config.allowUnfree = true;
  };
  discord =
    (pkgsDiscord.discord.overrideAttrs {
      inherit (pkgs.discord) version src;
    }).override {
      # TODO: fix OpenASAR / Vencord / Moonlight being wrong in upstream PR (cd doesnt go into correct dir)
    };
in {
  config = {
    hj = {
      packages = [discord];
      rum.xdg.autostart.programs = [discord];
    };
  };
}
