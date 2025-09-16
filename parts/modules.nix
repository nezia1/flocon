_: {
  flake = {
    hjemModules = {
      librewolf = ../modules/shared/hjem-rum/librewolf.nix;
      xdg-autostart = ../modules/shared/hjem-rum/xdg/autostart.nix;
      qtct = ../modules/shared/hjem/misc/qtct.nix;
      kvantum = ../modules/shared/hjem/misc/kvantum.nix;
      jujutsu = ../modules/shared/hjem-rum/jujutsu.nix;
    };
  };
}
