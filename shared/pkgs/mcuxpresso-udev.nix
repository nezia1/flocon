{pkgs, ...}: let
  name = "mcuxpressoide";
  version = "24.12.148";
  description = "MCUXpresso IDE";
  filename = "${name}-${version}.x86_64.deb";

  mcuxpressoUdevRules = pkgs.stdenv.mkDerivation {
    inherit version description;
    name = "${name}-udev";
    src = pkgs.requireFile {
      url = "https://www.nxp.com/design/design-center/software/development-software/mcuxpresso-software-and-tools-/mcuxpresso-integrated-development-environment-ide:MCUXpresso-IDE";
      name = "${filename}.bin";
      sha256 = "34b9163869d9d274ddcc2b2482d51d9aa2bf5f1cf0581b885172d4c107c58ed5";
    };
    nativeBuildInputs = [pkgs.makeWrapper];

    buildCommand = ''
      # Unpack tarball.
      mkdir -p deb
      sh $src --target deb || true
      ar -xv deb/${filename}
      tar xfvz data.tar.gz -C .

      # Unpack LinkServer.
      mkdir -p linkserver
      ls -al deb
      sh deb/LinkServer_24.12.21.x86_64.deb.bin --target deb/linkserver || true
      ar -xv deb/linkserver/LPCScrypt.deb
      tar xfvz data.tar.gz -C linkserver
      ar -xv deb/linkserver/MCU-Link.deb
      tar xfvz data.tar.gz -C linkserver
      ar -xv deb/linkserver/LinkServer_24.12.21.x86_64.deb
      tar xfvz data.tar.gz -C linkserver

      # Install udev rules
      mkdir -p $out/lib/udev/rules.d
      mv ./lib/udev/rules.d/56-pemicro.rules ./lib/udev/rules.d/85-mcuxpresso.rules $out/lib/udev/rules.d/

      # Install LinkServer udev rules
      mv ./linkserver/lib/udev/rules.d/{85-linkserver_24.12.21.rules,85-mcu-link_3.153.rules,99-lpcscrypt.rules} $out/lib/udev/rules.d
    '';
  };
in
  mcuxpressoUdevRules
