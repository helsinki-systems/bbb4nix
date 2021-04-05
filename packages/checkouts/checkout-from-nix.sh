#!/usr/bin/env bash

# Checks out all projects that have nix expressions.
# Checkouts will always be removed and overwritten to ensure the repos are clean.

set -euo pipefail
cd "$(dirname "${0}")"

checkout() {
	rm -rf "${1}"
	cp -r "$(nix-build --no-out-link --expr "(import <unstable> {}).callPackage ../sources/${1} {}")" "${1}"
	chmod -R +w "${1}"
}

checkout mvn2nix
checkout kurento-module-creator

checkout sbtix
checkout bigbluebutton
checkout bbb-webrtc-sfu
checkout bbb-greenlight
checkout bbb-etherpad-lite
