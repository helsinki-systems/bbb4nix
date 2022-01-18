{ fetchFromGitLab, buildGoModule, makeWrapper,
  B3SCALE_DB_URL ? "user=b3scale host=/run/postgresql dbname=b3scale",
  BBB_CONFIG ? "/run/bbb-web/bigbluebutton.properties"
}:
buildGoModule rec {
  pname = "b3scale";
  version = "0.12.0";

  src = fetchFromGitLab {
    group = "infra.run";
    owner = "public";
    repo = pname;
    rev = version;
    sha256 = "010dqiqym18m3rmrm4jvzr8dyldzpkqdh2in9m7jjmygkymj1dmk";
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

  vendorSha256 = "16s1j7k7399lg9rw24gy0rwa8f9jbkr9p2j3i390hmma9vc98mv4";
}
