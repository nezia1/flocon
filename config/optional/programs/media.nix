{pkgs, ...}: {
  config = {
    hj.packages = builtins.attrValues {
      inherit
        (pkgs)
        spotify
        stremio
        tidal-hifi
        celluloid
        gthumb
        papers
        ;
    };
  };
}
