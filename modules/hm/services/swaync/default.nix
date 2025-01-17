{
  lib,
  lib',
  osConfig,
  ...
}: let
  styleCfg = osConfig.local.style;
in {
  config = lib.mkIf osConfig.local.modules.hyprland.enable {
    services.swaync = lib.mkMerge [
      {
        enable = true;
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
      }

      (lib.mkIf styleCfg.enable {
        style =
          lib'.generateGtkColors lib styleCfg.scheme.palette
          + builtins.readFile ./style.css;
      })
    ];

    systemd.user.services.swaync.Unit.ConditionEnvironment = lib.mkForce "";
  };
}
