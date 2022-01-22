#!/usr/bin/env nix-shell
#!nix-shell -i bash -p yarn
set -eu -o pipefail
cd "$(dirname "${0}")"
. ../utils.sh

cd ../checkouts/bbb-etherpad-lite/src
yarn import
rm package-lock.json
yarn add git+https://github.com/mconf/ep_pad_ttl.git#main ep_delete_after_delay_lite ep_better_pdf_export
cp -vf package.json yarn.lock ../../../bbb-etherpad-lite

cd ../..
buildProject bbb-etherpad-lite
