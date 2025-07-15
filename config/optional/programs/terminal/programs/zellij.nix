{
  pkgs,
  inputs',
  config,
  pins,
  ...
}: let
  inherit (settingsFormat.lib) node;
  settingsFormat = inputs'.nixpkgs-kdl.legacyPackages.formats.kdl {version = 1;};

  styleCfg = config.local.style;

  zellijTheme = styleCfg.colors.scheme {
    templateRepo = pins.base16-zellij;
    use-ifd = "auto";
  };
in {
  hj = {
    packages = [pkgs.zellij];
    files = {
      ".config/zellij/config.kdl".source = pkgs.concatText "zellij-config" [
        zellijTheme
        (settingsFormat.generate "zellij-settings" [
          (node "simplified_ui" null [true] {} [])
          (node "show_startup_tips" null [false] {} [])
          (node "ui" null [] {} [
            (node "pane_frames" null [] {} [
              (node "rounded_corners" null [true] {} [])
            ])
          ])
        ])
      ];
    };
  };
}
