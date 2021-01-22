{ stdenv, lib, callPackage, bundlerEnv, defaultGemConfig, ruby, makeWrapper, dockerignored, nodejs, yarn
, pkgconfig, zlib, libxml2, libxslt }:
let
  src = callPackage ../sources/bbb-greenlight {};
  inherit (src) version;
  rubyEnv = bundlerEnv rec {
    name = "bbb-greenlight-env-${version}";
    inherit ruby version;
    gemdir = ./.;
    gemConfig = defaultGemConfig // {
      nokogiri = attrs: {
        buildFlags = [
          "--use-system-libraries"
        ];

        buildInputs = [ pkgconfig zlib libxml2 libxslt ];
      };
    };
  };
in stdenv.mkDerivation {
  pname = "bbb-greenlight";
  inherit version;
  inherit src;

  patches = [
    ./joinmod.patch
  ];

  nativeBuildInputs = [ makeWrapper dockerignored rubyEnv nodejs yarn ];
  buildPhase = ''
    rake assets:precompile RAILS_ENV=production SECRET_KEY_BASE=NOUKTHXBYE
    sed -i 's_bundle exec rake assets:precompile__' -i bin/start
    rm -rf tmp log
  '';

  installPhase = ''
    mkdir -p $out
    cp -R ./. $out/
    ln -s /run/bbb-greenlight/tmp $out/tmp
    ln -s /run/bbb-greenlight/log $out/log
    ln -s ${rubyEnv} $out/env
  '';

  preFixup = ''
    for exe in $out/bin/*; do
      substituteInPlace "$exe" \
        --replace "/usr/bin/env ruby" ${ruby}/bin/ruby
    done
  '';

  meta = with lib; {
    description = "A really simple end-user interface for your BigBlueButton server";
    homepage    = "https://github.com/bigbluebutton/greenlight/";
    license     = with licenses; lgpl3;
    maintainers = with maintainers; [ ajs124 ];
  };
}
