{
  inputs,
  config,
  lib,
  pkgs,
  ...
}: {
  environment.systemPackages = [
    inputs.hyprland-qtutils.packages.${pkgs.system}.default
  ];
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    portalPackage = inputs.hyprland.packages.${pkgs.system}.xdg-desktop-portal-hyprland;
    withUWSM = true;
  };

  # copied from https://github.com/linyinfeng/dotfiles/blob/91b0363b093303f57885cbae9da7f8a99bbb4432/nixos/profiles/graphical/niri/default.nix#L17-L29
  security.pam.services.hyprlock.text = lib.mkIf config.services.fprintd.enable ''
    account required pam_unix.so

    # check passwork before fprintd
    auth sufficient pam_unix.so try_first_pass likeauth
    auth sufficient ${pkgs.fprintd}/lib/security/pam_fprintd.so
    auth required pam_deny.so

    password sufficient pam_unix.so nullok yescrypt

    session required pam_env.so conffile=/etc/pam/environment readenv=0
    session required pam_unix.so
  '';
}
