{ stdenv, fetchFromGitHub, glib, openssl, pkgconfig, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "sofia-sip";
  version = "1.13";

  src = fetchFromGitHub {
    owner = "freeswitch";
    repo = pname;
    rev = "f6f29b483e9c31ce8d3e87419ec3deea8679312d"; # upstream does not seem to believe in tags
    sha256 = "sha256-KD3sPrf9GjA357jomFL8LtZ3rp25v3Vy8QfSZNSozso=";
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
