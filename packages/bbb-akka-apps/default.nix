# This file originates from SBTix but was modified
# to match our source and repo paths.
{ callPackage }:
let
  sbtix = callPackage ../x2nix/sbtix.nix {};
in
  sbtix.buildSbtProgram {
    name = "bbbAppsAkka";
    src = (callPackage ../sources/bigbluebutton {}) + "/akka-bbb-apps";
    sbtixBuildInputs = [
      (callPackage ../bbb-common-message {})
      (callPackage ../bbb-fsesl-client {})
    ];
    repo = [
      (import ./repo.nix)
      (import ./project-repo.nix)
      (import ./manual-repo.nix)
    ];
  }
