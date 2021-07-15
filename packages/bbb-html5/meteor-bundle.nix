{ stdenv, callPackage }: let
  meteor = callPackage ../sources/meteor {};
  src = callPackage ../sources/bigbluebutton {};
in stdenv.mkDerivation {
  inherit (src) version;
  pname = "bbb-html5-meteor-bundle";
  src = "${src}/bigbluebutton-html5";

  nativeBuildInputs = [ meteor ];

  configurePhase = ''
    export HOME=$PWD/../home
    meteor update --packages-only
  '';

  buildPhase = ''
    meteor npm install
    meteor build --server-only --directory ../bundle
  '';

  installPhase = ''
    mkdir -p $out
    find ../bundle -name '.resolve-garbage-*' -exec rm -rf {} +
    cp -R ../bundle/bundle/. $out/
  '';

  outputHashMode = "recursive";
  outputHash = "sha256:1fhdk7dcsvwf1w5dmb77qzjpvzrqc6775yn6dnkr66kpvmigayl7";
}
