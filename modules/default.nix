{
  imports = [
    ./simple.nix
    # BBB components
    ./akka-apps.nix
    ./akka-fsesl.nix
    ./web.nix
    ./webrtc-sfu.nix
    # patched
    ./etherpad-lite.nix
    # Third-party components
    ./freeswitch.nix
    ./kurento-media-server.nix
    ./soffice.nix
  ];
}
