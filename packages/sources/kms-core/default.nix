{ stdenvNoCC, callPackage }:

stdenvNoCC.mkDerivation {
  pname = "kms-core-source";
  version = with builtins; replaceStrings [ "\n" ] [ "" ] (readFile ./version);

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  src = callPackage ./raw-source.nix {};

  postPatch = ''
    # Fix gstreamer version
    substituteInPlace CMakeLists.txt --replace 1.5 1.0
    substituteInPlace src/gst-plugins/CMakeLists.txt --replace 1.5 1.0
    substituteInPlace src/gst-plugins/commons/CMakeLists.txt --replace 1.5 1.0
    substituteInPlace src/server/CMakeLists.txt --replace 1.5 1.0

    # Fix building modules
    substituteInPlace CMake/CodeGenerator.cmake --replace /usr/share/kurento/modules /build/modules
  '';

  installPhase = ''
    cp -r $PWD $out
  '';
}
