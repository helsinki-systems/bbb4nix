{ stdenv, lib, callPackage, makeWrapper, nodePackages, nix-gitignore
, python, util-linux, runCommand, writeTextFile, nodejs, darwin
, fetchurl, fetchgit }:
let
  src = callPackage ../sources/bbb-webrtc-sfu {};

  nodeEnv = import ../x2nix/node-env.nix {
    inherit stdenv lib nodejs python util-linux runCommand writeTextFile;
    libtool = if stdenv.isDarwin then darwin.cctools else null;
  };

  _nodePackages = import ./node-packages.nix {
    inherit stdenv lib nodeEnv fetchurl fetchgit nix-gitignore;
    globalBuildInputs = with nodePackages; [ node-gyp-build ];
  };
in nodeEnv.buildNodePackage (_nodePackages.args // {
  inherit src;

  nativeBuildInputs = [ makeWrapper ];
  postInstall = ''
    mkdir -p $out/bin

    makeWrapper ${nodejs}/bin/node $out/bin/bbb-webrtc-sfu \
      --run 'cd ${placeholder "out"}/lib/node_modules/bbb-webrtc-sfu' \
      --add-flags ./server.js
  '';
})
