{pkgs, ...}: {
  # requires `security.pam.services.swaylock = { };` at the system level or else
  # unlock will not work.
  programs.swaylock = {
    enable = true;
    package = pkgs.swaylock-effects;

    settings = {
      clock = true;
      timestr = "%H:%M";

      indicator = true;
      indicator-radius = 111;
      indicator-thickness = 9;

      screenshots = true;
      effect-blur = "7x5";
      effect-vignette = "0.75:0.75";
      effect-pixelate = 5;

      ignore-empty-password = false; # needed for PAM to work with fprintd / password
    };
  };
}
