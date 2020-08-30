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
    sed -i 's:websocketpp 0.7.0:websocketpp:' server/transport/websocket/CMakeLists.txt
  '';

  installPhase = ''
    cp -r $PWD $out
  '';
}
