{ callPackage, libopusenc }: {
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
    recordAndPlaybackScripts = callPackage ./bbb-record-and-playback-scripts {};
    recordAndPlaybackScriptsRuby = (callPackage ./bbb-record-and-playback-scripts/env.nix {}).wrappedRuby;
    generateSecrets = callPackage ./bbb-generate-secrets {};
  };

  kurentoPackages = {
    kurento-media-server = callPackage ./kurento-media-server {};
    kms-core = callPackage ./kms-core {};
    kms-elements = callPackage ./kms-elements {};
    kms-filters = callPackage ./kms-filters {};
    gst_all_1 = callPackage ./kms-gst {};
  };

  freeswitchPackages = rec {
    sofia_sip = callPackage ./sofia-sip {};
    spandsp = callPackage ./spandsp {};
    freeswitch = callPackage ./freeswitch {
      inherit sofia_sip spandsp;
      libopusenc = libopusenc.overrideAttrs (oA: {
        postFixup = ''
          sed -i 's_opus.h_opus/opus.h_g' $dev/include/opus/opusenc.h
        '';
      });
    };
  };
}
