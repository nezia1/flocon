{pkgs, ...}: {
  config = {
    hj = {
      packages = [pkgs.zoxide];
    };
  };
}
