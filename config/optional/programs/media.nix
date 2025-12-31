{pkgs, ...}: {
  config = {
    hj.packages = with pkgs; [
      celluloid
      gthumb
      papers
      kdePackages.arianna
      tidal-hifi
    ];
  };
}
