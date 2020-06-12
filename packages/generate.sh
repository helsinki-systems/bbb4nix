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
