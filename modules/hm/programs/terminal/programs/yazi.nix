{
  lib,
  pkgs,
  osConfig,
  ...
}: {
  config = lib.mkIf osConfig.local.modules.hyprland.enable {
    programs.yazi = let
      # https://github.com/iynaix/dotfiles/blob/8bb1568019ea26f034ac1af9c499b3ff102391a5/home-manager/shell/yazi.nix#L9-L11
      mkYaziPlugin = name: text: {
        "${name}" = toString (pkgs.writeTextDir "${name}.yazi/init.lua" text) + "/${name}.yazi";
      };
    in {
      enable = true;
      enableFishIntegration = true;
      plugins = mkYaziPlugin "smart-enter" ''
        return {
        	entry = function()
            local h = cx.active.current.hovered
            ya.manager_emit(h and h.cha.is_dir and "enter" or "open", { hovered = true })
          end,
        }
      '';
      keymap.manager.prepend_keymap = [
        {
          on = "l";
          run = "plugin --sync smart-enter";
          desc = "Enter the child directory, or open the file";
        }
      ];
    };
  };
}
