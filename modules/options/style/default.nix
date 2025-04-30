{
  lib,
  pkgs,
  config,
  options,
  pins,
  inputs',
  ...
}: let
  inherit (builtins) pathExists toString;
  inherit (lib.lists) singleton;
  inherit (lib.modules) mkIf;
  inherit (lib.options) mkEnableOption mkOption;
  inherit (lib.types) listOf bool package path str;

  cfg = config.local.style;
in {
  imports = [./colors.nix];

  options.local.style = {
    enable = mkEnableOption "style";
    wallpapers = mkOption {
      description = ''
        Location of the wallpaper that will be used throughout the system.
      '';
      type = listOf path;
      example = lib.literalExpression "./wallpaper.png";
    };

    cursors = {
      size = mkOption {
        description = ''
          Size of the cursor.
        '';
        default = 32;
      };
      xcursor = {
        name = mkOption {
          description = ''
            Name of the Xcursor theme.
          '';
          default = "phinger-cursors-dark";
        };
        package = mkOption {
          default = pkgs.phinger-cursors;
          description = ''
            Package providing the Xcursor theme.
          '';
        };
      };

      hyprcursor = {
        name = mkOption {
          description = ''
            Name of the hyprcursor theme.
          '';
          default = "phinger-cursors-dark-hyprcursor";
        };
        package = mkOption {
          inherit (inputs'.hyprcursor-phinger.packages) default;
          description = ''
            Package providing the hyprcursor theme.
          '';
        };
      };
    };

    gtk = {
      enable = mkOption {
        type = bool;
        description = "enable GTK theming options";
        default = cfg.enable;
      };
      theme = {
        name = mkOption {
          type = str;
          description = "Name for the GTK theme";
          default = "adw-gtk3-dark";
        };
        package = mkOption {
          type = package;
          description = "Package providing the GTK theme";

          default = pkgs.adw-gtk3;
        };
      };

      iconTheme = {
        name = mkOption {
          type = str;
          description = "The name for the icon theme that will be used for GTK programs";
          default = "MoreWaita";
        };

        package = mkOption {
          type = package;
          description = builtins.trace (pins.MoreWaita "The GTK icon theme to be used");
          default = pkgs.morewaita-icon-theme.overrideAttrs {
            src = pins.MoreWaita;
            installPhase = ''
              runHook preInstall

              install -d $out/share/icons/MoreWaita
              cp -r . $out/share/icons/MoreWaita
              cp ${../../../assets/icons/my-caffeine-on-symbolic.svg} $out/share/icons/MoreWaita/symbolic/status/my-caffeine-on-symbolic.svg
              cp ${../../../assets/icons/my-caffeine-off-symbolic.svg} $out/share/icons/MoreWaita/symbolic/status/my-caffeine-off-symbolic.svg
              gtk-update-icon-cache -f -t $out/share/icons/MoreWaita && xdg-desktop-menu forceupdate

              runHook postInstall
            '';

            /*
            a patch is needed because MoreWaita expects a `meson.build` file in the directory, containing the
            name of every icon.
            */
            patches = singleton (pkgs.writeText "add-caffeine-icons.patch" ''
              diff --git a/symbolic/status/meson.build b/symbolic/status/meson.build
              index 4e5bfc5..3bbf989 100644
              --- a/symbolic/status/meson.build
              +++ b/symbolic/status/meson.build
              @@ -17,2 +17,4 @@ regular_files = [
                   'keepassxc-unlocked.svg',
              +    'my-caffeine-off-symbolic.svg',
              +    'my-caffeine-on-symbolic.svg',
                   'pamac-tray-no-update.svg',
            '');
          };
        };
      };
    };
  };

  config = mkIf cfg.enable {
    assertions = [
      (let
        themePath = cfg.gtk.theme.package + /share/themes + "/${cfg.gtk.theme.name}";
      in {
        assertion = cfg.gtk.enable -> pathExists themePath;
        message = ''
          ${toString themePath} set by the GTK module does not exist!

          To suppress this message, make sure that
          `config.local.theme.gtk.theme.package` contains
          the path `${cfg.gtk.theme.name}`
        '';
      })
      (let
        iconPath = cfg.gtk.iconTheme.package + /share/icons + "/${cfg.gtk.iconTheme.name}";
      in {
        assertion = cfg.gtk.enable -> pathExists iconPath;
        message = ''
          ${toString iconPath} set by the GTK module does not exist!

          To suppress this message, make sure that
          `config.local.theme.gtk.iconTheme.package` contains
          the path `${cfg.gtk.iconTheme.name}`
        '';
      })
      {
        assertion = cfg.enable -> options.local.vars.system.username.isDefined;
        message = ''
          When enabling system-wide theming, a username needs to be set in
          `config.local.vars.systemVars.username`.
        '';
      }
    ];
  };
}
