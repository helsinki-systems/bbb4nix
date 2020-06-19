{ stdenvNoCC, callPackage }:

stdenvNoCC.mkDerivation {
  pname = "kurento-media-server-source";
  version = builtins.readFile ./version;

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  src = callPackage ./raw-source.nix {};

  postPatch = ''
    # Fix gstreamer version
    substituteInPlace CMakeLists.txt --replace 1.5 1.0

    # Add websocketpp
    echo 'find_package(WEBSOCKETPP REQUIRED)' >> server/transport/websocket/CMakeLists.txt

    # Remove built-in websocketpp (not compatible with newer OpenSSL, see bad73ecb26cf4b9791af17209fb2c54d5d25b4d9)
    rm -r server/transport/websocket/websocketpp
  '';

  installPhase = ''
    cp -r $PWD $out
  '';
}
