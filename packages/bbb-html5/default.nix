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
    sed -i 's:YAML_FILE_PATH = .*;$:YAML_FILE_PATH = "/run/bbb-html5/settings.json";:' app/app.js
    popd
  '';

  installPhase = ''
    cp -R . $out
  '';

  outputHash = "sha256:0p275ha6yqx7i2m154i6k0ngsld35pl1wd6njlhk4qmn0fanv2sd";
  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
}
