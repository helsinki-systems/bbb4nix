{ stdenvNoCC, callPackage, cmake, jdk }: let
  mavenix = callPackage (callPackage ../sources/mavenix {}) {};
  src = callPackage ../sources/kurento-module-creator {};

  cmakeVersion = "cmake-" + stdenvNoCC.lib.versions.majorMinor cmake.version;

in mavenix.buildMaven {
  pname = "kurento-module-creator";
  inherit (src) version;

  inherit src;
  infoFile = ./mavenix.lock;

  postInstall = ''
    # Add a wrapper
    mkdir -p $out/bin
    echo '#!/bin/sh
    ${jdk}/bin/java -jar $out/share/java/kurento-module-creator-jar-with-dependencies.jar "$@"' > $out/bin/kurento-module-creator
    chmod +x $out/bin/kurento-module-creator

    # Move the cmake module
    mkdir -p $out/share/${cmakeVersion}/Modules
    mv target/classes/FindKurentoModuleCreator.cmake $out/share/${cmakeVersion}/Modules
  '';

  meta = with stdenvNoCC.lib; {
    description = "Code auto-generation tool for Kurento Media Server modules";
    homepage = "https://www.kurento.org";
    license = with licenses; [ asl20 ];
  };
}
