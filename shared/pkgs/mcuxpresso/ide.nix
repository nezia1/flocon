{
  pkgs,
  onlyUdevRules ? false,
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
    buildCommand = ''
      # Unpack tarball.
      mkdir -p deb
      sh $src --target deb || true
      ar -xv deb/${filename}
      tar xfvz data.tar.gz -C .
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
    ];

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
      mkdir -p $out/lib/udev/rules.d

      if [ ${toString onlyUdevRules} = "true" ]; then
        # only copy udev rules
        cp ${mcuxpressoide}/lib/udev/rules.d/85-mcuxpresso.rules ${mcuxpressoide}/lib/udev/rules.d/56-pemicro.rules $out/lib/udev/rules.d/
      else
        # copy full installation
        mkdir -p $out/bin $out/eclipse $out/mcu_data
        cp ${mcuxpressoide}/lib/udev/rules.d/85-mcuxpresso.rules ${mcuxpressoide}/lib/udev/rules.d/56-pemicro.rules $out/lib/udev/rules.d/
        cp -r ${mcuxpressoide}/eclipse $out/eclipse
        cp -r ${mcuxpressoide}/mcu_data $out/mcu_data
        ln -s ${mcuxpressoFhsEnv}/bin/mcuxpresso-env $out/bin/mcuxpresso
      fi

      runHook postInstall
    '';
  }
