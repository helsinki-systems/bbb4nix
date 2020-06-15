# This file originates from SBTix but was modified
# to match our source and repo paths. Also this installs
# the .m2 repository for Gradle usage.
{ callPackage }:
let
  sbtix = callPackage ../x2nix/sbtix.nix {};
in
  sbtix.buildSbtLibrary {
    name = "commonMessage";
    src = (callPackage ../sources/bigbluebutton {}) + "/bbb-common-message";
    repo = [
      (import ./repo.nix)
      (import ./project-repo.nix)
      (import ./manual-repo.nix)
    ];

    postInstall = ''
      sbt publish
      cp -r /build/.m2/repository $out
    '';
  }
