{ gst_all_1, callPackage }: gst_all_1 // {
  gst-plugins-bad = gst_all_1.gst-plugins-bad.override {
    srtp = callPackage ../libsrtp-kurento {};
  };
}
