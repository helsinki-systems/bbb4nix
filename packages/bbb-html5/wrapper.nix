{ stdenvNoCC, makeWrapper, callPackage }: let
  meteor = callPackage ../sources/meteor {};
  src = callPackage ./. {};
in stdenvNoCC.mkDerivation {
  pname = "bbb-html5-wrapper";
  inherit (src) version;
  inherit src;
  nativeBuildInputs = [ makeWrapper ];

  installPhase = ''
    mkdir -p $out/bin
    makeWrapper ${meteor}/dev_bundle/bin/node $out/bin/bbb-html5 \
      --run "cd ${src}" \
      --add-flags main.js \
      --set-default ROOT_URL http://127.0.0.1/html5client \
      --set-default MONGO_URL mongodb://127.0.1.1/meteor \
      --set-default PORT 3000
  '';
}
