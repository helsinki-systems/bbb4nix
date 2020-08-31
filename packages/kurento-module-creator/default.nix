{ stdenvNoCC, callPackage, cmake, jdk, maven, makeWrapper }: let
  mvn2nix = import (callPackage ../sources/mvn2nix {}) {};
  mavenRepository = mvn2nix.buildMavenRepositoryFromLockFile { file = ./dependencies.nix; };

  src = callPackage ../sources/kurento-module-creator {};

  cmakeVersion = "cmake-" + stdenvNoCC.lib.versions.majorMinor cmake.version;
in stdenvNoCC.mkDerivation rec {
  pname = "kurento-module-creator";
  inherit (src) version;

  inherit src;

  buildInputs = [ jdk maven makeWrapper ];
  buildPhase = ''
    echo "Building with maven repository ${mavenRepository}"
    mvn package --offline -Dmaven.repo.local=${mavenRepository}
  '';

  installPhase = ''
    # create the bin directory
    mkdir -p $out/bin

    # copy out the JAR
    # Maven already setup the classpath to use m2 repository layout
    # with the prefix of lib/
    cp target/${pname}-jar-with-dependencies.jar $out/${pname}.jar

    # create a wrapper that will automatically set the classpath
    # this should be the paths from the dependency derivation
    makeWrapper ${jdk}/bin/java $out/bin/${pname} \
          --add-flags "-jar $out/${pname}.jar"

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
