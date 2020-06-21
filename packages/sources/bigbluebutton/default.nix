{ stdenvNoCC, callPackage, fetchurl }:

stdenvNoCC.mkDerivation {
  pname = "bigbluebutton-source";
  version = builtins.readFile ./version;

  src = callPackage ./raw-source.nix {};

  patches = [
    # Libraries
    ./bbb-common-jackson-version.patch # Update Jackson to our Scala version
    ./bbb-common-nopdfmark-path.patch # Remove path to pdfmark (WHY BOTHER LOADING IT FROM CLASSPATH???)
    # AKKA
    ./bbb-akka-apps-no-logfile.patch # Only log to stdout
    ./bbb-akka-fsesl-no-logfile.patch # Only log to stdout
    # web
    ./bbb-web-no-logfile.patch # Only log to stdout
    ./bbb-web-grails-upgrade.patch # Upgrade Grails, Gradle, and GORM
    ./bbb-web-flexible-turn.patch # Read TURN/STUN servers from non-default locations
    (fetchurl { # Use external soffice processes
      url = "https://github.com/bigbluebutton/bigbluebutton/commit/d7ab880bccd43074b219096646932e1290e64663.patch";
      name = "office-conversion-improvements.patch";
      sha256 = "sha256-pVj11IKrZDTxQMIN30iTfEMjdm1jbPMXUspEYWSYbC4=";
    })
    ./bbb-web-flexible-soffice.patch # Make the previous patch usable
    (fetchurl { # Load config from a system property
      url = "https://patch-diff.githubusercontent.com/raw/bigbluebutton/bigbluebutton/pull/9842.patch";
      name = "9842.patch";
      sha256 = "sha256-EFEHAvZ/ZzoIJ+68w+jLdsV/MsCAEEfDO8ThCcN/TZo=";
    })
  ];

  installPhase = ''
    cp -r $PWD $out
  '';
}
