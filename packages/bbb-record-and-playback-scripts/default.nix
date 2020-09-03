{ stdenv, callPackage  }: let
  src = callPackage ../sources/bigbluebutton {};
  inherit (src) version;
  rubyEnv = callPackage ./env.nix { };
in stdenv.mkDerivation {
  pname = "bbb-record-and-playback-presentations";
  inherit src version;

  installPhase = ''
    cp -r record-and-playback $out

    grep -Zrl '#!/usr/bin/ruby' $out | while read -r -d "" rb; do
      substituteInPlace "$rb" --replace '#!/usr/bin/ruby' '#!${rubyEnv.wrappedRuby}/bin/ruby'
    done

    mkdir -p $out/lib/systemd/
    mv $out/core/systemd $out/lib/systemd/system
    chmod -x $out/lib/systemd/system/*

    for i in $out/lib/systemd/system/* $out/core/scripts/bigbluebutton.yml; do
      substituteInPlace "$i" --replace /var/bigbluebutton /var/lib/bigbluebutton   # what's wrong with you?
      substituteInPlace "$i" --replace /var/freeswitch /var/lib/freeswitch
      substituteInPlace "$i" --replace /var/kurento /var/lib/kurento
      substituteInPlace "$i" --replace /usr/local/bigbluebutton "$out"
    done

    mv $out/core/scripts/bigbluebutton.yml $out/core/scripts/bigbluebutton.yml.default
    ln -s /run/bbb-rap/conf.json $out/core/scripts/bigbluebutton.yml
  '';
}
