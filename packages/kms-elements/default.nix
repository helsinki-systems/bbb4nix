{ stdenv, callPackage, cmake, pkgconfig
, boost, glib, glibmm, libuuid, libsoup, libnice, openssl }: let
  src = callPackage ../sources/kms-elements {};
  gst = callPackage ../kms-gst {};

in stdenv.mkDerivation {
  pname = "kms-elements";
  inherit (src) version;

  inherit src;

  # Copy the jar to the expected location or the build will fail
  postUnpack = ''
    mkdir -p $out/share/java
    ln -s ${callPackage ../kurento-module-creator {}}/share/java/kurento-module-creator-jar-with-dependencies.jar $out/share/java/

    mkdir -p /build/modules
    ln -s ${callPackage ../kms-core {}}/share/kurento/modules/* /build/modules
  '';

  # Add the correct glib and gstreamer include directories
  postPatch = ''
    for dir in server/implementation/HttpServer gst-plugins/{,recorderendpoint,rtcpdemux,rtpendpoint,webrtcendpoint}; do
      echo 'include_directories("${glib.dev}/include/glib-2.0" "${glib.out}/lib/glib-2.0/include")' >> "src/$dir/CMakeLists.txt"
      echo 'include_directories("${gst.gstreamer.dev}/include/gstreamer-1.0", "${gst.gst-plugins-base.dev}/include/gstreamer-1.0", "${gst.gst-plugins-bad.dev}/include/gstreamer-1.0")' >> "src/$dir/CMakeLists.txt"
    done
  '';

  nativeBuildInputs = [ cmake pkgconfig (callPackage ../kurento-module-creator {}) ];
  buildInputs = [
    boost
    glibmm
    libuuid
    libsoup
    libnice
    openssl
    gst.gstreamer
    gst.gst-plugins-base
    gst.gst-plugins-bad
    (callPackage ../kms-core {})
    (callPackage ../kms-jsonrpc {})
    (callPackage ../kmsjsoncpp {})
  ];
  cmakeFlagsArray = (callPackage ../kurento-media-server/lib.nix {}).mkCmakeModules [
    (callPackage ../kms-cmake-utils {})
    (callPackage ../kms-core {})
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
      patchelf --set-rpath "$(patchelf --print-rpath "$file"):${gst.gstreamer.out}/lib:${gst.gst-plugins-base}/lib" "$file"
      patchelf --add-needed libgstapp-1.0.so --add-needed libgstsctp-1.0.so --add-needed libgstrtp-1.0.so "$file"
    done

    # Make file name the same as the module name (wtf?)
    for name in recorderendpoint rtpendpoint webrtcendpoint; do
      mv $out/lib/gstreamer-1.0/lib''${name}.so $out/lib/gstreamer-1.0/libkms''${name}.so
    done
    mv $out/lib/gstreamer-1.0/libkmselementsplugins.so $out/lib/gstreamer-1.0/libkmselements.so
  '';

  meta = with stdenv.lib; {
    description = "Media elements for Kurento Media Server";
    homepage = "https://www.kurento.org";
    license = with licenses; [ asl20 ];
  };
}
