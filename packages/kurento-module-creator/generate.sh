#!/usr/bin/env bash

set -euo pipefail
cd "$(dirname "${0}")"
. ../utils.sh

rm -rf ~/.m2
PATH="$(nix-build --no-out-link ../checkouts/mvn2nix -A mvn2nix)/bin:${PATH}"
export PATH

# Generate lock
cd ../checkouts/kurento-module-creator
mvn2nix > dependencies.nix

# Copy back dependencies.nix
cp -vf dependencies.nix ../../kurento-module-creator

# Test build
cd ..
buildProject kurento-module-creator
