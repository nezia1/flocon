{pkgs, ...}: {
  config = {
    hj.packages = builtins.attrValues {
      inherit
        (pkgs)
        # TODO: Insecure, wait for stremio-linux-shell or use the flatpak
        # stremio
        celluloid
        spotify
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
