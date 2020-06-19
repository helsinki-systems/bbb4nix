{ stdenv, callPackage, cmake }: let
  src = callPackage ../sources/kms-cmake-utils {};

in stdenv.mkDerivation {
  pname = "kms-cmake-utils";
  inherit (src) version;

  inherit src;

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "CMake common files used to build all Kurento C/C++ projects";
    homepage = "https://www.kurento.org";
    license = with licenses; [ asl20 ];
  };
}
