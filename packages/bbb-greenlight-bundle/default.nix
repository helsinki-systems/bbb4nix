{ stdenvNoCC, lib, makeWrapper, bbbPackages }: let

  greenlight = bbbPackages.greenlight;

in stdenvNoCC.mkDerivation {
  pname = "bbb-greenlight-bundle";
  inherit (greenlight) version;

  dontUnpack = true;
  dontConfigure = true;
  dontBuild = true;

  nativeBuildInputs = [ makeWrapper ];

  # XXX:
  # Would be nicer to get these variables from the unit file or something
  # like this but I'm currently too pissed off to do this. Works for me
  installPhase = ''
    mkdir -p $out/bin

    makeWrapper ${greenlight.rubyEnv}/bin/bundle $out/bin/bbb-greenlight-bundle \
      --set HOME /var/lib/bbb-greenlight/home \
      --set DISABLE_SPRING 1 \
      --set-default RAILS_ENV production \
      --set-default GEM_PATH ${greenlight.rubyEnv}/lib/ruby/gems \
      --set-default DB_ADAPTER postgresql \
      --set-default DB_HOST 127.0.0.1 \
      --set-default DB_NAME greenlight \
      --set-default DB_USERNAME greenlight \
      --prefix PATH : ${lib.makeBinPath (with greenlight; [ nodejs rubyEnv ])} \
      --run 'cd ${greenlight}' \
      --run '. /var/lib/secrets/bbb-greenlight/env'
  '';
}
