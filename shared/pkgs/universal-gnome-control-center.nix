{
  symlinkJoin,
  gnome-control-center,
  makeWrapper,
  ...
}: let
  universal-gnome-control-center = symlinkJoin {
    name = "${gnome-control-center}-universal";
    paths = [gnome-control-center];
    nativeBuildInputs = [
      makeWrapper
    ];
    postBuild = ''
      wrapProgram $out/bin/gnome-control-center \
        --set XDG_CURRENT_DESKTOP gnome
    '';

    meta = {
      description = "A simple wrapper around `gnome-control-center`, making it work across every desktop environment.";
    };
  };
in
  universal-gnome-control-center
