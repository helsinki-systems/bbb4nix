#!/usr/bin/env bash

set -euo pipefail
cd "$(dirname "${0}")"
. ../utils.sh

PATH="$(nix-build --no-out-link ../checkouts/mavenix)/bin:${PATH}"
export PATH

# Generate lock
cd ../checkouts/kurento-module-creator
mvnix-init
mvnix-update

# Copy back lock
cp -vf mavenix.lock ../../kurento-module-creator

# Test build
cd ..
buildProject kurento-module-creator
