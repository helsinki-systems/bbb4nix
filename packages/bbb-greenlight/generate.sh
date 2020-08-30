#!/usr/bin/env nix-shell
#! nix-shell -i bash -p bundix git stdenv

set -eu -o pipefail
cd "$(dirname "${0}")"
. ../utils.sh

cd ../checkouts/bbb-greenlight
bundix
cp -vf ./[Gg]em* ../../bbb-greenlight

cd ..
buildProject bbb-greenlight
