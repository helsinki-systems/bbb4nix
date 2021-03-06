{ stdenv, lib, fetchFromGitHub, glib, openssl, pkg-config, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "sofia-sip";
  version = "1.13.3";

  src = fetchFromGitHub {
    owner = "freeswitch";
    repo = pname;
    rev = "v${version}";
    sha256 = "1ar961rrwkl6yr50anm3gd9j2w1q0bghq0wxdj4p211zpaj1kj58";
  };

  buildInputs = [ glib openssl ];
  nativeBuildInputs = [ autoreconfHook pkg-config ];

  meta = with lib; {
    description = "Open-source SIP User-Agent library, compliant with the IETF RFC3261 specification";
    homepage = "https://github.com/freeswitch/sofia-sip";
    platforms = platforms.linux;
    license = licenses.lgpl2;
  };
}
