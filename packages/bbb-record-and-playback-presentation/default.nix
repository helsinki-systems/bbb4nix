{ stdenvNoCC, callPackage }: let
  src = callPackage ../sources/bigbluebutton {};

in stdenvNoCC.mkDerivation {
  pname = "bbb-record-and-playback-presentations";
  inherit (src) version;

  inherit src;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir $out
    cp -r record-and-playback/presentation/* $out
    rm -r $out/scripts $out/playback/presentation/0.*
  '';
}
