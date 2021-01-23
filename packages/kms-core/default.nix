{ gcc9Stdenv, lib, callPackage, cmake, pkg-config
, boost, glib, glibmm, libsigcxx, libuuid, libvpx }: let
  src = callPackage ../sources/kms-core {};
  gst = callPackage ../kms-gst {};

in gcc9Stdenv.mkDerivation {
  pname = "kms-core";
  inherit (src) version;

  inherit src;

  # Copy the jar to the expected location or the build will fail
  postUnpack = ''
    mkdir -p $out/share/java
    ln -s ${callPackage ../kurento-module-creator {}}/share/java/kurento-module-creator-jar-with-dependencies.jar $out/share/java/
  '';

  # Add the correct glib and gstreamer include directories
  postPatch = ''
    for f in gst-plugins/vp8parse gst-plugins/commons/sdpagent; do
      echo 'include_directories("${glib.dev}/include/glib-2.0" "${glib.out}/lib/glib-2.0/include")' >> "src/$f/CMakeLists.txt"
      echo 'include_directories("${gst.gstreamer.dev}/include/gstreamer-1.0" "${gst.gst-plugins-base.dev}/include/gstreamer-1.0")' >> "src/$f/CMakeLists.txt"
    done
  '';

  nativeBuildInputs = [ cmake pkg-config ];
  buildInputs = [
    boost
    libsigcxx
    glibmm
    libuuid
    libvpx
    gst.gstreamer
    gst.gst-plugins-base
    (callPackage ../kurento-module-creator {})
    (callPackage ../kms-jsonrpc {})
    (callPackage ../kmsjsoncpp {})
  ];
  cmakeFlagsArray = (callPackage ../kurento-media-server/lib.nix {}).mkCmakeModules [
    (callPackage ../kms-cmake-utils {})
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
      patchelf --add-needed libgstbase-1.0.so --add-needed libgstvideo-1.0.so "$file"
    done

    # Make file name the same as the module name (wtf?)
    mv $out/lib/gstreamer-1.0/libkmscoreplugins.so $out/lib/gstreamer-1.0/libkmscore.so
  '';

  meta = with lib; {
    description = "Core library of Kurento Media Server";
    homepage = "https://www.kurento.org";
    license = with licenses; [ asl20 ];
  };
}
