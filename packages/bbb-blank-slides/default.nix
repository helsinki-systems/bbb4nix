{ stdenvNoCC, callPackage }: let
  src = callPackage ../sources/bigbluebutton {};

in stdenvNoCC.mkDerivation {
  pname = "bbb-blank-slides";
  inherit (src) version;

  inherit src;

  dontConfigure = true;
  dontBuild = true;

  installPhase = ''
    mkdir $out
    cp -r bigbluebutton-config/slides/* $out
    rm $out/*.swf
  '';
}
