# This file originates from SBTix but was modified
# to match our source and repo paths. Also this installs
# the .m2 repository for Gradle usage.
{ callPackage }:
let
  sbtix = callPackage ../x2nix/sbtix.nix {};
  bbbSrc = callPackage ../sources/bigbluebutton {};
in
  sbtix.buildSbtLibrary {
    name = "commonWeb";
    src = "${bbbSrc}/bbb-common-web";
    sbtixBuildInputs = [
      (callPackage ../bbb-common-message {})
    ];
    repo = [
      (import ./repo.nix)
      (import ./project-repo.nix)
      (import ./manual-repo.nix)
    ];

    postPatch = ''
      sed -i 's:@out@:${placeholder "out"}:g' src/main/java/org/bigbluebutton/presentation/imp/PdfPageDownscaler.java
    '';

    postInstall = ''
      sbt publish
      cp -r /build/.m2/repository $out
      cp ${bbbSrc}/bigbluebutton-config/slides/nopdfmark.ps $out
    '';
  }
