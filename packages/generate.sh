#!/usr/bin/env nix-shell
#!nix-shell -i bash -p git

# Generate all BBB packages and update their dependencies

set -euo pipefail
cd "$(dirname "${0}")"
. ./utils.sh

msg() {
	echo -e '-> \e[31m'"${1}"'\e[0m'
}

# Prepare sources and checkouts
msg "Generating sources"
./sources/generate.sh
msg "Checking out sources"
./checkouts/checkout-from-nix.sh
./checkouts/fetch-static.sh

# Kurento
if oneIsChanged sources/kurento-module-creator/* kurento-module-creator/*; then
	msg "Building kurento-module-creator"
	kurento-module-creator/generate.sh
fi

# Scala libraries
if oneIsChanged sources/bigbluebutton/* bbb-common-message/*; then
	msg "Building bbb-common-message"
	bbb-common-message/generate.sh
fi
if oneIsChanged sources/bigbluebutton/* bbb-fsesl-client/*.nix; then
	msg "Building bbb-fsesl-client"
	bbb-fsesl-client/generate.sh
fi
if oneIsChanged sources/bigbluebutton/* bbb-common-message/*.nix bbb-common-web/*.nix; then
	msg "Building bbb-common-web"
	bbb-common-web/generate.sh
fi

# Scala programs
if oneIsChanged sources/bigbluebutton/* bbb-common-message/* bbb-akka-apps/*; then
	msg "Building bbb-akka-apps"
	bbb-akka-apps/generate.sh
fi
if oneIsChanged sources/bigbluebutton/* bbb-common-message/* bbb-fsesl-client/* bbb-akka-fsesl/*; then
	msg "Building bbb-akka-fsesl"
	bbb-akka-fsesl/generate.sh
fi

# Java programs
if oneIsChanged sources/bigbluebutton/* bbb-common-message/* bbb-common-web/* bbb-web/*; then
	msg "Building bbb-web"
	bbb-web/generate.sh
fi

# Node "programs"
if oneIsChanged sources/bbb-webrtc-sfu/* bbb-webrtc-sfu/*; then
	msg "Building bbb-webrtc-sfu"
	bbb-webrtc-sfu/generate.sh
fi
if oneIsChanged sources/bbb-etherpad-lite/* bbb-etherpad-lite/*; then
	msg "Building bbb-etherpad-lite"
	bbb-etherpad-lite/generate.sh
fi
if oneIsChanged bbb-html5/*; then
	msg "Building bbb-html5"
	bbb-html5/generate.sh
fi

# Ruby programs
if oneIsChanged sources/bbb-greenlight/* bbb-greenlight/*; then
	msg "Building bbb-greenlight"
	bbb-greenlight/generate.sh
fi
