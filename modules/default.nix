{
  imports = [
    ./simple.nix
    # BBB components
    ./akka-apps.nix
    ./akka-fsesl.nix
    ./web.nix
    ./webrtc-sfu.nix
    ./greenlight.nix
    ./html5.nix
    # patched
    ./etherpad-lite.nix
    # Third-party components
    ./freeswitch.nix
    ./kurento-media-server.nix
    ./soffice.nix
  ];

  systemd.targets.bigbluebutton = {
    description = "Big Blue Button";
    wantedBy = [ "multi-user.target" ];
  };
}
