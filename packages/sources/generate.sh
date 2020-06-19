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
		sed -E 's/.*"([^"]+)".*/\1/'
}

# Generate the correct raw-source.nix for a repository
prepareRawSource() {
	{
		echo '{ fetchFromGitHub }: fetchFromGitHub {'
		echo "  owner = \"${2}\";"
		echo "  repo = \"${3}\";"
		echo "  rev = \"$(< "${1}/version")\";"
		echo '  sha256 = "0000000000000000000000000000000000000000000000000000";'
		echo '}'
	} > "${1}/raw-source.nix"

	# Fix hash
	set +e
	out="$(nix-build --no-out-link --expr "(import <nixpkgs> {}).pkgs.callPackage ./${1}/raw-source.nix {}" 2>&1 | tee /dev/stderr)"
	set -e
	got="$(echo "${out}" | grep got: | awk '{ print $2 }')"
	sed -i "s:\"0*\":\"${got}\":g" "${1}/raw-source.nix"
}

# Updates a repository to the latest version and fixes the sources
update() {
	dir="${1}"
	owner="${2}"
	repo="${3}"
	mkdir -pv "${dir}"
	latestVersionOfRepo "${owner}/${repo}" | tr -d '\n' > "${dir}/version"
	if oneIsChanged "${dir}"/*; then
		prepareRawSource "${dir}" "${owner}" "${repo}"
	fi
}

# Same as update() but for the Kurento garbage since they don't use releases for some reason (thanks for nothing)
updateByTag() {
	dir="${1}"
	owner="${2}"
	repo="${3}"
	mkdir -pv "${dir}"
	git ls-remote --tags "https://github.com/${owner}/${repo}" \
		| grep -v svn \
		| grep -v '{}' \
		| awk '{print $2}' \
		| sort -n \
		| tail -n1 \
		| cut -d'/' -f3 | tr -d '\n' > "${dir}/version"
	if oneIsChanged "${dir}"/*; then
		prepareRawSource "${dir}" "${owner}" "${repo}"
	fi
}

# Same as updateByTag() but excludes v... versions
updateByTagWithoutV() {
	dir="${1}"
	owner="${2}"
	repo="${3}"
	mkdir -pv "${dir}"
	git ls-remote --tags "https://github.com/${owner}/${repo}" \
		| grep -v svn \
		| grep -v '{}' \
		| grep 'tags/[0-9]' \
		| awk '{print $2}' \
		| sort -n \
		| tail -n1 \
		| cut -d'/' -f3 | tr -d '\n' > "${dir}/version"
	if oneIsChanged "${dir}"/*; then
		prepareRawSource "${dir}" "${owner}" "${repo}"
	fi
}

updateByTag mavenix nix-community mavenix

updateByTagWithoutV kms-cmake-utils Kurento kms-cmake-utils
updateByTagWithoutV kmsjsoncpp Kurento jsoncpp
updateByTagWithoutV libsrtp-kurento Kurento libsrtp
updateByTagWithoutV kurento-module-creator Kurento kurento-module-creator
updateByTagWithoutV kms-jsonrpc Kurento kms-jsonrpc
updateByTagWithoutV kms-core Kurento kms-core
updateByTagWithoutV kms-elements Kurento kms-elements
updateByTagWithoutV kms-filters Kurento kms-filters
updateByTagWithoutV kurento-media-server Kurento kurento-media-server

#update bigbluebutton bigbluebutton bigbluebutton
