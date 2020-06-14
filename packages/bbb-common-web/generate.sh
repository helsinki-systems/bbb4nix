#!/usr/bin/env bash

set -euo pipefail
cd "$(dirname "${0}")"
. ../utils.sh

sbtixLoad

# Generate nix expressions
cd ../checkouts/bigbluebutton/bbb-common-web
sbtix-gen-all2

# Patch sbtix files
sbtixDoLibrary
sbtixFixLocal

# Inject dependencies
sed -i '$ d' default.nix
cat >> default.nix <<EOF
	sbtixBuildInputs = [
		(callPackage ../../../bbb-common-message {})
	];
}
EOF

# Copy back expressions
cp -vf repo.nix manual-repo.nix ../../../bbb-common-web/
cp -vf project/repo.nix ../../../bbb-common-web/project-repo.nix

# Test build
cd ../..
buildProject bbb-common-web
