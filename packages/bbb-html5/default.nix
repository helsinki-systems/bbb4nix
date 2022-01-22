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
    cp -R . $out
  '';

  outputHash = "sha256:026zsxl0nrnyapavbypn0a0873ivfhm559s3l6zy1r9jzwkifnd8";
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
}
