{
  inputs,
  pkgs,
  osConfig,
  ...
}: let
  inherit (inputs.basix.schemeData.base16.${osConfig.theme.scheme}) palette;
in {
  # requires `security.pam.services.swaylock = { };` at the system level or else
  # unlock will not work.
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;

    settings = {
      clock = true;
      timestr = "%H:%M";

      indicator = true;
      indicator-radius = 111;
      indicator-thickness = 9;

      screenshots = true;
      effect-blur = "7x5";
      effect-vignette = "0.75:0.75";
      effect-pixelate = 5;

      ignore-empty-password = false; # needed for PAM to work with fprintd / password

      inside-color = palette.base01;
      inside-clear-color = palette.base0C;
      inside-caps-lock-color = palette.base09;
      inside-ver-color = palette.base0D;
      inside-wrong-color = palette.base08;
      key-hl-color = palette.base0B;
      layout-bg-color = palette.base00;
      layout-border-color = palette.base05;
      layout-text-color = palette.base07;
      line-color = palette.base00;
      line-clear-color = palette.base0C;
      line-caps-lock-color = palette.base09;
      line-ver-color = palette.base0D;
      line-wrong-color = palette.base08;
      ring-color = palette.base02;
      ring-clear-color = palette.base0C;
      ring-caps-lock-color = palette.base09;
      ring-ver-color = palette.base0D;
      ring-wrong-color = palette.base08;
      separator-color = palette.base02;
      text-color = palette.base07;
      text-clear-color = palette.base04;
      text-caps-lock-color = palette.base04;
      text-ver-color = palette.base04;
      text-wrong-color = palette.base04;
    };
  };
}
