{ stdenv, callPackage, python2 }: let
  meteor = callPackage ../sources/meteor {};
  src = callPackage ../sources/bigbluebutton {};
in stdenv.mkDerivation {
  inherit (src) version;
  pname = "bbb-html5-meteor-bundle";
  src = "${src}/bigbluebutton-html5";

  nativeBuildInputs = [ meteor python2 ];

  configurePhase = ''
    export HOME=$PWD/../home
    #rm package-lock.json
    #find /build -type f | grep 'tools/cli/main.js$' | while read -r js; do
    #  sed -i 's_require..kexec....*, newArgv.;_console.log("kexecing from springboard to:", executable, newArgv); require("kexec")(executable, newArgv);_g' "$js"
    #done
    #patchShebangs $HOME/.meteor
    meteor update --packages-only
  '';

  buildPhase = ''
    meteor npm install
    meteor build --server-only --directory ../bundle
  '';

  installPhase = ''
    mkdir -p $out
    find ../bundle -name '.resolve-garbage-*' -exec rm -rf {} +
    cp -R ../bundle/bundle/. $out/
  '';

  outputHashMode = "recursive";
  outputHash = "sha256-jy9c+/47ytnstkQE3dqSFiqqMXbR/kbf9fp52VmCis4=";
}
