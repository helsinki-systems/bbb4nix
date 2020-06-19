{ stdenvNoCC, callPackage }:

stdenvNoCC.mkDerivation rec {
  pname = "libsrtp-kurento-source";
  version = builtins.readFile ./version;

  dontConfigure = true;
  dontBuild = true;
  dontFixup = true;

  src = callPackage ./raw-source.nix {};

  patches = [
    # Allow receiving packets that are replayed
    "${src}/debian/patches/0009-Always-allow-receiving-repeated-packets-rx-replay.patch"
    # Allow sending packets that are replayed (this way we don't have to patch gst as well)
    ./tx-replay.patch
  ];

  installPhase = ''
    cp -r $PWD $out
  '';
}
