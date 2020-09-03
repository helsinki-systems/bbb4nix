{ callPackage }: {
  bbbPackages = {
    akkaApps = callPackage ./bbb-akka-apps {};
    akkaFsesl = callPackage ./bbb-akka-fsesl {};
    web = callPackage ./bbb-web {};
    blankSlides = callPackage ./bbb-blank-slides {};
    freeswitchConfig = callPackage ./bbb-freeswitch-config {};
    webrtcSfu = callPackage ./bbb-webrtc-sfu {};
    greenlight = callPackage ./bbb-greenlight {};
    etherpad-lite = callPackage ./bbb-etherpad-lite {};
    html5 = callPackage ./bbb-html5/wrapper.nix {};
    html5-unwrapped = callPackage ./bbb-html5 {};
    recordAndPlaybackPresentation = callPackage ./bbb-record-and-playback-presentation {};
  };

  kurentoPackages = {
    kurento-media-server = callPackage ./kurento-media-server {};
    kms-core = callPackage ./kms-core {};
    kms-elements = callPackage ./kms-elements {};
    kms-filters = callPackage ./kms-filters {};
    gst_all_1 = callPackage ./kms-gst {};
  };

  freeswitchPackages = rec {
    spandsp = callPackage ./spandsp {};
  };
}
