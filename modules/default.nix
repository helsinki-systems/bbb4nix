{
  imports = [
    # BBB components
    ./akka-apps.nix
    ./akka-fsesl.nix
    ./web.nix
    # Third-party components
    ./soffice.nix
    ./kurento-media-server.nix
  ];
}
