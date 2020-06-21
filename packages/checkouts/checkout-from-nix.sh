#!/usr/bin/env bash

# Checks out all projects that have nix expressions.
# Checkouts will always be removed and overwritten to ensure the repos are clean.

set -euo pipefail
cd "$(dirname "${0}")"

checkout() {
	rm -rf "${1}"
	cp -r "$(nix-build --no-out-link --expr "(import <nixpkgs> {}).pkgs.callPackage ../sources/${1} {}")" "${1}"
	chmod -R +w "${1}"
}

checkout mavenix
checkout kurento-module-creator

checkout bigbluebutton
checkout bbb-webrtc-sfu
