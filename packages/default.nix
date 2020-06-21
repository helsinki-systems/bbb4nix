{ callPackage }: {
  bbbPackages = {
    akkaApps = callPackage ./bbb-akka-apps {};
    akkaFsesl = callPackage ./bbb-akka-fsesl {};
    web = callPackage ./bbb-web {};
    blankSlides = callPackage ./bbb-blank-slides {};
  };

  kurentoPackages = {
    kurento-media-server = callPackage ./kurento-media-server {};
    kms-core = callPackage ./kms-core {};
    kms-elements = callPackage ./kms-elements {};
    kms-filters = callPackage ./kms-filters {};
    gst_all_1 = callPackage ./kms-gst {};
  };
}
