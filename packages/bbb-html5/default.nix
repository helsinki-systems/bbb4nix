{ stdenv, callPackage, makeWrapper, python2 }: let
  meteor = callPackage ../sources/meteor {};
  src = callPackage ./meteor-bundle.nix {};
in stdenv.mkDerivation { # this is *not* stdenvNoCC, because of fibers and stuff
  pname = "bbb-html5";
  inherit (src) version;
  inherit src;

  nativeBuildInputs = [ meteor python2 makeWrapper ];

  buildPhase = ''
    export HOME=$PWD/../home
    pushd programs/server
    meteor npm install
    popd
  '';

  installPhase = ''
    mkdir -p $out/bin
    cp -R . $out
  '';

  outputHash = "sha256-8pcVqDwrb8zxhSdHgMyk+Nl2JU0/4i3g9d6wpVQ1d4c=";
  outputHashMode = "recursive";
}
