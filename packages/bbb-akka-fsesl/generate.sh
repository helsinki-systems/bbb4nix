#!/usr/bin/env bash

set -euo pipefail
cd "$(dirname "${0}")"
. ../utils.sh

sbtixLoad

# Generate nix expressions
cd ../checkouts/bigbluebutton/akka-bbb-fsesl
sbtix-gen-all2

# Patch sbtix files
sbtixFixLocal

# Copy back expressions
cp -vf repo.nix manual-repo.nix ../../../bbb-akka-fsesl/
cp -vf project/repo.nix ../../../bbb-akka-fsesl/project-repo.nix

# Test build
cd ../..
buildProject bbb-akka-fsesl
