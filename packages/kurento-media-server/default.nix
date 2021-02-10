{ stdenv, lib, callPackage, makeWrapper, cmake, pkg-config
, boost, glibmm, libsigcxx, libevent, openssl, websocketpp }: let
  src = callPackage ../sources/kurento-media-server {};
  gst = callPackage ../kms-gst {};

in stdenv.mkDerivation {
  pname = "kurento-media-server";
  inherit (src) version;

  inherit src;

  nativeBuildInputs = [ cmake pkg-config makeWrapper ];
  buildInputs = [
    boost
    glibmm
    libsigcxx
    libevent
    openssl
    websocketpp
    gst.gstreamer
    gst.gst-plugins-base
    (callPackage ../kms-core {})
    (callPackage ../kms-jsonrpc {})
    (callPackage ../kmsjsoncpp {})
  ];
  cmakeFlagsArray = (callPackage ../kurento-media-server/lib.nix {}).mkCmakeModules [
    (callPackage ../kms-cmake-utils {})
    (callPackage ../kms-core {})
    (callPackage ../kms-jsonrpc {})
    websocketpp
  ];

  meta = with lib; {
    description = "Media Server responsible for media transmission, processing, loading and recording";
    homepage = "https://www.kurento.org";
    license = with licenses; [ asl20 ];
  };
}
