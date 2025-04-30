{
  lib,
  stdenvNoCC,
  pins,
}:
stdenvNoCC.mkDerivation {
  pname = "app2unit";
  version = "0-unstable-${pins.app2unit.revision}";

  src = pins.app2unit;

  installPhase = ''
    install -Dt $out/bin app2unit
    ln -s $out/bin/app2unit $out/bin/app2unit-open
  '';

  meta = {
    description = "Launches Desktop Entries as Systemd user units";
    homepage = "https://github.com/Vladimir-csp/app2unit";
    mainProgram = "app2unit";
    license = lib.licenses.gpl3;
    platforms = lib.platforms.linux;
  };
}
