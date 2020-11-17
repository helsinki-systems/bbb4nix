{ stdenv, fetchFromGitHub, glib, openssl, pkgconfig, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "sofia-sip";
  version = "1.13.2";

  src = fetchFromGitHub {
    owner = "freeswitch";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-1r/lFeZxIO/MxynPrwb+ewvC8zB24vmiOVGGCiEYsgc=";
  };

  buildInputs = [ glib openssl ];
  nativeBuildInputs = [ autoreconfHook pkgconfig ];

  meta = with stdenv.lib; {
    description = "Open-source SIP User-Agent library, compliant with the IETF RFC3261 specification";
    homepage = "https://github.com/freeswitch/sofia-sip";
    platforms = platforms.linux;
    license = licenses.lgpl2;
  };
}