# This file originates from SBTix but was modified
# to match our source and repo paths.
{ callPackage }:
let
  sbtix = callPackage ../x2nix/sbtix.nix {};
in
  sbtix.buildSbtLibrary {
    name = "bbbFSESLClient";
    src = (callPackage ../sources/bigbluebutton {}) + "/bbb-fsesl-client";
    repo = [
      (import ./repo.nix)
      (import ./project-repo.nix)
      (import ./manual-repo.nix)
    ];
  }
