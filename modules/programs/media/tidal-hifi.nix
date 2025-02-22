{
  lib,
  config,
  pkgs,
  ...
}: let
  inherit (lib.modules) mkIf;

  inherit (config.local.systemVars) username;

  styleCfg = config.local.style;
in {
  config = mkIf config.local.profiles.desktop.enable {
    hjem.users.${username} = {
      packages = [pkgs.tidal-hifi];
      files = {
        # based on https://github.com/rose-pine/tidal. adapted to work with base16 colors.
        "tidal-hifi/themes/base16.css".text = with styleCfg.scheme.palette;
          mkIf styleCfg.enable ''
            :root {
              --glass-white-1: ${base05};
              --glass-white-1-hover: ${base06};
              --glass-white-2: ${base07};
              --glass-white-2-hover: ${base08};
              --glass-white-3: ${base07};
              --glass-white-4: ${base04};
              --glass-white-5: ${base04};
              --glass-white-6: ${base05};
              --snow-white: ${base07};
              --snow-white-hover: ${base08};
              --gray-4: ${base00};
              --gray-5: ${base02};
              --gray-6: ${base03};
              --gray-7: ${base04};
              --cyan-blue: ${base0D};
              --cyan-blue-hover: ${base0C};
              --glass-cyan-1: ${base04};
              --glass-cyan-2: ${base05};
              --glass-cyan-3: ${base06};
              --master-gold: ${base0E};
              --master-gold-hover: ${base08};
              --glass-master-gold: ${base05};
              --glass-master-gold-2: ${base06};
              --raspberry-pink: ${base08};
              --raspberry-pink-lighter: ${base09};
              --black: ${base00};
              --midnight-black: ${base00};
              --controls-overlay: ${base03};
              --duration-overlay: ${base02};
              --background-dark: ${base00};
              --hoverLighten: brightness(130%);
              --hoverDarken: brightness(70%);
              --hoverTransition: filter 0.15s ease;
              --scrollbar-track: ${base03};
              --scrollbar-thumb: ${base00};
              --lighten-25: ${base01};
              --red-alert: ${base08};
              --user-profile-linear-gradient: linear-gradient(160deg,${base0D} 1.22%,${base0C} 40.51%,${base00} 79.07%);
              --wave-border-radius--none: 0px;
              --wave-border-radius--extra-small: 4px;
              --wave-border-radius--small: 8px;
              --wave-border-radius--regular: 12px;
              --wave-border-radius--full: 1000px;
              --wave-color-material-dark: ${base00}80;
              --wave-color-material-light: ${base04}33;
              --wave-color-opacity-accent-dark-ultra-thick: ${base0C}cc;
              --wave-color-opacity-accent-darkest-ultra-thick: ${base01};
              --wave-color-opacity-accent-fill-regular: ${base0C}66;
              --wave-color-opacity-accent-fill-thin: ${base0C}33;
              --wave-color-opacity-accent-fill-ultra-thick: ${base0C}cc;
              --wave-color-opacity-accent-fill-ultra-thin: ${base0C}1a;
              --wave-color-opacity-base-bright-thick: ${base00}99;
              --wave-color-opacity-base-bright-thin: ${base00}33;
              --wave-color-opacity-base-bright-transparent: ${base00};
              --wave-color-opacity-base-bright-ultra-thick: ${base00}cc;
              --wave-color-opacity-base-brighter-ultra-thick: ${base01}cc;
              --wave-color-opacity-base-brightest-regular: ${base02}66;
              --wave-color-opacity-base-brightest-thin: ${base02}33;
              --wave-color-opacity-base-brightest-ultra-thin: ${base02}1a;
              --wave-color-opacity-base-fill-regular: ${base00}66;
              --wave-color-opacity-base-fill-thick: ${base00}99;
              --wave-color-opacity-base-fill-thin: ${base00}33;
              --wave-color-opacity-base-fill-transparent: #000;
              --wave-color-opacity-base-fill-ultra-thick: ${base00}cc;
              --wave-color-opacity-base-fill-ultra-thin: ${base00}1a;
              --wave-color-opacity-contrast-fill-regular: ${base07}66;
              --wave-color-opacity-contrast-fill-thick: ${base07}99;
              --wave-color-opacity-contrast-fill-thin: ${base07}33;
              --wave-color-opacity-contrast-fill-transparent: #fff;
              --wave-color-opacity-contrast-fill-ultra-thick: ${base07}cc;
              --wave-color-opacity-contrast-fill-ultra-thin: ${base07}1a;
              --wave-color-opacity-rainbow-blue-thin: ${base0D}33;
              --wave-color-opacity-rainbow-yellow-fill-regular: ${base0E}66;
              --wave-color-opacity-rainbow-yellow-fill-thin: ${base0E}33;
              --wave-color-opacity-rainbow-yellow-fill-ultra-thick: ${base0E}cc;
              --wave-color-opacity-rainbow-yellow-fill-ultra-thin: ${base0E}1a;
              --wave-color-opacity-special-fill-regular: ${base0E}66;
              --wave-color-opacity-special-fill-thin: ${base0E}33;
              --wave-color-opacity-special-fill-ultra-thick: ${base0E}cc;
              --wave-color-opacity-special-fill-ultra-thin: ${base0E}1a;
              --wave-color-services-facebook: ${base0D};
              --wave-color-services-instagram-red: ${base08};
              --wave-color-services-mtn: ${base0E};
              --wave-color-services-musix-orange: ${base09};
              --wave-color-services-musix-pink: ${base0E};
              --wave-color-services-play: ${base0C};
              --wave-color-services-plus: ${base0B};
              --wave-color-services-snapchat: ${base0A};
              --wave-color-services-sprint: ${base0A};
              --wave-color-services-t-mobile: ${base08};
              --wave-color-services-tik-tok-blue: ${base0D};
              --wave-color-services-tik-tok-red: ${base08};
              --wave-color-services-twitter: ${base0D};
              --wave-color-services-viacom-1: ${base0D};
              --wave-color-services-viacom-2: ${base0E};
              --wave-color-services-viacom-3: ${base08};
              --wave-color-services-viacom-4: ${base09};
              --wave-color-services-viacom-5: ${base0E};
              --wave-color-services-vivo: ${base0E};
              --wave-color-services-vodafone: ${base08};
              --wave-color-services-waze: ${base0D};
              --wave-color-solid-accent-bright: ${base0D};
              --wave-color-solid-accent-brighter: ${base0D};
              --wave-color-solid-accent-dark: ${base0C};
              --wave-color-solid-accent-darker: ${base01};
              --wave-color-solid-accent-darkest: ${base00};
              --wave-color-solid-accent-fill: ${base0D};
              --wave-color-solid-base-bright: ${base00};
              --wave-color-solid-base-brighter: ${base01};
              --wave-color-solid-base-brightest: ${base02};
              --wave-color-solid-base-fill: ${base00};
              --wave-color-solid-contrast-dark: ${base07};
              --wave-color-solid-contrast-darker: ${base06};
              --wave-color-solid-contrast-darkest: ${base05};
              --wave-color-solid-contrast-fill: ${base07};
              --wave-color-solid-rainbow-blue-fill: ${base0D};
              --wave-color-solid-rainbow-green-brighter: ${base0D};
              --wave-color-solid-rainbow-green-dark: ${base0C};
              --wave-color-solid-rainbow-green-darker: ${base0C};
              --wave-color-solid-rainbow-green-darkest: ${base01};
              --wave-color-solid-rainbow-green-fill: ${base0D};
              --wave-color-solid-rainbow-orange-fill: ${base09};
              --wave-color-solid-rainbow-purple-fill: ${base0E};
              --wave-color-solid-rainbow-red-bright: ${base08};
              --wave-color-solid-rainbow-red-brighter: ${base08};
              --wave-color-solid-rainbow-red-dark: ${base09};
              --wave-color-solid-rainbow-red-darker: ${base01};
              --wave-color-solid-rainbow-red-darkest: ${base00};
              --wave-color-solid-rainbow-red-fill: ${base08};
              --wave-color-solid-rainbow-yellow-bright: ${base0A};
              --wave-color-solid-rainbow-yellow-brighter: ${base06};
              --wave-color-solid-rainbow-yellow-dark: ${base09};
              --wave-color-solid-rainbow-yellow-darker: ${base01};
              --wave-color-solid-rainbow-yellow-darkest: ${base00};
              --wave-color-solid-rainbow-yellow-fill: ${base0A};
              --wave-color-solid-special-bright: ${base09};
              --wave-color-solid-special-brighter: ${base06};
              --wave-color-solid-special-dark: ${base09};
              --wave-color-solid-special-darker: ${base09};
              --wave-color-solid-special-darkest: ${base00};
              --wave-color-solid-special-fill: ${base0E};
              --wave-color-solid-warning-bright: ${base08};
              --wave-color-solid-warning-brighter: ${base09};
              --wave-color-solid-warning-dark: ${base09};
              --wave-color-solid-warning-darker: ${base01};
              --wave-color-solid-warning-darkest: ${base00};
              --wave-color-solid-warning-fill: ${base08};
              --wave-color-text-disabled: ${base02};
              --wave-color-text-link: ${base0D};
              --wave-color-text-main: ${base07};
              --wave-color-text-placeholder: ${base02};
              --wave-color-text-secondary: ${base06};
              --wave-color-text-tertiary: ${base05};
              --wave-font-weight--bold: 700;
              --wave-font-weight--demi: 600;
              --wave-font-weight--medium: 500;
              --wave-opacity--ultra-thin: .05;
              --wave-opacity--thin: .1;
              --wave-opacity--regular: .4;
              --wave-opacity--thick: .6;
              --wave-opacity--ultra-thick: .8;
              --wave-spacing--extra-extra-large: 64px;
              --wave-spacing--extra-large: 40px;
              --wave-spacing--large: 24px;
              --wave-spacing--medium: 20px;
              --wave-spacing--regular: 16px;
              --wave-spacing--small: 12px;
              --wave-spacing--extra-small: 8px;
              --wave-spacing--extra-extra-small: 4px;
            }

            .wave-text-caption-demi, .tidal-ui__v-stack {
                color: var(--wave-color-solid-accent-bright) !important;
            }

            .tidal-ui__icon {
                fill: var(--wave-color-solid-rainbow-purple-fill) !important;
                stroke: var(--wave-color-solid-rainbow-purple-fill) !important;
            }
          '';
      };
    };
  };
}
