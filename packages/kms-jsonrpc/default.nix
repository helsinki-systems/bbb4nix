{ stdenv, callPackage, cmake, pkg-config, boost }: let
  src = callPackage ../sources/kms-jsonrpc {};

in stdenv.mkDerivation {
  pname = "kms-jsonrpc";
  inherit (src) version;

  inherit src;

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    boost
    (callPackage ../kmsjsoncpp {})
  ];
  cmakeFlagsArray = (callPackage ../kurento-media-server/lib.nix {}).mkCmakeModules [
    (callPackage ../kms-cmake-utils {})
  ];

  meta = with stdenv.lib; {
    description = "JsonRPC protocol implementation";
    homepage = "https://www.kurento.org";
    license = with licenses; [ asl20 ];
  };
}
