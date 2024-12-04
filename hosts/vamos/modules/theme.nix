{pkgs, ...}: {
  theme = {
    enable = true;
    wallpaper = pkgs.fetchurl {
      url = "https://raw.githubusercontent.com/NixOS/nixos-artwork/e0cf0eb237dc5baba86661a3572b20a6183c1876/wallpapers/nix-wallpaper-nineish-catppuccin-frappe.png?raw=true";
      hash = "sha256-/HAtpGwLxjNfJvX5/4YZfM8jPNStaM3gisK8+ImRmQ4=";
    };
    schemeName = "rose-pine-moon";
    gtk.theme = {
      name = "rose-pine-moon";
      package = pkgs.rose-pine-gtk-theme;
    };
  };
}
