{ stdenv, callPackage, cmake }: let
  src = callPackage ../sources/kmsjsoncpp {};

in stdenv.mkDerivation {
  pname = "kmsjsoncpp";
  inherit (src) version;

  inherit src;

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "A C++ library for interacting with JSON - Kurento fork";
    homepage = "https://github.com/Kurento/jsoncpp";
    license = with licenses; [ mit ];
  };
}
