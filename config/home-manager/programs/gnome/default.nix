{
  pkgs,
  osConfig,
  config,
  ...
}: {
  dconf = {
    enable = true;
    settings = {
      "org/gnome/shell" = {
        disable-user-extensions = false; # enables user extensions
        enabled-extensions = [
          pkgs.gnomeExtensions.appindicator.extensionUuid
          pkgs.gnomeExtensions.blur-my-shell.extensionUuid
          pkgs.gnomeExtensions.emoji-copy.extensionUuid
          pkgs.gnomeExtensions.clipboard-history.extensionUuid
        ];
      };

      "org/gnome/desktop/input-sources" = {
        xkb-options = ["compose:ralt"];
      };

      "org/gnome/desktop/interface" = {
        enable-hot-corners = false;
        color-scheme = "prefer-dark";
      };
      "org/gnome/desktop/background" = {
        picture-uri-dark = "file://" + builtins.toString osConfig.local.style.wallpaper;
      };

      "org/gnome/desktop/search-providers" = {
        disabled = [
          "org.gnome.Terminal.desktop"
          "org.gnome.Software.desktop"
          "org.gnome.seahorse.Application.desktop"
          "org.gnome.clocks.desktop"
          "org.gnome.Characters.desktop"
          "org.gnome.Calendar.desktop"
          "org.gnome.Calculator.desktop"
        ];
        enabled = [
          "org.gnome.Nautilus.desktop"
          "org.gnome.Settings.desktop"
        ];
      };

      "org/freedesktop/tracker/mine/files" = {
        index-recursive-directories = [
          "&DESKTOP"
          "&DOCUMENTS"
          "&MUSIC"
          "&PICTURES"
          "&VIDEOS"
          "${config.home.homeDirectory}/Notes"
          "${config.home.homeDirectory}/Projects"
        ];
      };
    };
  };
  home.packages = with pkgs.gnomeExtensions; [
    appindicator
    blur-my-shell
    clipboard-history
    emoji-copy
  ];
}
