{ fetchFromGitLab, buildGoModule, makeWrapper,
  B3SCALE_DB_URL ? "user=b3scale host=/run/postgresql dbname=b3scale",
  BBB_CONFIG ? "/run/bbb-web/bigbluebutton.properties"
}:
buildGoModule rec {
  pname = "b3scale";
  version = "0.10.1";

  src = fetchFromGitLab {
    group = "infra.run";
    owner = "public";
    repo = pname;
    rev = version;
    sha256 = "1khxsspw1r6ci24lcixdqsbp6hmhly0lggzwmjl278jpi1sp6x43";
  };

  nativeBuildInputs = [ makeWrapper ];

  postInstall = ''
    pushd $out/bin
    ls | while read prog; do
      hidden=".''${prog}-wrapped"
      mv "$prog" "$hidden"
      makeWrapper "$PWD/$hidden" "$prog" \
        --argv0 "$prog" \
        --set-default B3SCALE_DB_URL "${B3SCALE_DB_URL}" \
        --set-default BBB_CONFIG "${BBB_CONFIG}"
    done
    popd
  '';

  # tries to connect to a database and stuff
  doCheck = false;

  vendorSha256 = "1z15vw3l015wc9kaga4svy2j5lfr99pndz3lgqsd0b23nhsbazik";
}
