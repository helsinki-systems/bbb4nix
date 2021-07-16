{ stdenvNoCC, callPackage, fetchurl }:

stdenvNoCC.mkDerivation {
  pname = "bigbluebutton-source";
  version = builtins.readFile ./version;

  src = callPackage ./raw-source.nix {};

  patches = [
    # Libraries
    ./bbb-common-jackson-version.patch # Update Jackson to our Scala version
    ./bbb-common-nopdfmark-path.patch # Remove path to pdfmark (WHY BOTHER LOADING IT FROM CLASSPATH???)
    ./bbb-common-web-no-bin-sh.patch # just execute the conversion script, don't /bin/sh -c it
    # AKKA
    ./bbb-akka-apps-no-logfile.patch # Only log to stdout
    ./bbb-akka-fsesl-no-logfile.patch # Only log to stdout
    # web
    ./bbb-web-no-logfile.patch # Only log to stdout
    ./bbb-web-grails-upgrade.patch # Upgrade Grails, Gradle, and GORM
    ./bbb-web-flexible-turn.patch # Read TURN/STUN servers from non-default locations
    ./bbb-web-in-memory-db.patch # Switch the h2 database to a in-memory database
    ./bbb-web-config-from-property.patch # Load config from a system property
  ];

  installPhase = ''
    cp -r $PWD $out
  '';
}
