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
		| cut -d'/' -f3 \
		| sort -n \
		| tail -n1 \
		| tr -d '\n' > "${dir}/version"
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
		| cut -d'/' -f3 \
		| sort -n \
		| tail -n1 \
		| tr -d '\n' > "${dir}/version"
	if oneIsChanged "${dir}"/*; then
		prepareRawSource "${dir}" "${owner}" "${repo}"
	fi
}

# For projects that don't do releases, but where HEAD (master) seems legit
updateHEAD() {
	dir="${1}"
	owner="${2}"
	repo="${3}"
	mkdir -pv "${dir}"
	git ls-remote "https://github.com/${owner}/${repo}" HEAD | awk '{print $1}' | tr -d '\n' > "${dir}/version"
	if oneIsChanged "${dir}"/*; then
		prepareRawSource "${dir}" "${owner}" "${repo}"
	fi
}

# Fetch the current files from the bigbluebutton repo
doBbbRepo() {
	mkdir -pv bigbluebutton-repo
	curl -Lo bigbluebutton-repo/packages https://ubuntu.bigbluebutton.org/xenial-22/dists/bigbluebutton-xenial/main/binary-amd64/Packages
	neededPackages=(bbb-freeswitch-sounds bbb-freeswitch-core)
	pkg=
	ver=
	filename=
	sha256=
	while IFS= read -r line; do
		if [[ "${line}" =~ ^Package: ]]; then
			# We have a full package
			# shellcheck disable=SC2076
			if [[ -n "${pkg:-}" && "${neededPackages[*]}" == *"${pkg}"* ]]; then
				mkdir -pv "${pkg}"
				{
					echo '{ fetchurl }:'
					echo
					echo 'fetchurl {'
					echo "  url = \"https://ubuntu.bigbluebutton.org/xenial-22/${filename}\";"
					echo "  sha256 = \"${sha256}\";"
					echo '}'
				} > "${pkg}/raw-source.nix"
				echo -n "${ver}" > "${pkg}/version"
			fi
			# Begin parsing the next package
			pkg="$(echo "${line}" | cut -d' ' -f2-)"
			continue
		fi
		if [[ "${line}" =~ ^Version: ]]; then
			ver="$(echo -n "${line}" | cut -d' ' -f2- | cut -d':' -f2-)"
			continue
		fi
		if [[ "${line}" =~ ^Filename: ]]; then
			filename="$(echo "${line}" | cut -d' ' -f2-)"
			continue
		fi
		if [[ "${line}" =~ ^SHA256: ]]; then
			sha256="$(echo "${line}" | cut -d' ' -f2-)"
			continue
		fi
	done < bigbluebutton-repo/packages
}

updateHEAD mvn2nix fzakaria mvn2nix

updateByTagWithoutV kms-cmake-utils Kurento kms-cmake-utils
updateByTagWithoutV kmsjsoncpp Kurento jsoncpp
updateByTagWithoutV libsrtp-kurento Kurento libsrtp
updateByTagWithoutV kurento-module-creator Kurento kurento-module-creator
updateByTagWithoutV kms-jsonrpc Kurento kms-jsonrpc
updateByTagWithoutV kms-core Kurento kms-core
updateByTagWithoutV kms-elements Kurento kms-elements
updateByTagWithoutV kms-filters Kurento kms-filters
updateByTagWithoutV kurento-media-server Kurento kurento-media-server

doBbbRepo
update bigbluebutton bigbluebutton bigbluebutton
update bbb-webrtc-sfu bigbluebutton bbb-webrtc-sfu
