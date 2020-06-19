{ stdenvNoCC, callPackage }:

stdenvNoCC.mkDerivation {
  pname = "kms-elements-source";
  version = builtins.readFile ./version;

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  src = callPackage ./raw-source.nix {};

  postPatch = ''
    # Fix gstreamer version
    substituteInPlace CMakeLists.txt --replace 1.5 1.0
  '';

  installPhase = ''
    cp -r $PWD $out
  '';
}
