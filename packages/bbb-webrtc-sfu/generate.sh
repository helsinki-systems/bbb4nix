#!/usr/bin/env nix-shell
#!nix-shell -i bash -p nodePackages.node2nix

set -euo pipefail
cd "$(dirname "${0}")"
. ../utils.sh


# Generate nix expressions
cd ../checkouts/bbb-webrtc-sfu
node2nix -l package-lock.json

# Copy back expressions
cp -vf node-packages.nix ../../bbb-webrtc-sfu/

# Test build
cd ..
buildProject bbb-webrtc-sfu
