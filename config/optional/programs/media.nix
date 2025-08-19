{pkgs, ...}: {
  config = {
    hj.packages = builtins.attrValues {
      inherit
        (pkgs)
        spotify
        stremio
        celluloid
        gthumb
        papers
        ;

      inherit
        (pkgs.kdePackages)
        arianna
        ;
    };
  };
}
