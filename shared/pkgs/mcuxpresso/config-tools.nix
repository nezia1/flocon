{
  eclipses,
  stdenv,
  requireFile,
  ...
}: let
  name = "mcuxpressotools";
  version = "v16-1";
  description = "MCUXpresso Config Tools";
  filename = "mcuxpresso-config-tools-${version}_amd64.deb";

  src = stdenv.mkDerivation {
    inherit version description;
    name = "${name}-src";
    src = requireFile {
      url = "https://www.nxp.com/design/software/development-software/mcuxpresso-config-tools-pins-clocks-and-peripherals:MCUXpresso-Config-Tools";
      name = "${filename}.bin";
      sha256 = "sha256-BbEwxm1urV2IrgUiTiMBEAPvonQGwdL4fpqFftGgRxI=";
    };

    buildCommand = ''
      # Unpack tarball.
      mkdir -p deb
      sh $src --target deb || true
      ar -xv deb/${filename}
      tar xfvz data.tar.gz -C .

      mkdir -p ./final/eclipse
      mv ./opt/nxp/MCUX_CFG_v13/bin/.* final/eclipse
      mv ./usr final/
      mv final/eclipse/tools final/eclipse/eclipse
      mv final/eclipse/tools.ini final/eclipse/eclipse.ini

      # Create custom .eclipseproduct file
      echo "name=${name}
      id=com.nxp.${name}
      version=${version}
      " > final/eclipse/.eclipseproduct

      # Additional files
      mkdir -p final/usr/share/mime
      mv ./opt/nxp/MCUX_CFG_v13/mcu_data final/mcu_data

      cd ./final
      tar -czf $out ./
    '';
  };
in
  eclipses.buildEclipse {inherit description name src;}
