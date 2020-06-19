{ stdenvNoCC, callPackage, dpkg }:

stdenvNoCC.mkDerivation {
  pname = "bbb-freeswitch-sounds-source";
  version = builtins.readFile ./version;

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  src = callPackage ./raw-source.nix {};

  nativeBuildInputs = [ dpkg ];

  unpackPhase = ''
    mkdir source
    dpkg-deb -x "$src" source
  '';
  sourceRoot = "source";

  installPhase = ''
    cp -r $PWD $out
  '';
}
