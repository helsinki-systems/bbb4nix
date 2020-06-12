#!/usr/bin/env nix-shell
#!nix-shell -i bash -p curl git

# Generates all sources for each current GitHub version

set -euo pipefail
cd "$(dirname "${0}")"
. ../utils.sh

# Returns the latest GitHub version of a project
latestVersionOfRepo() {
	curl --silent "https://api.github.com/repos/${1}/releases/latest" |
		grep '"tag_name":' |
		sed -E 's/.*"v?([^"]+)".*/\1/'
}

# Generate the correct raw-source.nix for a repository
prepareRawSource() {
	{
		echo '{ fetchFromGitHub }: fetchFromGitHub {'
		echo "  owner = \"${2}\";"
		echo "  repo = \"${3}\";"
		echo "  rev = \"v$(< "${1}/version")\";"
		echo '  sha256 = "0000000000000000000000000000000000000000000000000000";'
		echo '}'
	} > "${1}/raw-source.nix"

	# Fix hash
	set +e
	out="$(nix-build --no-out-link --expr "(import <nixpkgs> {}).pkgs.callPackage ./${1}/raw-source.nix {}" 2>&1 | tee /dev/stderr)"
	set -e
	got="$(echo "${out}" | grep got: | awk '{ print $2 }')"
	sed -i "s/\"0*\"/\"${got}\"/g" "${1}/raw-source.nix"
}

# Updates a repository to the latest version and fixes the sources
update() {
	dir="${1}"
	owner="${2}"
	repo="${3}"
	latestVersionOfRepo "${owner}/${repo}" > "${dir}/version"
	if oneIsChanged "${dir}"/*; then
		prepareRawSource "${dir}" "${owner}" "${repo}"
	fi
}

update bigbluebutton bigbluebutton bigbluebutton
