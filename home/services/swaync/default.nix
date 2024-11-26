{
  osConfig,
  lib,
  lib',
  ...
}: let
  inherit (lib) optionalString;
  inherit (lib') generateGtkColors;
  inherit (osConfig.theme.scheme) palette;
  inherit (builtins) readFile;
in {
  services.swaync = {
    enable = true;
    style =
      optionalString osConfig.theme.enable generateGtkColors lib palette
      + readFile ./style.css;
    settings = {
      positionX = "right";
      positionY = "top";
      layer = "overlay";
      control-center-layer = "top";
      layer-shell = true;
      cssPriority = "application";
      control-center-margin-top = 0;
      control-center-margin-bottom = 0;
      control-center-margin-right = 0;
      control-center-margin-left = 0;
      notification-2fa-action = true;
      notification-inline-replies = false;
      notification-icon-size = 64;
      notification-body-image-height = 100;
      notification-body-image-width = 200;
    };
  };
  # systemd.user.services.swaync.Service.Environment = "WAYLAND_DISPLAY=wayland-1";
  systemd.user.services.swaync.Unit.ConditionEnvironment = lib.mkForce "";
}
