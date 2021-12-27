{ fetchFromGitLab, buildGoModule, makeWrapper,
  B3SCALE_DB_URL ? "user=b3scale host=/run/postgresql dbname=b3scale",
  BBB_CONFIG ? "/run/bbb-web/bigbluebutton.properties"
}:
buildGoModule rec {
  pname = "b3scale";
  version = "0.14.0";

  src = fetchFromGitLab {
    group = "infra.run";
    owner = "public";
    repo = pname;
    rev = version;
    sha256 = "1cydaqar36mianxf6an3gmf3da53wgb10crm9wv7ff4hw608xcll";
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

  vendorSha256 = "1i8apzpgcrsl0myanmkgg5snva2j0n81nq8scx9dxajsn4qnj66c";
}
