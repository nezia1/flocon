{
  appimageTools,
  fetchurl,
  makeDesktopItem,
  ...
}: let
  version = "1.0.0";
  pname = "ankama-launcher";
  src = fetchurl {
    url = "https://launcher.cdn.ankama.com/installers/production/Ankama%20Launcher-Setup-x86_64.AppImage";
    sha256 = "sha256-K/qe/qxMfcGWU5gyEfPdl0ptjTCWaqIXMCy4O8WEKCQ=";
  };
  desktopItem = makeDesktopItem {
    desktopName = "Ankama Launcher";
    name = pname;
    exec = pname;
    icon = pname;
  };

  appimageContents = appimageTools.extract {
    inherit pname version src;
  };
in
  appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      mkdir -p $out/share/applications $out/share/icons/hicolor/256x256/apps
      install -Dm644 ${appimageContents}/usr/share/icons/hicolor/256x256/apps/zaap*.png $out/share/icons/hicolor/256x256/apps/${pname}.png
      install -Dm644 ${desktopItem}/share/applications/* $out/share/applications
    '';
  }
