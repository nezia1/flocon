{pkgs, ...}: let
  nixpkgsManual = pkgs.makeDesktopItem {
    name = "nixpkgs-manual";
    desktopName = "Nixpkgs Manual";
    exec = "${pkgs.xdg-utils}/bin/xdg-open ${pkgs.nixpkgs-manual}/share/doc/nixpkgs/manual.html";
    icon = "nix-snowflake";
  };
in {
  config = {
    environment.systemPackages = [
      nixpkgsManual
      pkgs.man-pages
      pkgs.man-pages-posix
    ];
    documentation = {
      enable = true;
      dev.enable = true;

      man = {
        enable = true;
        man-db.enable = false;
        mandoc.enable = true;
        generateCaches = true;
      };
    };
  };
}
