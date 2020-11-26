{ stdenv, callPackage, makeWrapper, nodePackages_12_x
, python2, util-linux, runCommand, writeTextFile, nodejs-12_x, darwin
, fetchurl, fetchgit }:
let
  src = callPackage ../sources/bbb-webrtc-sfu {};

  nodeEnv = import ../x2nix/node-env.nix {
    inherit stdenv python2 util-linux runCommand writeTextFile;
    nodejs = nodejs-12_x;
    libtool = if stdenv.isDarwin then darwin.cctools else null;
  };

  nodePackages = import ./node-packages.nix {
    inherit nodeEnv fetchurl fetchgit;
    globalBuildInputs = [ nodePackages_12_x.node-gyp-build ];
  };
in nodeEnv.buildNodePackage (nodePackages.args // {
  inherit src;

  nativeBuildInputs = [ makeWrapper ];
  postInstall = ''
    mkdir -p $out/bin

    makeWrapper ${nodejs-12_x}/bin/node $out/bin/bbb-webrtc-sfu \
      --run 'cd ${placeholder "out"}/lib/node_modules/bbb-webrtc-sfu' \
      --add-flags ./server.js
  '';
})
