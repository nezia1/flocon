{
  inputs,
  lib,
  pkgs,
  config,
  ...
}: {
  imports = [
    inputs.niri.nixosModules.niri
  ];

  programs.niri = {
    enable = true;
  };

  # copied from https://github.com/linyinfeng/dotfiles/blob/91b0363b093303f57885cbae9da7f8a99bbb4432/nixos/profiles/graphical/niri/default.nix#L17-L29
  security.pam.services.swaylock.text = lib.mkIf config.services.fprintd.enable ''
    account required pam_unix.so

    # check passwork before fprintd
    auth sufficient pam_unix.so try_first_pass likeauth
    auth sufficient ${pkgs.fprintd}/lib/security/pam_fprintd.so
    auth required pam_deny.so

    password sufficient pam_unix.so nullok yescrypt

    session required pam_env.so conffile=/etc/pam/environment readenv=0
    session required pam_unix.so
  '';

  environment.systemPackages = [pkgs.xwayland-satellite];
}
