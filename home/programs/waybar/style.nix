{
  inputs,
  lib,
  osConfig,
  ...
}: let
  inherit (inputs.basix.schemeData.base16.${osConfig.theme.scheme}) palette;
  inherit (builtins) concatStringsSep;
  inherit (lib) mapAttrsToList;

  generateGtkColors = palette: (concatStringsSep "\n"
    (mapAttrsToList
      (name: color: "@define-color ${name} ${color};")
      palette));
in {
  programs.waybar.style = ''
    ${
      if osConfig.theme.enable
      then generateGtkColors palette
      else ""
    }

    * {
      /* `otf-font-awesome` is required to be installed for icons */
      border: none;
      border-radius: 0px;
      min-height: 0;
    }

    window#waybar {
      border-radius: 2em;
      font-family: "Symbols Nerd Font", Inter, sans-serif;
      font-size: 16px;
      font-style: normal;
      background: alpha(
        @base00,
        0.9999999
      ); /* niri issue workaround, thanks https://github.com/oatmealine/nix-config/blob/bfdddd2cb36ef659bcddc28e0dbb542b6db8b3bc/modules/desktop/themes/catppuccin/waybar.css#L14 */
      color: @base05;
    }

    #workspaces,
    .modules-right box {
      background: @base02;
      padding: 0.15em 0.25em;
      border-radius: 1em;
      margin: 0 0.25em;
    }

    #workspaces {
      padding: 0;
      background: @base02;
    }

    #workspaces button:nth-child(1) {
      border-top-left-radius: 1em;
      border-bottom-left-radius: 1em;
    }
    #workspaces button:nth-last-child(1) {
      border-top-right-radius: 1em;
      border-bottom-right-radius: 1em;
    }

    #workspaces button {
      padding: 0 0.5em;
      background-color: transparent;
    }

    #workspaces button:hover {
      background: rgba(255, 255, 255, 0.1);
      box-shadow: none;
    }

    #workspaces button.active {
      background: @base0E;
      color: @base02;
    }

    #workspaces button.urgent {
      background: @base08;
    }

    #window {
      margin-left: 1em;
    }

    .modules-left,
    .modules-right {
      margin: 0.4em 0.5em;
    }

    #battery,
    #clock,
    #pulseaudio,
    #tray,
    #power-profiles-daemon {
      padding: 0 0.8em;
    }

    .modules-left,
    .modules-right {
      margin: 0.4em 0.5em;
    }


    #custom-power {
      padding: 0 1.2em;
      color: @base08;
    }
  '';
}
