{ stdenv, callPackage, cmake, pkg-config
, boost, glib, glibmm, libsigcxx, libsoup, opencv3 }: let
  src = callPackage ../sources/kms-filters {};
  gst = callPackage ../kms-gst {};

in stdenv.mkDerivation {
  pname = "kms-filters";
  inherit (src) version;

  inherit src;

  # Copy the jar to the expected location or the build will fail
  postUnpack = ''
    mkdir -p $out/share/java
    ln -s ${callPackage ../kurento-module-creator {}}/share/java/kurento-module-creator-jar-with-dependencies.jar $out/share/java/

    mkdir -p /build/modules
    ln -s ${callPackage ../kms-core {}}/share/kurento/modules/* /build/modules
    ln -s ${callPackage ../kms-elements {}}/share/kurento/modules/* /build/modules
  '';

  # Add the correct glib and gstreamer include directories
  postPatch = ''
    for dir in gst-plugins/{facedetector,faceoverlay,imageoverlay,logooverlay,movementdetector}; do
      echo 'include_directories("${glib.dev}/include/glib-2.0" "${glib.out}/lib/glib-2.0/include")' >> "src/$dir/CMakeLists.txt"
      echo 'include_directories("${gst.gstreamer.dev}/include/gstreamer-1.0" "${gst.gst-plugins-base.dev}/include/gstreamer-1.0")' >> "src/$dir/CMakeLists.txt"
    done
  '';

  nativeBuildInputs = [ cmake pkg-config (callPackage ../kurento-module-creator {}) ];
  buildInputs = [
    boost
    glibmm
    libsigcxx
    libsoup
    opencv3
    gst.gstreamer
    gst.gst-plugins-base
    (callPackage ../kms-core {})
    (callPackage ../kms-elements {})
    (callPackage ../kms-jsonrpc {})
    (callPackage ../kmsjsoncpp {})
  ];
  cmakeFlagsArray = (callPackage ../kurento-media-server/lib.nix {}).mkCmakeModules [
    (callPackage ../kms-cmake-utils {})
    (callPackage ../kms-core {})
    (callPackage ../kms-elements {})
    (callPackage ../kurento-module-creator {})
    (callPackage ../kms-jsonrpc {})
    (callPackage ../kmsjsoncpp {})
  ];

  # To find plugins missing their dependencies, run:
  # $ nix-shell -p kurentoPackages.kms-core -p gst_all_1.gstreamer
  # $ GST_REGISTRY= GST_PLUGIN_PATH=$(echo "$buildInputs" | cut -d' ' -f1)/lib/gstreamer-1.0 gst-inspect-1.0 -b
  postFixup = ''
    # Add gst to dependencies
    for file in $(find $out/lib -name '*.so'); do
      patchelf --set-rpath "$(patchelf --print-rpath "$file"):${gst.gst-plugins-base}/lib" "$file"
      patchelf --add-needed libgstvideo-1.0.so "$file"
    done

    # Make file name the same as the module name (wtf?)
    for name in logooverlay opencvfilter movementdetector imageoverlay faceoverlay facedetector; do
      mv $out/lib/gstreamer-1.0/lib''${name}.so $out/lib/gstreamer-1.0/libkms''${name}.so
    done
  '';

  meta = with stdenv.lib; {
    description = "Filter elements for Kurento Media Server";
    homepage = "https://www.kurento.org";
    license = with licenses; [ asl20 ];
  };
}
