{ writeScriptBin, lib, openssl, pwgen }:
let
  opensslBin = "${lib.getBin openssl}/bin/openssl";
  pwgenBin = "${lib.getBin pwgen}/bin/pwgen";
in writeScriptBin "bbb-generate-secrets" ''
  set -eu

  # https://github.com/bigbluebutton/docker/blob/master/setup.sh#L142
  TURN_SECRET=$(${opensslBin} rand -hex 16)
  # https://github.com/bigbluebutton/bigbluebutton/blob/master/labs/docker/README.md
  SHARED_SECRET=$(${opensslBin} rand -hex 16)
  SECRET_KEY_BASE=$(${opensslBin} rand -hex 64)
  COTURN_REST_SECRET=$(${opensslBin} rand -hex 16)

  cd /var/lib/secrets
  mkdir -p bbb-greenlight bigbluebutton

  function createIfNotExists() {
    if [ ! -f "$1" ]; then
      echo "$2" > "$1"
    else
      echo "$1 already exists, not overwriting"
    fi
  }

  createIfNotExists bbb-greenlight/env "export SECRET_KEY_BASE=$SECRET_KEY_BASE
  export BIGBLUEBUTTON_SECRET=$SHARED_SECRET
  export DB_PASSWORD=$(${pwgenBin} 32 1)
  export SMTP_PASSWORD=$(${pwgenBin} 32 1)
  ADMIN_PASSWORD=$(${pwgenBin} 32 1)"

  createIfNotExists bigbluebutton/bbb-akka-apps.conf "services {
    sharedSecret = \"$SHARED_SECRET\"
  }"

  createIfNotExists bigbluebutton/bbb-web.properties "securitySalt=$SHARED_SECRET"
  createIfNotExists bigbluebutton/bbb-web-turn "$COTURN_REST_SECRET"
''
