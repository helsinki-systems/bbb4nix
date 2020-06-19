{ stdenv, callPackage, cmake }: let
  src = callPackage ../sources/libsrtp-kurento {};

in stdenv.mkDerivation {
  pname = "libsrtp-kurento";
  inherit (src) version;

  inherit src;

  meta = with stdenv.lib; {
    description = "Library for SRTP (Secure Realtime Transport Protocol) - Kurento fork";
    homepage = "https://github.com/kurento/libsrtp";
    license = with licenses; [ bsd3 ];
  };
}
