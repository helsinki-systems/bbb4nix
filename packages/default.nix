{ callPackage, lib, newScope, libopusenc }:

lib.makeScope newScope (self: {
  bbbPackages = {
    akkaApps = self.callPackage ./bbb-akka-apps {};
    akkaFsesl = self.callPackage ./bbb-akka-fsesl {};
    blankSlides = self.callPackage ./bbb-blank-slides {};
    etherpad-lite = self.callPackage ./bbb-etherpad-lite {};
    freeswitchConfig = self.callPackage ./bbb-freeswitch-config {};
    generateSecrets = self.callPackage ./bbb-generate-secrets {};
    greenlight = self.callPackage ./bbb-greenlight {};
    greenlight-bundle = self.callPackage ./bbb-greenlight-bundle {};
    html5 = self.callPackage ./bbb-html5/wrapper.nix {};
    html5-unwrapped = self.callPackage ./bbb-html5 {};
    recordAndPlaybackPresentation = self.callPackage ./bbb-record-and-playback-presentation {};
    web = self.callPackage ./bbb-web {};
    webrtcSfu = self.callPackage ./bbb-webrtc-sfu {};
  };

  kurentoPackages = {
    kurento-media-server = self.callPackage ./kurento-media-server {};
    kms-core = self.callPackage ./kms-core {};
    kms-elements = self.callPackage ./kms-elements {};
    kms-filters = self.callPackage ./kms-filters {};
    gst_all_1 = self.callPackage ./kms-gst {};
  };

  freeswitchPackages = rec {
    sofia_sip = self.callPackage ./sofia-sip {};
    spandsp = self.callPackage ./spandsp {};
    freeswitch = self.callPackage ./freeswitch {
      inherit sofia_sip spandsp;
      libopusenc = libopusenc.overrideAttrs (oA: {
        postFixup = ''
          sed -i 's_opus.h_opus/opus.h_g' $dev/include/opus/opusenc.h
        '';
      });
    };
  };

  b3scale = self.callPackage ./b3scale {};
  bbb-soffice-conversion-server = self.callPackage ./bbb-soffice-conversion-server {};
})
