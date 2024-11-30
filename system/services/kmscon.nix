{pkgs, ...}: {
  services.kmscon = {
    enable = true;
    fonts = [
      {
        name = "0xProto NF";
        package = pkgs.nerd-fonts._0xproto;
      }
    ];
    extraConfig = ''
      font-size=14
      font-dpi=144
    '';
  };
}
