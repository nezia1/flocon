{
  pkgs,
  config,
  pins,
  ...
}: let
  styleCfg = config.local.style;

  theme = styleCfg.colors.scheme {
    templateRepo = pins.base16-zellij;
    use-ifd = "auto";
  };
in {
  hj = {
    packages = [pkgs.zellij];
    files = {
      ".config/zellij/config.kdl".source = pkgs.concatText "zellij-config" [
        ./config.kdl
        ./binds.kdl
        theme
      ];
    };
  };
}
