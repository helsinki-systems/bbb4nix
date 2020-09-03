#!/usr/bin/env nix-shell
#! nix-shell -i bash -p bundix git stdenv

set -eu -o pipefail
cd "$(dirname "${0}")"
. ../utils.sh

cd ../checkouts/bigbluebutton/record-and-playback/core
bundix
cp -vf ./[Gg]em* ../../../../bbb-record-and-playback-scripts/

cd ../../..
buildProject bbb-record-and-playback-scripts
