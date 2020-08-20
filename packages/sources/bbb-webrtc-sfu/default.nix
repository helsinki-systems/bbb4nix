{ stdenvNoCC, callPackage }:

stdenvNoCC.mkDerivation {
  pname = "bbb-webrtc-sfu";
  version = builtins.readFile ./version;

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  src = callPackage ./raw-source.nix {};

  installPhase = ''
    cp -r $PWD $out
  '';
}
