{ stdenv, lib, callPackage, bundlerEnv, defaultGemConfig, ruby, rubyPackages, makeWrapper, dockerignored, nodejs, yarn
, pkg-config, zlib, libxml2, libxslt, shared-mime-info, cacert }:
let
  src = callPackage ../sources/bbb-greenlight {};
  inherit (src) version;
  rubyEnv = bundlerEnv rec {
    name = "bbb-greenlight-env-${version}";
    inherit ruby version;
    gemdir = ./.;
    gemConfig = defaultGemConfig // {
      nokogiri = oA: {
        buildFlags = [
          "--use-system-libraries"
        ];

        buildInputs = [ pkg-config zlib libxml2 libxslt ];
      };
      mimemagic = oA: {
        buildInputs = with rubyPackages; [ rake ];
        FREEDESKTOP_MIME_TYPES_PATH="${shared-mime-info}/share/mime/packages/freedesktop.org.xml";
      };
    };
  };
in stdenv.mkDerivation {
  pname = "bbb-greenlight";
  inherit version;
  inherit src;

  postPatch = ''
    sed -i 's#|| @shared_room##' app/controllers/concerns/joiner.rb
  '';

  nativeBuildInputs = [ makeWrapper dockerignored rubyEnv nodejs yarn ];
  buildPhase = ''
    export SSL_CERT_FILE=${cacert}/etc/ssl/certs/ca-bundle.crt  # needed for omniauth-twitter -.-
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

  passthru = {
    inherit rubyEnv nodejs;
  };

  meta = with lib; {
    description = "A really simple end-user interface for your BigBlueButton server";
    homepage    = "https://github.com/bigbluebutton/greenlight/";
    license     = with licenses; lgpl3;
    maintainers = with maintainers; [ ajs124 ];
  };
}
