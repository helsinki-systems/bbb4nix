#!/usr/bin/env bash
set -euo pipefail
cd "$(dirname "${0}")"

function fixOutput {
    sed -i 's:outputHash = ".*":outputHash = "sha256-AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA=":' "$1"
    set +e
    out="$(nix-build --no-out-link --expr "(import <nixpkgs> {}).pkgs.callPackage ${1} {}" 2>&1 | tee /dev/stderr)"
    set -e
    got="$(echo "${out}" | grep got: | awk '{ print $2 }')"
    sed -i "s:\"sha256-A*=\":\"${got}\":" "${1}"
}

fixOutput ./meteor-bundle.nix
fixOutput ./default.nix
