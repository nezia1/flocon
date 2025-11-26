{
  pkgs,
  inputs',
  ...
}: {
  config = {
    hj.packages = with pkgs; [
      celluloid
      gthumb
      papers
      kdePackages.arianna
      # inputs'.tidaluna.packages.default
    ];
  };
}
