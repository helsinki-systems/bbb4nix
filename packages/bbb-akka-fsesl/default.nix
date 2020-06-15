# This file originates from SBTix but was modified
# to match our source and repo paths.
{ callPackage }:
let
  sbtix = callPackage ../x2nix/sbtix.nix {};
in
  sbtix.buildSbtProgram {
    name = "bbbFseslAkka";
    src = (callPackage ../sources/bigbluebutton {}) + "/akka-bbb-fsesl";
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
