{
  requireFile,
  stdenv,
  dpkg,
  buildFHSEnv,
  ...
}: let
  name = "mcuxpressoide";
  version = "24.12.148";
  description = "MCUXpresso IDE";
  filename = "${name}-${version}.x86_64.deb";

  mcuxpresso = stdenv.mkDerivation {
    inherit name version description;
    src = requireFile {
      url = "https://www.nxp.com/design/design-center/software/development-software/mcuxpresso-software-and-tools-/mcuxpresso-integrated-development-environment-ide:MCUXpresso-IDE";
      name = "${filename}.bin";
      sha256 = "34b9163869d9d274ddcc2b2482d51d9aa2bf5f1cf0581b885172d4c107c58ed5";
    };

    nativeBuildInputs = [dpkg];

    dontBuild = true;
    sourceRoot = "src";

    outputs = ["out" "lib"];
    unpackPhase = ''
      # unpack tarball.
      mkdir -p deb src
      sh $src --target deb --noexec
      dpkg-deb -xv deb/${filename} src
      dpkg-deb -xv deb/JLink_Linux_x86_64.deb src

      mkdir -p linkserver
      sh deb/LinkServer_24.12.21.x86_64.deb.bin --target deb/linkserver --noexec
      dpkg-deb -xv deb/linkserver/LPCScrypt.deb src
      dpkg-deb -xv deb/linkserver/MCU-Link.deb src
      dpkg-deb -xv deb/linkserver/LinkServer_24.12.21.x86_64.deb src
    '';

    installPhase = ''
      mkdir -p $out $lib
      cp -r etc opt usr $out
      cp -r lib $lib
      ln -s $out/usr/local/LinkServer_24.12.21 $out/usr/local/LinkServer
    '';
  };
in
  mcuxpresso
