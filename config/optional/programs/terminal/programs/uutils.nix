{pkgs, ...}: {
  config = {
    hj = {
      packages = [pkgs.uutils-coreutils-noprefix];
    };
  };
}
