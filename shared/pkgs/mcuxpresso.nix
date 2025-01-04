{
  lib,
  pkgs,
  ...
}: let
  name = "mcuxpressoide";
  version = "24.9.25";
  description = "MCUXpresso IDE";
  filename = "${name}-${version}.x86_64.deb";
  mcuxpressoideSrc = pkgs.stdenv.mkDerivation {
    inherit version description;
    name = "${name}-src";
    src = pkgs.requireFile {
      url = "https://www.nxp.com/design/design-center/software/development-software/mcuxpresso-software-and-tools-/mcuxpresso-integrated-development-environment-ide:MCUXpresso-IDE";
      name = "${filename}.bin";
      hash = "sha256-e3g7rzZQ1WFLcUakkjaufpHMtw3qkw5lwxJuCKs6L+k=";
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
      sh deb/LinkServer_24.9.75.x86_64.deb.bin --target deb/linkserver || true
      ar -xv deb/linkserver/LPCScrypt.deb
      tar xfvz data.tar.gz -C linkserver
      ar -xv deb/linkserver/MCU-Link.deb
      tar xfvz data.tar.gz -C linkserver
      ar -xv deb/linkserver/LinkServer_24.9.75.x86_64.deb
      tar xfvz data.tar.gz -C linkserver

      mkdir -p ./final/eclipse
      mv ./usr/local/${name}-${version}/ide/* ./usr/local/${name}-${version}/ide/.* final/eclipse
      mv final/eclipse/mcuxpressoide final/eclipse/eclipse
      mv final/eclipse/mcuxpressoide.ini final/eclipse/eclipse.ini

      # Create custom .eclipseproduct file
      rm final/eclipse/.eclipseproduct
      echo "name=${name}
      id=com.nxp.${name}
      version=${version}
      " > final/eclipse/.eclipseproduct
      # Install udev rules
      mkdir -p final/lib/udev/rules.d
      mv ./lib/udev/rules.d/56-pemicro.rules ./lib/udev/rules.d/85-mcuxpresso.rules final/lib/udev/rules.d/

      # Additional files
      mv ./usr/local/${name}-${version}/mcu_data final/mcu_data

      # Place LinkServer, lpcscrypt, and MCU-LINK_installer in /usr/local
      mkdir -p ./final/usr/local
      mv ./linkserver/usr/local/LinkServer_24.9.75 ./final/usr/local
      mv ./linkserver/usr/local/lpcscrypt-2.1.3_83 ./final/usr/local
      mv ./linkserver/usr/local/MCU-LINK_installer_3.148 ./final/usr/local

      # Install LinkServer udev rules
      mv ./linkserver/lib/udev/rules.d/{85-linkserver_24.9.75.rules,85-mcu-link_3.148.rules,99-lpcscrypt.rules} final/lib/udev/rules.d

      cd ./final

      tar -czf $out ./
    '';
  };
  mcuxpressoide = pkgs.eclipses.buildEclipse {
    name = "mcuxpresso-eclipse";
    inherit description;
    src = mcuxpressoideSrc;
  };

  # needed because of the integrated toolchain
  mcuxpressoFhsEnv = pkgs.buildFHSEnv {
    name = "mcuxpresso-env";
    targetPkgs = pkgs: [
      pkgs.dfu-util
      pkgs.stdenv.cc.cc.lib
      pkgs.gcc
      pkgs.libgcc
      pkgs.xorg.libXext
      pkgs.xorg.libX11
      pkgs.xorg.libXrender
      pkgs.xorg.libXtst
      pkgs.xorg.libXi
      pkgs.freetype
      pkgs.alsa-lib
      pkgs.ncurses
      pkgs.ncurses5
      pkgs.libusb1
      pkgs.readline
      pkgs.libffi
      pkgs.zlib
      pkgs.tcl
      pkgs.libxcrypt
      pkgs.libxcrypt-legacy
      pkgs.libusb-compat-0_1
      pkgs.xorg.libxcb
      pkgs.python3
      pkgs.usbutils
      pkgs.libuuid
      pkgs.libudev-zero
    ];
    profile = ''
      export LD_LIBRARY_PATH=${lib.makeLibraryPath [pkgs.ncurses5 pkgs.ncurses]}:$LD_LIBRARY_PATH
    '';

    extraBuildCommands = ''
      # Ensure necessary directories exist
      mkdir -p $out/usr/local/LinkServer_24.9.75/lpcscrypt $out/usr/local/LinkServer_24.9.75/MCU-LINK_installer

      cp -r ${mcuxpressoide}/usr/local/LinkServer_24.9.75/* $out/usr/local/LinkServer_24.9.75
      cp -r ${mcuxpressoide}/usr/local/lpcscrypt-2.1.3_83/* $out/usr/local/LinkServer_24.9.75/lpcscrypt
      cp -r ${mcuxpressoide}/usr/local/MCU-LINK_installer_3.148/* $out/usr/local/LinkServer_24.9.75/MCU-LINK_installer
    '';
    runScript = "${mcuxpressoide}/bin/eclipse";
  };
in
  pkgs.stdenv.mkDerivation {
    inherit name version description;
    dontUnpack = true;
    dontConfigure = true;
    dontBuild = true;
    nativeBuildInputs = [pkgs.copyDesktopItems];
    desktopItems = [
      (pkgs.makeDesktopItem {
        inherit name;
        type = "Application";
        desktopName = "MCUXpresso IDE";
        exec = "mcuxpresso";
      })
    ];

    installPhase = ''
       runHook preInstall

       # Create necessary directories
       mkdir -p $out/lib/udev/rules.d
       mkdir -p $out/bin $out/eclipse $out/mcu_data

       # Copy udev rules
       cp ${mcuxpressoide}/lib/udev/rules.d/85-mcuxpresso.rules ${mcuxpressoide}/lib/udev/rules.d/56-pemicro.rules $out/lib/udev/rules.d/

       # Copy full installation
       cp -r ${mcuxpressoide}/eclipse $out/eclipse
       cp -r ${mcuxpressoide}/mcu_data $out/mcu_data

       # Create symlink for the environment
       ln -s ${mcuxpressoFhsEnv}/bin/mcuxpresso-env $out/bin/mcuxpresso

      runHook postInstall
    '';
  }
