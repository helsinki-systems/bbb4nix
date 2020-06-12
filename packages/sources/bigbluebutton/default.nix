{ stdenvNoCC, callPackage, grails }:

stdenvNoCC.mkDerivation {
  pname = "bigbluebutton-source";
  version = with builtins; replaceStrings [ "\n" ] [ "" ] (readFile ./version);

  src = callPackage ./raw-source.nix {};

  patches = [
    # AKKA
    ./bbb-akka-apps-no-logfile.patch # Only log to stdout
    ./bbb-akka-fsesl-no-logfile.patch # Only log to stdout
  ];

  installPhase = ''
    cp -r $PWD $out
  '';
}
