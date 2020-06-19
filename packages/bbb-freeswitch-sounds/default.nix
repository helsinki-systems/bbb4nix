{ stdenvNoCC, callPackage }: let
  src = callPackage ../sources/bbb-freeswitch-sounds {};

in stdenvNoCC.mkDerivation {
  pname = "bbb-freeswitch-sounds";
  inherit (src) version;

  inherit src;

  installPhase = ''
    cp -r opt/freeswitch/share/freeswitch/sounds $out
  '';
}
