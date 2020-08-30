{ mkYarnPackage, callPackage, fetchurl }:
let
  src = callPackage ../sources/bbb-etherpad-lite {};

  settingsJson = fetchurl {
    url = "https://raw.githubusercontent.com/alangecker/bbb-packages/0e8842a05cca62d8d2e9d2ec037f7ff24e8d73be/bbb-etherpad/data/usr/share/etherpad-lite/settings.json";
    sha256 = "sha256-blvsVpdWsGNnYC7zf0q0S6kd0eDJv1Tv1l3+ow0Jh+o=";
  };
in mkYarnPackage {
  pname = "bbb-etherpad-lite";
  src = "${src}/src";
  inherit (src) version;

  packageJSON = ./package.json;
  yarnLock = ./yarn.lock;
  patches = [
    ./argv-absolute.patch
    ./ep-initialize.patch
    ./strip-src-from-path.patch
  ];

  prePatch = ''
    substituteInPlace node/utils/AbsolutePaths.js \
      --replace "var etherpadRoot = null;" "var etherpadRoot = \"$out/libexec/ep_etherpad-lite/deps/ep_etherpad-lite\";"
    substituteInPlace static/js/pluginfw/plugins.js \
      --replace "npm.dir, '..'" "npm.dir, \"$out/libexec/ep_etherpad-lite\""
    substituteInPlace node/utils/Settings.js \
      --replace 'var version = "";' 'return "no_u";'
  '';

  postInstall = ''
    rm $out/libexec/ep_etherpad-lite/node_modules/ep_etherpad-lite/node_modules
    ln -s $out/libexec/ep_etherpad-lite/node_modules $out/libexec/ep_etherpad-lite/node_modules/ep_etherpad-lite/node_modules
    ln -s $out/libexec/ep_etherpad-lite/node_modules/html-pdf $out/libexec/ep_etherpad-lite/node_modules/ep_better_pdf_export/node_modules/

    cp ${settingsJson} $out/libexec/ep_etherpad-lite/deps/ep_etherpad-lite/settings.json
  '';
}
