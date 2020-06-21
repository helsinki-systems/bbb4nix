{ callPackage, unzip, jre_headless, turnStunServers ? "turn-stun-servers.xml" }: let
  buildGradle = callPackage ../x2nix/gradle-env.nix {};
  src = callPackage ../sources/bigbluebutton {};

in buildGradle {
  envSpec = ./gradle-env.json;
  pname = "bbb-web";
  inherit (src) version;

  src = "${src}/bigbluebutton-web";

  extraDeps = [
    "${callPackage ../bbb-common-message {}}/repository"
    "${callPackage ../bbb-common-web {}}/repository"
  ];
  gradleFlags = [ "assemble" ];

  nativeBuildInputs = [ unzip ];

  postPatch = ''
    sed -i 's@TURN_STUN_SERVERS@${turnStunServers}g' grails-app/conf/spring/resources.xml
  '';

  installPhase = ''
    runHook preInstall

    mkdir -p $out/share/bbb-web
    unzip build/libs/* -d $out/share/bbb-web

    mkdir $out/bin
    cat > $out/bin/bbb-web <<'EOF'
    #!/bin/sh
    set -e
    cd "${placeholder "out"}/share/bbb-web"
    exec ${jre_headless}/bin/java \
      -Dgrails.env=prod \
      -Dserver.address=127.0.0.1 \
      -Dserver.port=8090 \
      -Xms384m \
      -Xmx384m \
      -cp WEB-INF/lib/*:/:WEB-INF/classes/:. \
      $@ \
      org.springframework.boot.loader.WarLauncher
    EOF
    chmod +x $out/bin/bbb-web

    runHook postInstall
  '';
}
