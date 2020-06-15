#!/usr/bin/env bash

set -euo pipefail
cd "$(dirname "${0}")"
. ../utils.sh

sbtixLoad

# Generate nix expressions
cd ../checkouts/bigbluebutton/bbb-fsesl-client
sbtix-gen-all2

# Patch sbtix files
sbtixDoLibrary
sbtixFixLocal

# Copy back expressions
cp -vf repo.nix manual-repo.nix ../../../bbb-fsesl-client/
cp -vf project/repo.nix ../../../bbb-fsesl-client/project-repo.nix

# Test build
cd ../..
buildProject bbb-fsesl-client
